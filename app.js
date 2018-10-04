const fs = require('fs');
const express = require('express');
const app = express();
const bodyParser = require('body-parser');
const http = require('http').Server(app);
const io = require('socket.io')(http);

const DEFAULT_HOST = '0.0.0.0';
const DEFAULT_PORT = 3000;

const config = {};
const host = config.host || DEFAULT_HOST;
const port = config.port || DEFAULT_PORT;

let state = {run:false,lines:[]};
let scriptSpawn = {};


app.use(express.static('frontend'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: true}));

const { spawn } = require('child_process');


io.on('connection', function(socket){
  console.log('a user connected');
  welcomeLoop();
  socket.on('disconnect', function(){
    console.log('user disconnected');
  });
});


app.post('/releasethekraken', (req, res) =>{
  let plcmd = execCommand(req.body);
  if(plcmd||false) {
    res.status(404).json({err:plcmd.err,data:req.body});
  } else {
    res.status(200).json(req.body);
  }
});

app.get('/killscript', (req,res) => {
  try {
    process.kill(-scriptSpawn.pid);
    res.status(200).send('we killed it '+scriptSpawn.pid);
  } catch (e) {
    res.status(400).send('no killer found for ... '+scriptSpawn.pid);
  }
});

app.get('/startscript/:name', (req,res) => {
  // let cmd = 'K6_OUT=influxdb=http://lxmoncol02:8086/loadtests k6';
  // let parameter = `run scripts/${req.params.name}.js`;
  let cmd = './startScripts.sh';
  let parameter = ['-s',req.params.name];

  let opts = {cmd, parameter};
  console.dir(opts);
  let plcmd = execCommand(opts);
  if(plcmd||false) {
    res.status(404).json({err:plcmd.err,data:req.body});
  } else {
    res.status(200).json(req.body);
  }
});

http.listen(port, () => {
  console.log(`Running on http://${host}:${port}`); 
});

const execCommand = (cmdObj) => {
  console.log("execCommand parameter obj");
  console.dir(cmdObj);
  if(state.run) return {err:'A Command already running'}
  try {
    stats = fs.existsSync(cmdObj.cmd);
  } catch(e) {
    console.dir(e);
    return {err:'File does not exists'};
  }

  
  scriptSpawn = spawn(cmdObj.cmd, cmdObj.parameter,{detached: true});
  state.run=true;

  scriptSpawn.stdout.on('data', function(data){
    let clrd = data.toString('utf-8');
    // .replace(/\r$/g, '\r\n');
    // console.log(clrd);
    state.lines.push(clrd);
    io.sockets.emit("newLine",clrd);
  });

  scriptSpawn.stderr.on('data', function(data){
    console.log(data.toString());
    io.sockets.emit("sameLine",data.toString('utf-8'))
  });

  scriptSpawn.on('close', function (code){
    console.log(`child process exited with code ${code}`);
    io.sockets.emit("newLine", `exit: ${code}`);
    state.run=false;
  });

  scriptSpawn.unref();
};

const welcomeLoop = () => {
  let allMsg = state.lines.join('');
  io.sockets.emit('newLine',allMsg);
};

module.exports = app;