const fs = require('fs');
const express = require('express');
const app = express();
const bodyParser = require('body-parser');
const http = require('http').Server(app);
const io = require('socket.io')(http);

const DEFAULT_HOST = '0.0.0.0';
const DEFAULT_PORT = 3000;

const config = {};

let state = {run:false,lines:[]};

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

const host = config.host || DEFAULT_HOST;
const port = config.port || DEFAULT_PORT;



http.listen(port, () => {
  console.log(`Running on http://${host}:${port}`); 
});

const execCommand = (cmdObj) => {
  if(state.run) return {err:'A Command already running'}
  try {
    stats = fs.existsSync(cmdObj.cmd);
  } catch(e) {
    console.dir(e);
    return {err:'File does not exists'};
  }

  
  const ls = spawn(cmdObj.cmd, cmdObj.parameter);
  state.run=true;

  ls.stdout.on('data', function(data){
    let clrd = data.toString('utf-8');
    // .replace(/\r$/g, '\r\n');
    // console.log(clrd);
    state.lines.push(clrd);
    io.sockets.emit("newLine",clrd);
  });

  ls.stderr.on('data', function(data){
    console.log(data.toString());
  });

  ls.on('close', function (code){
    console.log(`child process exited with code ${code}`);
    io.sockets.emit("newLine", `exit: ${code}`);
    state.run=false;
  });
};

const welcomeLoop = () => {
  let allMsg = state.lines.join('');
  io.sockets.emit('newLine',allMsg);
};

module.exports = app;