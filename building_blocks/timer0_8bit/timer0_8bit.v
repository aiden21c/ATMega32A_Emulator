// Implimentation of the 8-bit Timer0 of the ATMega32A
module timer0_8bit(
	input sysClock,				// The input clock source of the system
	input clear_count,			// Input used to clear TCNT to 0
	
	input preload_assertion,	// Input used to tell the system that it must be preloaded with a value
	
	// Define the timer Control registers
	input [7:0] TCNT_input, 		// Timer/Counter register
	input [7:0] TCCR_input, 		// Timer count control register
	
	output [7:0] TCNT_output,
	output [7:0] TCCR_output,
	output overflow
);

wire clr = ~clear_count;
wire countClock;

clockSelector clockSelector(.sysClock(sysClock), .S(TCCR_output[2:0]), .OUT(countClock));

timer0registers timer0registers(.sysClock(sysClock), .TCNT_input(), .TCCR_input(TCCR_input), .countClock(countClock), .clear_count(clr), .TCNT_output(TCNT_output), .TCCR_output(TCCR_output));

endmodule
