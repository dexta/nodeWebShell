<hello>
<div class="input-group mb-3">
  <div class="input-group-prepend">
    <button class="btn btn-danger" onclick={ startTheMass }>when its done send me another one</button>
  </div>
  <input 	type="text" class="form-control" ref="commandLine"
  				placeholder="shell command" value="./testLoop.sh">
</div>
<script>
  let that = this;

  this.startTheMass = () => {
    let cmdAll = that.refs.commandLine.value.split(" ");
    let cmd = cmdAll.shift();

		superagent.post('/releasethekraken').send({cmd, parameter: cmdAll}).then( (res) => {
			console.dir(res.body);
		});
  };
  
</script>

</hello>