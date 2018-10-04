<terminal>
	<div class="row">
		<div class="col-lg-12 col-md-12 col-xs-12" >
			<span ref="sameline">nix</span>
		</div>
		<div class="col-lg-12 col-md-12 col-xs-12" >
			<div id="terminal" class="terminal-container">
			</div>
		</div>
	</div>
<script>
let that = this;
this.term = new Terminal();

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
	that.refs.sameline.innerHTML = line;
});

</script>

</terminal>