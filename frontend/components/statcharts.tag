<statcharts>
<canvas id="statchart" width="400" height="400"></canvas>


<script>
let that = this;

this.chartdata = {
"group_duration": {"avg":"2.64ms" , "min":"894.7µs" , "med":"1.84ms", "max":"17.47ms", "p_90":"5.01ms", "p_95":"6.79ms"},
"http_req_blocked": {"avg":"7.45µs" , "min":"1.06µs" , "med":"1.84µs", "max":"602.84µs", "p_90":"3.32µs", "p_95":"4.31µs"},
"http_req_connecting": {"avg":"4.6µs" , "min":"0s" , "med":"0s", "max":"536.57µs", "p_90":"0s     ", "p_95":"0s"},
"http_req_duration": {"avg":"2.36ms" , "min":"627.56µs", "med":"1.29ms", "max":"27.66ms ", "p_90":"4.69ms", "p_95":"7.24ms"},
"http_req_receiving": {"avg":"44.4µs" , "min":"18.56µs" , "med":"40.21µs", "max":"402.78µs", "p_90":"64.68µs", "p_95":"74.2µs"},
"http_req_sending": {"avg":"13.02µs", "min":"6.6µs" , "med":"10.73µs", "max":"196.81µs", "p_90":"18.12µs", "p_95":"22.11µs"},
"http_req_tls_handshaking": {"avg":"0s" , "min":"0s" , "med":"0s", "max":"0s", "p_90":"0s", "p_95":"0s"},
"http_req_waiting": {"avg":"2.3ms" , "min":"596.89µs", "med":"1.23ms", "max":"27.47ms", "p_90":"4.63ms", "p_95":"7.15ms"},
"iteration_duration": {"avg":"3.01s" , "min":"3s" , "med":"3s", "max":"3.05s", "p_90":"3.02s", "p_95":"3.03s"},
};

this.on('mount', ()=>{
  that.ctx = document.getElementById("statchart").getContext('2d');
  that.myChart = new Chart(that.ctx, {
		type: 'line',
		data: that.chartdata,
		options: {
			scales: {
				yAxes: [{
					ticks: {
						beginAtZero:true
					}
				}]
			}
		}
  });
});
</script>
</statcharts>

<!-- {
"group_duration": {"avg":"2.64ms" , "min":"894.7µs" , "med":"1.84ms ", "max":"17.47ms ", "p_90":"5.01ms ", "p_95":"6.79ms",
"http_req_blocked": {"avg":"7.45µs" , "min":"1.06µs" , "med":"1.84µs ", "max":"602.84µs", "p_90":"3.32µs ", "p_95":"4.31µs",
"http_req_connecting": {"avg":"4.6µs" , "min":"0s" , "med":"0s     ", "max":"536.57µs", "p_90":"0s     ", "p_95":"0s    ",
"http_req_duration": {"avg":"2.36ms" , "min":"627.56µs", "med":"1.29ms ", "max":"27.66ms ", "p_90":"4.69ms ", "p_95":"7.24ms",
"http_req_receiving": {"avg":"44.4µs" , "min":"18.56µs" , "med":"40.21µs", "max":"402.78µs", "p_90":"64.68µs", "p_95":"74.2µs",
"http_req_sending": {"avg":"13.02µs", "min":"6.6µs" , "med":"10.73µs", "max":"196.81µs", "p_90":"18.12µs", "p_95":"22.11µs"",
"http_req_tls_handshaking": {"avg":"0s" , "min":"0s" , "med":"0s     ", "max":"0s      ", "p_90":"0s     ", "p_95":"0s    ",
"http_req_waiting": {"avg":"2.3ms" , "min":"596.89µs", "med":"1.23ms ", "max":"27.47ms ", "p_90":"4.63ms ", "p_95":"7.15ms",
"iteration_duration": {"avg":"3.01s" , "min":"3s" , "med":"3s     ", "max":"3.05s   ", "p_90":"3.02s  ", "p_95":"3.03s "
} -->