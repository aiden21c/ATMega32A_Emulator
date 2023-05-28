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

wire CU_part2;
wire [2:0] CU_ALU_sel;
wire CU_PC_inc;
wire CU_IREG_hold;
wire CU_PC_overwrite;
wire CU_GP_reg_write;
wire CU_USE_carry;
wire CU_STATUS_reg_sel;
wire CU_IO_only_flag;
wire CU_memory_write_en;
wire CU_SP_write_en;

// Instantiate the control unit
control_unit control_unit(
    .clk(sysClock),

    .instruction_id(instruction_id),
    .status_register(SREG_O),

    .instruction_decoder_part2(CU_part2),

    .ALU_SEL(CU_ALU_sel),
    .PC_INC(CU_PC_inc),
    .IREG_HOLD(CU_IREG_hold),
    .PC_OVERWRITE(CU_PC_overwrite),
    .GP_REG_WRITE(CU_GP_reg_write),
    .USE_CARRY(CU_USE_carry),
    .STATUS_REG_SEL(CU_STATUS_reg_sel),
    .IO_ONLY_FLAG(CU_IO_only_flag),
    .MEMORY_WRITE_EN(CU_memory_write_en),
	.SP_WRITE_ENABLE(CU_SP_write_en)
);

// Stack pointer in multiplexers 
// either from ALU (+/- 1) or from memory map when writing to SPH or SPL
wire [7:0] SP_inL_selected;

multi_bit_multiplexer_2way #(8) SP_inL_mux (
	.A(alu_output[7:0]), .B(MM_write_data), .S(), .out(SP_inL_selected)
);

// Instantiate the Stack Pointer
wire [15:0] sp;
wire [7:0] SPH_O;
wire [7:0] SPL_O; 
stack_pointer stack_pointer(
    .clk(sysClock),
    .clr_n(reset_n),

	// Inputs
    .data_inH(MM_write_data),
    .data_inL(SP_inL_selected),
    .WE_H(MM_IO_we_bus[62]),
	.WE_L(MM_IO_we_bus[61] | CU_SP_write_en),

	// Outputs
    .spH(SPH_O),
    .spL(SPL_O),
    .sp(sp)
);

// multiplexer for MM address selection
// Can come from Y reg on register file or from decoder arguments or from SP
wire [15:0] MM_address_selected;
wire [15:0] MM_address_mux_A = all_registers[239:224];
wire [15:0] MM_address_mux_B = {8'b0, argument_2};

multi_bit_multiplexer_4way #(16) MM_address_mux (
	.A(MM_address_mux_A), .B(MM_address_mux_B), .C(sp), .D(16'b0), .S(), .out(MM_address_selected)
);

wire [63:0] MM_IO_we_bus; // 64 bit bus for the write enable signals for the memory map
wire MM_reg_WE;
wire [4:0] MM_reg_write_addr;
wire [7:0] MM_write_data; 
wire [7:0] MM_Q_O; // 8 bit output from the memory map
// Instantiate the Memory Map
memory_map memory_map (
	.clk(sysClock),

	.addr(MM_address_selected),	//16 bit address	
	.register_bus(all_registers), //A bus of all 32 GP registers 
	.IO_bus(IO_cat_bus), //A bus of all 64 IO registers 
	
	.WE(CU_memory_write_en),	//write enable
	.data_in(RD1),
	
	.IO_only(CU_IO_only_flag),
	
	.Q(MM_Q_O),
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
	.part2(CU_part2),
	
	.instruction_id(instruction_id),	// 0x00 - 0x41 or 0xff if the read is an address for 32 bit instruction
	.argument_1(argument_1),
	.argument_2(argument_2)
);

// mux for PC_new
// can come from interrupt trigger, decoder argument, from the controller (call/Ret) 
// C is K from decoder but handled elsewhere 
// D unused 
wire [13:0] PM_PC_new_selected;
multi_bit_multiplexer_4way #(14) PM_PC_new_mux (
	.A(14'h00E), .B(argument_1), .C(), .D(14'b0), .S(), .out(PM_PC_new_selected)
);

// Instatiate the program memory
wire [13:0] program_counter;
wire [15:0] PM_instruction_O; // 16 bit instruction output from the program memory
wire [8:0] PM_LPM_O;
prog_memory prog_memory(
	.clk(sysClock),
	.reset_n(reset_n), 			// resets everything

	// Inputs
	.PC_inc(CU_PC_inc),			//set by control unit when I reg changes 
	.hold(CU_IREG_hold),
	.PC_overwrite(CU_PC_overwrite),  			// set to overwrite the PC with PC_new  - May need to split this signal to interrupt and other 
	.PC_new(PM_PC_new_selected),
	.LPM_addr(all_registers[254:240]), // Z register hard coded 
	.LPM_read(),	// set to read with LPM	

	// Outputs
	.LPM_data(PM_LPM_O),
	.instruction(PM_instruction_O), 			// The I-reg output 
	.program_counter(program_counter)			// The PC output
);

