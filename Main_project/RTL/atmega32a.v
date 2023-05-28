module atmega32a (
	input clock50MHz,
	input reset_n,
	
	// GPIO Inputs and Outputs
	input [7:0] PINC_input_data,	// Data read into the PINA register from the GPIO pins
	
	output [7:0] GPIOC_port,			// Output of the PORTA register
	output [7:0] GPIOB_port		// Output of the PORTB register
);

// Set up the 16MHz System Clock for the entire system
wire sysClock;
single16MHzPLL single16MHzPLL(
		.refclk(clock50MHz),   				//  refclk.clk 50MHz
		.rst(reset_n),      					//   reset.reset
		.outclk_0(sysClock) 					// outclk0.clk
);

// Instantiate the Stack Pointer
wire [15:0] sp;
wire [7:0] SPH_O;
wire [7:0] SPL_O; 
stack_pointer stack_pointer(
    .clk(sysClock),
    .clr_n(reset_n),

	// Inputs
    .data_inH(),
    .data_inL(),
    .WE_H(MM_IO_we_bus[62]),
	.WE_L(MM_IO_we_bus[61]),

	// Outputs
    .spH(SPH_O),
    .spL(SPL_O),
    .sp(sp)
);

wire [63:0] MM_IO_we_bus; // 64 bit bus for the write enable signals for the memory map
wire MM_reg_WE;
wire [4:0] MM_reg_write_addr;
wire [7:0] MM_write_data; 
// Instantiate the Memory Map
memory_map memory_map (
	.clk(sysClock),

	.addr(),	//16 bit address	
	.register_bus(all_registers), //A bus of all 32 GP registers 
	.IO_bus(IO_cat_bus), //A bus of all 64 IO registers 
	
	.WE(),	//write enable
	.data_in(),
	
	.IO_only(),
	
	.Q(),
	.IO_WE(MM_IO_we_bus), 
	.reg_WE(MM_reg_WE),
	.reg_write_addr(MM_reg_write_addr), 
	.write_data(MM_write_data)
);

// Instantiate the Instruction Decoder
wire [7:0] argument_1;
wire [7:0] argument_2;
wire [7:0] instruction_id;
instruction_decoder instruction_decoder (
	.instruction(PM_instruction_O),
	.part2(),
	
	.instruction_id(instruction_id),	// 0x00 - 0x41 or 0xff if the read is an address for 32 bit instruction
	.argument_1(argument_1),
	.argument_2(argument_2)
);

// Instatiate the program memory
wire [13:0] program_counter;
wire [15:0] PM_instruction_O; // 16 bit instruction output from the program memory
prog_memory prog_memory(
	.clk(sysClock),
	.reset_n(reset_n), 			// resets everything

	// Inputs
	.PC_inc(),			//set by control unit when I reg changes 
	.hold(),
	.PC_overwrite(),  			// set to overwrite the PC with PC_new  - May need to split this signal to interrupt and other 
	.PC_new(),
	.LPM_addr(),
	.LPM_read(),	// set to read with LPM	

	// Outputs
	.LPM_data(),
	.instruction(PM_instruction_O), 			// The I-reg output 
	.program_counter(program_counter)			// The PC output
);

// Instatiate the ALU
wire [7:0] status_register_bus;
wire [15:0] alu_output;
wire [7:0] SREG_O = status_register_bus;
ALU ALU (
	.clk(sysClock),
	.reset_n(reset_n),

	.mem_write(MM_IO_we_bus[63]),
	.mem_data(),

	.arg1(RD1),
	.arg2(),
	
	.op(),	
	.use_carry(), // if set will incorporate carry into add, sub and shifts 
	
	.Q(alu_output),
	.sreg(status_register_bus)
);

// Multiplexer to select specific bits from the status register
wire sreg_selected_bit;
multi_bit_multiplexer_8way #(1) status_register (
	.reg0(status_register_bus[0]), .reg1(status_register_bus[1]), .reg2(status_register_bus[2]), .reg3(status_register_bus[3]), 
	.reg4(status_register_bus[4]), .reg5(status_register_bus[5]), .reg6(status_register_bus[6]), .reg7(status_register_bus[7]),
	.S(), .out(sreg_selected_bit)
);


// Instantiate the register file
wire [7:0] RD1;
wire [7:0] RD2;
wire [255:0] all_registers;
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
	.RD1(RD1),						// Output data read from RA1
	.RD2(RD2),							// Output data read from RA2
	.all_registers(all_registers)				// Bus containing the contents of all registers 31->0
);

