module timer_16bit_registers(
	input sysClock,					// The system clock used tobit input used to update the TIFR register update the timer registers
	input [7:0] TCNT1H_input,		// 8 bit input used to update the TCNT1 high register with a specified value
	input [7:0] TCNT1L_input,		// 8 bit input used to update the TCNT1 low register with a specified value
	input [7:0] TCCR_input,			// 8 bit input used to update the TCCR1 register	
	input [7:0] OCR1AH_input,		// 8 bit input used to update the OCR1 register
	input [7:0] OCR1AL_input,		// 8 bit input used to update the OCR1 register
	input [7:0] TIMSK_input,		// 8 bit input used to update the TIMSK register
	input [7:0] TIFR_input,			// 8 bit input used to update the TIFR register
	
	// Write enable signals for the timer registers
	input TCCR_write_enable,
	input OCR1_write_enable,
	input OCR2_write_enable,
	input TIMSK_write_enable,
	input TIFR_write_enable,
	
	input clear_count,				// Used to clear the TCNT0 register to 0
	input system_reset,				// Used as an entire system reset
	
	output [7:0] TCNT1H_output,	// 8 bit high output for the TCNT register
	output [7:0] TCNT1L_output,	// 8 bit low output for the TCNT register
	output [7:0] TCCR_output,		// 8 bit output for the TCCR register
	output [7:0] OCR1AH_output,		// 8 bit output for the OCR register
	output [7:0] OCR1AL_output,		// 8 bit output for the OCR register
	output [7:0] TIMSK_output,		// 8 bit output for the TIMSK register
	output [7:0] TIFR_output		// 8 bit output for the TIFR register
);

wire [7:0] TIFR_output_wire;
wire [7:0] TIFR_data_input;

wire [15:0] TCNT_input = (TCNT1H_input << 8) | TCNT1L_input;
wire [15:0] TCNT_output;

// The register used to store the current timer value
d_flip_flop_multi_bit_en #(16, 0) TCNT1 (
	.d(TCNT_input), 
	.clk(sysClock), 
	.clr_n(~(clear_count) & system_reset),
	.enable(1'b1),
	.Q(TCNT_output), 
	.Qn()
);

// The Timer/Counter Control Register
// Bits 7:3 are unused. Bits 2:0 are used as the clock select bits
// See table 15-6 of the ATMega32A data sheet for the use of the clock select bits
d_flip_flop_multi_bit_en #(8, 0) TCCR1B (
	.d(TCCR_input), 
	.clk(sysClock), 
	.clr_n(system_reset),
	.enable(TCCR_write_enable),
	.Q(TCCR_output), 
	.Qn()
);

// The output control register. Used to compare all 8 bits of this register to the value within TCNT0
d_flip_flop_multi_bit_en #(8, 0) OCR1 (
	.d(OCR1AH_input), 
	.clk(sysClock), 
	.clr_n(system_reset), 
	.enable(OCR1_write_enable),
	.Q(OCR1AH_output), 
	.Qn()
);
d_flip_flop_multi_bit_en #(8, 0) OCR2 (
	.d(OCR1AL_input), 
	.clk(sysClock), 
	.clr_n(system_reset), 
	.enable(OCR2_write_enable),
	.Q(OCR1AL_output), 
	.Qn()
);

// The timer mask register
d_flip_flop_multi_bit_en #(8, 0) TIMSK1 (
	.d(TIMSK_input), 
	.clk(sysClock), 
	.clr_n(system_reset), 
	.enable(TIMSK_write_enable),
	.Q(TIMSK_output), 
	.Qn()
);

// A D-type flip flop used to latch the feedback output of the TIFR XOR input
d_flip_flop_multi_bit #(8,0) TIFR1_input (.d(TIFR_input ^ TIFR_output_wire), .clk(TIFR_write_enable | ~system_reset), .clr_n(system_reset), .Q(TIFR_data_input), .Qn());

// The timer interrupt flag register. A 1 must be written to this register to clear it
// Bit4 is the Output Compare flag (OCF), set to 1 when a match occurs between OCR and TCNT
// Bit0 is the timer/counter overflow flag (TOV), set to 1 an overflow occurs 
d_flip_flop_multi_bit_en #(8, 0) TIFR1 (
	.d(TIFR_data_input),
	.clk(sysClock), 
	.clr_n(system_reset), 
	.enable(TIFR_write_enable),
	.Q(TIFR_output_wire), 
	.Qn()
);

assign TIFR_output = TIFR_output_wire;
assign TCNT1H_output = TCNT_output[15:8];
assign TCNT1L_output = TCNT_output[7:0];

endmodule
