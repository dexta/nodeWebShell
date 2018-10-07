<startsome>
<div class="row">
 <div class="col-1">
	<button class="btn {  state.run ? 'btn-danger' : 'btn-info' }" onclick={ startWithParameter }>
		<i show={ state.run } class="fa fa-power-off"></i>
    <span hide={ state.run }>Start</span>
    <span show={ state.run }>Stop</span>
	</button>
 </div>

 <div class="col-3">
  <select class="custom-select" id="scriptSelect">
    <option value="localhost" selected>localhost</option>
    <option value="performance">Performance</option>
    <option value="performance-stage">Performance Stage</option>
    <option value="performance-live">Performance Live</option>
  </select>
 </div>

 <div class="col-2">
  <button class="btn { scriptOps.influx? 'btn-warning' : 'btn-success' }" onclick={ toggleInflux }>
    Influx
    <i class="fa fa-database"></i>
    <span hide={ scriptOps.influx }>On</span>
    <span show={ scriptOps.influx }>Off</span>
  </button>
 </div>

 <div class="col-2 input-group">
  <div class="input-group-prepend">
    <span class="input-group-text">
      <i class="fa fa-clock-o"></i>
    </span>
  </div>
  <input type="number" class="form-control" value="1" id="runDuration">
 </div>

 <div class="col-2 input-group">
  <div class="input-group-prepend">
    <span class="input-group-text">
      <i class="fa fa-user-times"></i>
    </span>
  </div>
  <input type="number" class="form-control" value="10" id="runMaxUser">
 </div>

<!--  <div class="col-2">
  <button class="btn btn-primary" data-runscript="localhost" onclick={ startScript }>
    test on localhost
  </button>
 </div>  -->
</div>
 
<script>
	let that = this;
  this.state = {run:false};
  this.scriptOps = {influx:true}

	this.startScript = (e) => {
		console.dir(e);
		console.log("click on "+e.target.dataset.runscript);
		superagent.get('/startscript/'+e.target.dataset.runscript).then( (res) => {
			console.dir(res.body);
		});
	};

  this.stopRunning = (e) => {
    superagent.get('/killscript').then( (res) => {
      console.log("return stopRunning");
      console.dir(res.body);
    });
  };

  this.startTheMass = () => {
    let cmdAll = that.refs.commandLine.value.split(" ");
    let cmd = cmdAll.shift();

		superagent.post('/releasethekraken').send({cmd, parameter: cmdAll}).then( (res) => {
			console.dir(res.body);
		});
  };

  this.startWithParameter = (e) => {
    if(that.state.run) {
      console.log("Stop the script");
      return that.stopRunning(e);
    }
    let scSe =document.getElementById('scriptSelect');
    let opts = {};
    opts.scriptName = scSe.item(scSe.selectedIndex).value || 'localhost';

    // opts.statOutput = 'influx';
    opts.statOutput = '';
    opts.runUser = document.getElementById('runMaxUser').value || 100;
    opts.runTime = document.getElementById('runDuration').value+"m" || '2m';
    superagent.post('/startscript').send(opts).then( (res) => {
      console.dir(res.body);
    });
  };
  
  this.toggleInflux = () => {
    that.scriptOps.influx = !that.scriptOps.influx;
    that.update();
  };


  socket.on('status', (serverStatus) => {
    console.dir(serverStatus);
    that.state = serverStatus;
    that.update();

    if(that.state.lastStats||false) {
      let allChecksStats = [];
      for(let l in that.state.lastStats) {
        let tline = that.state.lastStats[l];
        if(tline.indexOf('..:')!=-1) {
          let splLine = tline.split("\n");
          for(let sl in splLine) {
            allChecksStats.push(splLine[sl]);
          }
        }
      }
    console.log("last stat checks");
    console.dir(allChecksStats);
    }

  });
</script>
</startsome>