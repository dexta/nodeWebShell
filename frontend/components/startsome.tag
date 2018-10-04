<startsome>
<!-- <div class="col-12"> -->
	<button class="btn btn-primary" data-runscript="performance" onclick={ startScript }>
		performance test rendering service
	</button>
<!-- </div> -->

<script>
	let that = this;

	this.startScript = (e) => {
		console.dir(e);
		console.log("click on "+e.target.dataset.runscript);
		superagent.get('/startscript/'+e.target.dataset.runscript).then( (res) => {
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

</script>
</startsome>