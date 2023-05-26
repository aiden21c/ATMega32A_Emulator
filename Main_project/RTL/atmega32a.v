module atmega32a (
	input clock50MHz,
	input reset_n,
	
	// GPIO Inputs and Outputs
	input [7:0] PINA_input_data,	// Data read into the PINA register from the GPIO pins
	
	output [7:0] GPIOA_port,			// Output of the PORTA register
	output [7:0] GPIOB_port		// Output of the PORTB register
);

// Set up the System Clock for the entire system
wire sysClock;
parametised_counter #(2, 1) system_clock16Mhz(							// Set a counter width of 2 and a start count of 1
	.MR_n(reset_n), .clock50(clock50MHz), .Qn_out(), .clock(sysClock)
);

// Instatiate the program memory
prog_memory prog_memory(
	.clk(sysClock),
	.reset_n(reset_n), 			// resets everything

	// Inputs
	.PC_inc(),			//set by control unit when I reg changes 
	.hold(),
	.PC_overwrite(),  			// set to overwrite the PC with PC_new  - May need to split this signal to interrupt and other 
	.PC_new(),

	// Outputs
	.instruction(), 			// The I-reg output 
	.program_counter()			// The PC output
);

// Instantiate the register file
register_file register_file(
	.clock(sysClock),						// Clock input
	.clr_n(reset_n),

	// Inputs
	.RA1(),							// Read register 1
	.RA2(),							// Read register 2
	.WA(),							// Write register
	.RegWrite(),					// Write enable signal
	.WD(),							// Write data
	
	// Outputs
	.RD1(),							// Output data read from RA1
	.RD2()							// Output data read from RA2
);

// Instantiate the GPIO for GPIOA and GPIOB
gpio gpio (
	.clk(sysClock),
	.clr_n(reset_n),
	
	// GPIOA inputs and outputs
	.DDRA_write_enable(),
	.DDRA_input_data(),
	
	.PORTA_write_enable(),
	.PORTA_input_data(),
	
	.PINA_input_data(PINA_input_data),	

	.DDRA_output(),
	.PORTA_output(GPIOA_port),
	.PINA_output(),
	
	// GPIOB inputs and outputs
	.DDRB_write_enable(),
	.DDRB_input_data(),
	
	.PORTB_write_enable(),
	.PORTB_input_data(),
	
	.PINB_input_data(),	

	.DDRB_output(),
	.PORTB_output(GPIOB_port),
	.PINB_output()
);

// Instantiate the 8-bit Timer 0
wire [7:0] tifr_timer0;
timer_8bit timer0_8bit(
	.sysClock(sysClock),				// The system clock
	.rst_n(reset_n),

	.TCNT_data(),				// 8 bit input used to update the TCNT0 register with a specified value
	.OCR_input(),				// 8 bit input used to update the OCR0 register
	.TCCR_input(),				// 8 bit input used to update the TCCR0 register
	.TIMSK_input(),				// 8 bit input used to update the TIMSK register
	.TIFR_input(),				// 8 bit input used to update the TIFR register
	
	// Register write enable signals
	.TCNT_write_enable(),
	.TCCR_write_enable(),
	.OCR_write_enable(),
	.TIMSK_write_enable(),
	.TIFR_write_enable(),
	
	.clear_count(),				// Used to clear the TCNT0 register to 0
	
	// Outputs
	.TCNT_output(),				// 8 bit output for the TCNT register
	.TCCR_output(),				// 8 bit output for the TCCR register
	.OCR_output(),				// 8 bit output for the OCR register
	.TIMSK_output(),				// 8 bit output for the TIMSK register
	.TIFR_output(tifr_timer0)	// 8 bit output for the TIFR register
);

// Instantiate the 16-bit Timer 1
wire [7:0] tifr_timer1;
timer_16bit timer1_16bit(
	.sysClock(sysClock),				// The system clock
	.rst_n(reset_n),

	.TCNT1H_input(),				// 8 bit input used to update the TCNT1 high register with a specified value
	.TCNT1L_input(),				// 8 bit input used to update the TCNT1 low register with a specified value
	.OCR1AH_input(),				// 8 bit input used to update the OCR1 register
	.OCR1AL_input(),				// 8 bit input used to update the OCR1 register
	.TCCR_input(),					// 8 bit input used to update the TCCR0 register
	.TIMSK_input(),					// 8 bit input used to update the TIMSK register
	.TIFR_input(),
	
	// Register write enable signals
	.TCNT_write_enable(),
	.TCCR_write_enable(),
	.OCR_write_enable(),
	.TIMSK_write_enable(),
	.TIFR_write_enable(),
	
	.clear_count(),					// Used to clear the TCNT0 register to 0
	
	.TCNT1H_output(),				// 8 bit high output for the TCNT register
	.TCNT1L_output(),				// 8 bit low output for the TCNT register
	.TCCR_output(),					// 8 bit output for the TCCR register
	.OCR1AH_output(),				// 8 bit output for the OCR register
	.OCR1AL_output(),				// 8 bit output for the OCR register
	.TIMSK_output(),				// 8 bit output for the TIMSK register
	.TIFR_output()					// 8 bit output for the TIFR register
);

// An output wire for the joint TIFR output
wire [7:0] tifr = tifr_timer0 | tifr_timer1;


endmodule

