<terminal>
	<div class="row">
		<div show={infoline.msg} class="col-lg-3 col-md-3 col-xs-3">
		  <button type="button" class="btn btn-secondary">
		  	<span class="badge badge-secondary">
		  		<i class="fa fa-info-circle"></i>
		  	</span>
		  	{infoline.msg}
		  </button>
		</div>
		<div show={infoline.time} class="col-lg-4 col-md-4 col-xs-4">
		  <button type="button" class="btn btn-secondary">
		  	<span class="badge badge-secondary">
		  		<i class="fa fa-clock-o"></i>
		  	</span>
		  	{infoline.time}
		  </button>
		  
		</div>
		<div show={infoline.t} class="col-lg-4 col-md-4 col-xs-4">			  
		  <button type="button" class="btn btn-secondary">
		  	<span class="badge badge-secondary">
		  		<i class="fa fa-rotate-left"></i>
		  	</span>
		  	{infoline.t}
		  </button>
		</div>

		<div class="col-lg-12 col-md-12 col-xs-12" >
			<div id="terminal" class="terminal-container">
			</div>
		</div>
	</div>
<script>
let that = this;
this.term = new Terminal();
this.infoline = {};

this.on("mount", () => {
	this.term.open(document.getElementById('terminal'));
	this.term.focus();
	this.term.setOption('cursorBlink', true);
	this.term.fit();
});

  
socket.on('newLine', (line) => {
  let splitLines = line.replace(/\n$/,'').split("\n");
  for(let s in splitLines) {
	  that.term.writeln(splitLines[s]);	
  }
});

socket.on('sameLine', (line) => {
	// time="2018-10-05T06:02:28Z" level=info msg=Running i=0 t=2m34.945110349s
	let spl = line.split(" ");
	let lineObj = {};
	spl.forEach( (e,i) => { let sl = e.split("="); lineObj[sl[0]]=sl[1]; } );
	console.dir(lineObj);
	that.infoline = lineObj;
	that.update();
});

</script>

</terminal>