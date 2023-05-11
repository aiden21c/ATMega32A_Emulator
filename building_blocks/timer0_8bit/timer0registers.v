module timer0registers(
	input sysClock,					// The system clock used tobit input used to update the TIFR register update the timer registers
	input [7:0] TCNT_input,			// 8 bit input used to update the TCNT0 register with a specified value
	input [7:0] TCCR_input,			// 8 bit input used to update the TCCR0 register	
	input [7:0] OCR_input,			// 8 bit input used to update the OCR0 register
	input [7:0] TIMSK_input,		// 8 bit input used to update the TIMSK register
	input [7:0] TIFR_input,			// 8 bit input used to update the TIFR register
	
	// Write enable signals for the timer registers
	input TCCR_write_enable,
	input OCR_write_enable,
	input TIMSK_write_enable,
	input TIFR_write_enable,
	
	input clear_count,				// Used to clear the TCNT0 register to 0
	input system_reset,				// Used as an entire system reset
	
	output [7:0] TCNT_output,		// 8 bit output for the TCNT register
	output [7:0] TCCR_output,		// 8 bit output for the TCCR register
	output [7:0] OCR_output,		// 8 bit output for the OCR register
	output [7:0] TIMSK_output,		// 8 bit output for the TIMSK register
	output [7:0] TIFR_output		// 8 bit output for the TIFR register
);

// The register used to store the current timer value
d_flip_flop_multi_bit_en #(8, 0) TCNT0 (
	.d(TCNT_input), 
	.clk(countClock), 
	.clr_n(clear_count | system_reset),
	.enable(1'b1),
	.Q(TCNT_output), 
	.Qn()
);

// The Timer/Counter Control Register
// Bits 7:3 are unused. Bits 2:0 are used as the clock select bits
// See table 15-6 of the ATMega32A data sheet for the use of the clock select bits
d_flip_flop_multi_bit_en #(8, 0) TCCR0 (
	.d(TCCR_input), 
	.clk(sysClock), 
	.clr_n(system_reset),
	.enable(TCCR_write_enable),
	.Q(TCCR_output), 
	.Qn()
);

// The output control register. Used to compare all 8 bits of this register to the value within TCNT0
d_flip_flop_multi_bit_en #(8, 0) OCR0 (
	.d(OCR_input), 
	.clk(sysClock), 
	.clr_n(system_reset), 
	.enable(OCR_write_enable),
	.Q(OCR_output), 
	.Qn()
);

// The output control register. Used to compare all 8 bits of this register to the value within TCNT0
d_flip_flop_multi_bit_en #(8, 0) TIMSK0 (
	.d(TMSK_input), 
	.clk(sysClock), 
	.clr_n(system_reset), 
	.enable(TIMSK_write_enable),
	.Q(TIMSK_output), 
	.Qn()
);

// The timer interrupt flag register. A 1 must be written to this register to clear it
// Bit1 is the Output Compare flag (OCF), set to 1 when a match occurs between OCR and TCNT
// Bit0 is the timer/counter overflow flag (TOV), set to 1 an overflow occurs 
d_flip_flop_multi_bit_en #(8, 0) TIFR0 (
	.d(TIFR_input), 
	.clk(sysClock), 
	.clr_n(system_reset), 
	.enable(TIFR_write_enable),
	.Q(TIFR_output), 
	.Qn()
);

endmodule