// Instantiate the GPIO for GPIOC and GPIOB
wire [7:0] DDRC_O;
wire [7:0] DDRB_O;
wire [7:0] PORTC_O;
wire [7:0] PORTB_O;
wire [7:0] PINC_O;
wire [7:0] PINB_O;
assign GPIOC_port = PORTC_O;
assign GPIOB_port = PORTB_O;
gpio gpio (
	.clk(sysClock),
	.clr_n(reset_n),
	
	// GPIOC inputs and outputs (GPIOA is GPIOC)
	.DDRA_write_enable(MM_IO_we_bus[20]), 
	.DDRA_input_data(),
	
	.PORTA_write_enable(MM_IO_we_bus[21]), 
	.PORTA_input_data(),
	
	.PINA_input_data(PINC_input_data),	

	.DDRA_output(DDRC_O),
	.PORTA_output(PORTC_O),
	.PINA_output(PINC_O),
	
	// GPIOB inputs and outputs
	.DDRB_write_enable(MM_IO_we_bus[23]),
	.DDRB_input_data(),
	
	.PORTB_write_enable(MM_IO_we_bus[24]),
	.PORTB_input_data(),
	
	.PINB_input_data(),	

	.DDRB_output(DDRB_O),
	.PORTB_output(PORTB_O),
	.PINB_output(PINB_O)
);

// Instantiate the 8-bit Timer 0
wire [7:0] tifr_timer0_O;
wire [7:0] timsk_timer0_O; 
wire [7:0] TCNT0_O;
wire [7:0] TCCR0_O;
wire [7:0] OCR0_O;
timer_8bit timer0_8bit(
	.sysClock(sysClock),				// The system clock
	.rst_n(reset_n),

	.TCNT_data(),				// 8 bit input used to update the TCNT0 register with a specified value
	.OCR_input(),				// 8 bit input used to update the OCR0 register
	.TCCR_input(),				// 8 bit input used to update the TCCR0 register
	.TIMSK_input(),				// 8 bit input used to update the TIMSK register
	.TIFR_input(),				// 8 bit input used to update the TIFR register
	
	// Register write enable signals
	.TCNT_write_enable(MM_IO_we_bus[50]),
	.TCCR_write_enable(MM_IO_we_bus[51]),
	.OCR_write_enable(MM_IO_we_bus[60]),
	.TIMSK_write_enable(MM_IO_we_bus[57]),
	.TIFR_write_enable(MM_IO_we_bus[56]),
	
	.clear_count(TIFR_O[1]),				// Used to clear the TCNT0 register to 0
	
	// Outputs
	.TCNT_output(TCNT0_O),				// 8 bit output for the TCNT register
	.TCCR_output(TCCR0_O),				// 8 bit output for the TCCR register
	.OCR_output(OCR0_O),				// 8 bit output for the OCR register
	.TIMSK_output(timsk_timer0_O),				// 8 bit output for the TIMSK register
	.TIFR_output(tifr_timer0_O)	// 8 bit output for the TIFR register
);

// Instantiate the 16-bit Timer 1
wire [7:0] tifr_timer1_O;
wire [7:0] timsk_timer1_O; 
wire [7:0] TCNT1H_O;
wire [7:0] TCNT1L_O;
wire [7:0] TCCR1_O;
wire [7:0] OCR1AH_O;
wire [7:0] OCR1AL_O;
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
	.TCCR_write_enable(MM_IO_we_bus[46]),
	.OCR_write_enable(),
	.TIMSK_write_enable(MM_IO_we_bus[57]),
	.TIFR_write_enable(MM_IO_we_bus[56]),
	
	.clear_count(TIFR_O[4]),					// Used to clear the TCNT0 register to 0
	
	.TCNT1H_output(TCNT1H_O),				// 8 bit high output for the TCNT register
	.TCNT1L_output(TCNT1L_O),				// 8 bit low output for the TCNT register
	.TCCR_output(TCCR1_O),					// 8 bit output for the TCCR register
	.OCR1AH_output(OCR1AH_O),				// 8 bit output for the OCR register
	.OCR1AL_output(OCR1AL_O),				// 8 bit output for the OCR register
	.TIMSK_output(timsk_timer1_O),				// 8 bit output for the TIMSK register
	.TIFR_output(tifr_timer1_O)					// 8 bit output for the TIFR register
);

// An output wire for the joint TIFR output
wire [7:0] TIFR_O = tifr_timer0_O | tifr_timer1_O;
wire TIMSK_O = timsk_timer0_O | timsk_timer1_O;

// Wire for IO bus for memory map 
wire [511:0] IO_cat_bus = {
	SREG_O, SPH_O, SPL_O, OCR0_O,
	16'B0, // 2 registers 
	TIMSK_O, TIFR_O,
	32'B0,	// 4 registers 
	TCCR0_O, TCNT0_O,
	24'B0,	// 3 registers 
	TCCR1_O, TCNT1H_O, TCNT1L_O, OCR1AH_O, OCR1AL_O, // FIX TCCR1 FOR A AND B
	136'B0, // 17 registers 
	PORTB_O, DDRB_O, PINB_O, PORTC_O, DDRC_O, PINC_O, 
	152'B0	// 19 registers 
};

endmodule

