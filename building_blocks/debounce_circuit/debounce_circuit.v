module debounce_circuit(

	input clock50M,
	input buttonSignal,
	input reset_n,
	output singlePulseOutput,
	output latchedOutput,
	output slowClock
);

debounce_circuit_logic circuit1(
	.clock50M(clock50M),
	.buttonSignal(buttonSignal),
	.reset_n(reset_n),
	.singlePulseOutput(singlePulseOutput),
	.latchedOutput(latchedOutput),
	.slowClock(slowClock)
);

endmodule
