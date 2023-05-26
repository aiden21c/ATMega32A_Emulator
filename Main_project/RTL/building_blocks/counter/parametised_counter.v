// Parametised counter with a d-flip-flop output to achieve a 50% duty cycle.
// The d-flip-flop toggles at every expiry of the counter.

module parametised_counter(MR_n, clock50, Qn_out, clock);

parameter counterWidth = 1;
parameter startValue = 0;

input MR_n;
input clock50;
	
output [counterWidth-1:0] Qn_out;
output clock;

wire TC_out;
wire dOut;

param_counter_noCEP #(counterWidth, startValue) clock_Hz(
	.MR_n(MR_n), 
	.clock50(clock50), 
	.Qn_out(Qn_out), 
	.TC_out(TC_out)
);


d_flip_flop_multi_bit #(1,0) dutyCycle50 (
	.d(!dOut),
	.clk(TC_out), 
	.clr_n(MR_n),
	.Q(dOut),
	.Qn()
);

assign clock = dOut;

endmodule
