module timer0registers(
	input sysClock,					// The system clock used to update the timer registers
	input [7:0] TCNT_input,			// 8 bit input used to update the TCNT0 register with a specified value
	input [7:0] TCCR_input,			// 8 bit input used to update the TCCR0 register
	
	input countClock,					// Clock signal used to count timer
	input clear_count,				// Used to clear the TCNT0 register to 0
	
	output [7:0] TCNT_output,		// 8 bit output fore the TCNT register
	output [7:0] TCCR_output		// 8 bit output for the TCCR register
);

// The register used to store the current timer value
d_flip_flop_multi_bit #(8, 0) TCNT0 (.d(TCNT_input), .clk(countClock), .clr_n(clear_count), .Q(TCNT_output), .Qn());

// The Timer/Counter Control Register
// Bits 7:3 are unused. Bits 2:0 are used as the clock select bits
// See table 15-6 of the ATMega32A data sheet for the use of the clock select bits
d_flip_flop_multi_bit #(8, 0) TCCR0 (.d(TCCR_input), .clk(sysClock), .clr_n(), .Q(TCCR_output), .Qn());

endmodule
