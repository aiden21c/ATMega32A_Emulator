module debounce_circuit_logic(
	input clock50M,
	input buttonSignal,
	input reset_n,
	output singlePulseOutput,
	output latchedOutput,
	output slowClock
);

wire clock4Hz;
wire d0Out;
wire d1Out_n;

wire latchedOutput_wire;

parametised_counter #(21, 847151) clock_20Hz (.MR_n(reset_n), .clock50(clock50M), .Qn_out(), .clock(clock4Hz));

d_flip_flop_multi_bit #(1, 0) d0 (.d(buttonSignal), .clk(clock4Hz), .clr_n(reset_n), .Q(d0Out), .Qn());
d_flip_flop_multi_bit #(1, 0) d1 (.d(d0Out), .clk(clock4Hz), .clr_n(reset_n), .Q(), .Qn(d1Out_n));

d_flip_flop_multi_bit #(1, 0) dLatch (.d(!latchedOutput_wire), .clk(d0Out & d1Out_n), .clr_n(reset_n), .Q(latchedOutput_wire), .Qn());

assign singlePulseOutput = d0Out & d1Out_n;
assign latchedOutput = latchedOutput_wire;
assign slowClock = clock4Hz;

endmodule
