module joint_registers(


);

// The output control register. Used to compare all 8 bits of this register to the value within TCNT0
d_flip_flop_multi_bit_en #(8, 0) TIMSK0 (
	.d(TIMSK_input), 
	.clk(sysClock), 
	.clr_n(system_reset), 
	.enable(TIMSK_write_enable),
	.Q(TIMSK_output), 
	.Qn()
);

// A D-type flip flop used to latch the feedback output of the TIFR XOR input
d_flip_flop_multi_bit #(8,0) TIFR0_input (.d(TIFR_input ^ TIFR_output_wire), .clk(TIFR_write_enable | ~system_reset), .clr_n(system_reset), .Q(TIFR_data_input), .Qn());

// The timer interrupt flag register. A 1 must be written to this register to clear it
// Bit1 is the Output Compare flag (OCF), set to 1 when a match occurs between OCR and TCNT
// Bit0 is the timer/counter overflow flag (TOV), set to 1 an overflow occurs 
d_flip_flop_multi_bit_en #(8, 0) TIFR0 (
	.d(TIFR_data_input),
	.clk(sysClock), 
	.clr_n(system_reset), 
	.enable(TIFR_write_enable),
	.Q(TIFR_output_wire), 
	.Qn()
);

assign TIFR_output = TIFR_output_wire;




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



endmodule
