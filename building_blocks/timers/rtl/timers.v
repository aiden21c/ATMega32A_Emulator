module timers(

);

timer0_8bit timer0 (
	input sysClock,				// The system clock
	input rst_n,
	input [7:0] TCNT_data,		// 8 bit input used to update the TCNT0 register with a specified value
	input [7:0] OCR_input,		// 8 bit input used to update the OCR0 register
	input [7:0] TCCR_input,		// 8 bit input used to update the TCCR0 register
	input [7:0] TIMSK_input,	// 8 bit input used to update the TIMSK register
	input [7:0] TIFR_input,
	
	// Register write enable signals
	input TCNT_write_enable,
	input TCCR_write_enable,
	input OCR_write_enable,
	input TIMSK_write_enable,
	input TIFR_write_enable,
	
	input clear_count,				// Used to clear the TCNT0 register to 0
	
	output [7:0] TCNT_output,		// 8 bit output for the TCNT register
	output [7:0] TCCR_output,		// 8 bit output for the TCCR register
	output [7:0] OCR_output,		// 8 bit output for the OCR register
	output [7:0] TIMSK_output,		// 8 bit output for the TIMSK register
	output [7:0] TIFR_output		// 8 bit output for the TIFR register
);


timer_16bit timer_1(
	input sysClock,				// The system clock
	input rst_n,
	input [7:0] TCNT1H_input,	// 8 bit input used to update the TCNT1 high register with a specified value
	input [7:0] TCNT1L_input,	// 8 bit input used to update the TCNT1 low register with a specified value
	input [7:0] OCR1AH_input,	// 8 bit input used to update the OCR1 register
	input [7:0] OCR1AL_input,	// 8 bit input used to update the OCR1 register
	input [7:0] TCCR_input,		// 8 bit input used to update the TCCR0 register
	input [7:0] TIMSK_input,	// 8 bit input used to update the TIMSK register
	input [7:0] TIFR_input,
	
	// Register write enable signals
	input TCNT_write_enable,
	input TCCR_write_enable,
	input OCR_write_enable,
	input TIMSK_write_enable,
	input TIFR_write_enable,
	
	input clear_count,				// Used to clear the TCNT0 register to 0
	
	output [7:0] TCNT1H_output,	// 8 bit high output for the TCNT register
	output [7:0] TCNT1L_output,	// 8 bit low output for the TCNT register
	output [7:0] TCCR_output,		// 8 bit output for the TCCR register
	output [7:0] OCR1AH_output,	// 8 bit output for the OCR register
	output [7:0] OCR1AL_output,	// 8 bit output for the OCR register
	output [7:0] TIMSK_output,		// 8 bit output for the TIMSK register
	output [7:0] TIFR_output		// 8 bit output for the TIFR register
);



endmodule