// Multiplexer for ALU arg 2 selection 
// From register file output 2 or from arg2 of instruction decoder
wire [7:0] ALU_arg2_selected;
multi_bit_multiplexer_2way #(8) ALU_arg2 (
	.A(RD2), .B(argument_2), .S(), .out(ALU_arg2_selected)
);

// Instatiate the ALU
wire [7:0] status_register_bus;
wire [15:0] alu_output;
wire [7:0] SREG_O = status_register_bus;
ALU ALU0 (
	.clk(sysClock),
	.reset_n(reset_n),

	.mem_write(MM_IO_we_bus[63]),
	.mem_data(MM_write_data),

	.arg1(RD1),
	.arg2(ALU_arg2_selected),
	
	.op(CU_ALU_sel),	
	.use_carry(CU_USE_carry), // if set will incorporate carry into add, sub and shifts 
	
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

// reg file WA mux
// can select from decoder argyment, control block or from memory map 
// Option B is for XYZ inc/dec 
wire [7:0] RF_WA_selected;
multi_bit_multiplexer_4way #(8) RegFile_WA_mux (
	.A(argument_1), .B(), .C(MM_reg_write_addr), .D(8'b0), .S(), .out(RF_WA_selected) // D not used 
);

// reg file WD mux
// can come from ALU, memory map data, decoder argument or LPM output 
wire [7:0] RF_WD_selected;
multi_bit_multiplexer_4way #(8) RegFile_WD_mux (
	.A(alu_output), .B(MM_write_data), .C(argument_2), .D(PM_LPM_O), .S(), .out(RF_WD_selected)
);

// Instantiate the register file
wire [7:0] RD1;
wire [7:0] RD2;
wire [255:0] all_registers;
register_file register_file(
	.clock(sysClock),						// Clock input
	.clr_n(reset_n),

	// Inputs
	.RA1(argument_1),							// Read register 1
	.RA2(argument_2),							// Read register 2
	.WA(RF_WA_selected),							// Write register
	.RegWrite(CU_GP_reg_write),					// Write enable signal
	.WD(RF_WD_selected),							// Write data
	
	// Outputs
	.RD1(RD1),						// Output data read from RA1
	.RD2(RD2),							// Output data read from RA2
	.all_registers(all_registers)				// Bus containing the contents of all registers 31->0
);

/*
Below this line is completely filled 
*********************************************************************************************************************************************************************************************************
*/

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
	.DDRA_input_data(MM_write_data),
	
	.PORTA_write_enable(MM_IO_we_bus[21]), 
	.PORTA_input_data(MM_write_data),
	
	.PINA_input_data(PINC_input_data),	

	.DDRA_output(DDRC_O),
	.PORTA_output(PORTC_O),
	.PINA_output(PINC_O),
	
	// GPIOB inputs and outputs
	.DDRB_write_enable(MM_IO_we_bus[23]),
	.DDRB_input_data(MM_write_data),
	
	.PORTB_write_enable(MM_IO_we_bus[24]),
	.PORTB_input_data(MM_write_data),
	
	.PINB_input_data(8'b0),	

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

	.TCNT_data(MM_write_data),				// 8 bit input used to update the TCNT0 register with a specified value
	.OCR_input(MM_write_data),				// 8 bit input used to update the OCR0 register
	.TCCR_input(MM_write_data),				// 8 bit input used to update the TCCR0 register
	.TIMSK_input(MM_write_data),				// 8 bit input used to update the TIMSK register
	.TIFR_input(MM_write_data),				// 8 bit input used to update the TIFR register
	
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

	.TCNT1H_input(8'b0),				// 8 bit input used to update the TCNT1 high register with a specified value
	.TCNT1L_input(8'b0),				// 8 bit input used to update the TCNT1 low register with a specified value
	.OCR1AH_input(MM_write_data),				// 8 bit input used to update the OCR1 register
	.OCR1AL_input(MM_write_data),				// 8 bit input used to update the OCR1 register
	.TCCR_input(MM_write_data),					// 8 bit input used to update the TCCR0 register
	.TIMSK_input(MM_write_data),					// 8 bit input used to update the TIMSK register
	.TIFR_input(MM_write_data),
	
	// Register write enable signals
	.TCNT_write_enable(1'b0),	// never write to it 
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

