module pll_16MHz(
	input clock50MHz,				// 50MHz reference clock (PIN_V11)
	input reset,
	
	output out16MHz
);

wire sysClk16MHz;

module single16MHzPLL (
		.refclk(clock50MHz),   				//  refclk.clk
		.rst(reset),      					//   reset.reset
		.outclk_0(sysClk16MHz)  			// outclk0.clk
);

assign out16MHz = sysClk16MHz;

endmodule
