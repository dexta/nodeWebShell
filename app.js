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


app.post('/startscript', (req, res) => {
  console.dir(req.body);
  let tSs = `#!/bin/bash

echo "start temp Script "\n`;
  for(let b in req.body) {
    tSs += `${b}=${req.body[b]}\n`;
  }


  // env varibales before k6 bin is called
  if(req.body.statOutput||false) tSs += 'K6_OUT=influxdb=http://192.168.23.55:8086/k6 ';

  tSs += 'k6 run ';

  // cli options before test script paht
  if(req.body.runUser!=""||false) tSs += '-u '+req.body.runUser+' ';
  if(req.body.runTime!=""||false) tSs += '-d '+req.body.runTime+' ';

  if(req.body.scriptName!=""||false) {
    tSs += `"scripts/${req.body.scriptName}.js"\n`;
  } else {
    tSs += `"scripts/localhost.js"\n`;
  }

  tSs += `\n\n\n\necho "runner ends"\n`;


  fs.writeFile("./tmpFileNameWith.sh", tSs, (err) => {
    if(err) {
      res.status(400).send("cant write file");
    }

    // let chmoD = execCommand({cmd:'chmod',parameter:['755','./tmpFileNameWith.sh']});
    // let lslah = execCommand({cmd:'cat',parameter:['./tmpFileNameWith.sh']});
    let cmdBa = execCommand({cmd:'./tmpFileNameWith.sh',parameter:[]});
 
    res.status(200).json(cmdBa);
  });
  // res.status(200).json(req.body);
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

  // if(cmdObj.parameter.length===0) {
    // scriptSpawn = spawn(cmdObj.cmd, {detached: true});
  // } else {
    scriptSpawn = spawn(cmdObj.cmd, cmdObj.parameter,{detached: true});  
  // }
  
  state.run=true;
  state.stats=[];
  state.record=false;
  io.sockets.emit("status",state);
  scriptSpawn.stdout.on('data', function(data){
    let clrd = data.toString('utf-8');
    // .replace(/\r$/g, '\r\n');
    // console.log(clrd);
    state.lines.push(clrd);
    io.sockets.emit("newLine",clrd);
    
    if(clrd.indexOf("temp Script")!=-1) state.record=true
    if(state.record) state.stats.push(clrd);
    io.sockets.emit("status",state);
  });

  scriptSpawn.stderr.on('data', function(data){
    console.log("stderr Out: "+data.toString());
    io.sockets.emit("sameLine",data.toString('utf-8'));
    io.sockets.emit("status",state);
  });

  scriptSpawn.on('close', function (code){
    console.log(`child process exited with code ${code}`);
    io.sockets.emit("newLine", `exit: ${code}`);
    state.run=false;
    state.record=false;
    state.lastStats=state.stats;
    io.sockets.emit("status",state);
  });

  scriptSpawn.unref();
};

const welcomeLoop = () => {
  let allMsg = state.lines.join('');
  io.sockets.emit('newLine',allMsg);
};

module.exports = app;