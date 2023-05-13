// Implimentation of the 8-bit Timer0 of the ATMega32A
module timer0_8bit(
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

wire [7:0] TCNT_wire;
wire [7:0] TIFR_wire;
wire [7:0] TIFR_data;
wire countClock;

wire TIFR_write_enable_wire;


multi_bit_multiplexer_2way #(8) TIFR0_input_selector (
	.A(TIFR_wire), .B(TIFR_input), .S(TIFR_write_enable), .out(TIFR_data)
);

// Select between the various prescaled clock sources for the ATMega32A
clockSelector clockSelector(
	.sysClock(sysClock),
	.S(TCCR_output[2:0]),
	.rst_n(rst_n),
	.OUT(countClock),
	.div(),
	.cnt()
);

timer_control_unit timer_control_unit(
	.sysClock(sysClock),										// The system clock
	.TCNT_data(TCNT_data),									// 8 bit input used to update the TCNT0 register with a specified value
	.OCR_data(OCR_output),									// 8 bit input used to update the OCR0 register

	.countClock(countClock),								// Clock signal used to count timer	
	.TCNT_write_enable(TCNT_write_enable),				// Input signal to specify whether the TCNT value should be written to with a preload
	
	.TIFR_write_enable(TIFR_write_enable_wire),		// Output used to write to the TIFR register		
	.TCNT_output(TCNT_wire),								// 8 bit output for the TCNT register
	.TIFR_output(TIFR_wire)									// 8 bit output for the TIFR register
);

timer0registers timer0registers(
	.sysClock(sysClock),				// The system clock used tobit input used to update the TIFR register update the timer registers
	.TCNT_input(TCNT_wire),			// 8 bit input used to update the TCNT0 register with a specified value
	.TCCR_input(TCCR_input),		// 8 bit input used to update the TCCR0 register	
	.OCR_input(OCR_input),			// 8 bit input used to update the OCR0 register
	.TIMSK_input(TIMSK_input),		// 8 bit input used to update the TIMSK register
	.TIFR_input(TIFR_data),			// 8 bit input used to update the TIFR register
	
	// Write enable signals for the timer registers
	.TCCR_write_enable(TCCR_write_enable),
	.OCR_write_enable(OCR_write_enable),
	.TIMSK_write_enable(TIMSK_write_enable),
	.TIFR_write_enable((TIFR_write_enable_wire & ~(|TIFR_output[1:0])) | TIFR_write_enable),
	
	.clear_count(clear_count),				// Used to clear the TCNT0 register to 0
	.system_reset(rst_n),					// Used as an entire system reset
	
	.TCNT_output(TCNT_output),				// 8 bit output for the TCNT register
	.TCCR_output(TCCR_output),				// 8 bit output for the TCCR register
	.OCR_output(OCR_output),				// 8 bit output for the OCR register
	.TIMSK_output(TIMSK_output),			// 8 bit output for the TIMSK register
	.TIFR_output(TIFR_output)				// 8 bit output for the TIFR register
);


endmodule
