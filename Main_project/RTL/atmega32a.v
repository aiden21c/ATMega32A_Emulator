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
assign  sysClock = clock50MHz;
//single16MHzPLL single16MHzPLL(
//	.refclk(clock50MHz),   				//  refclk.clk 50MHz
//	.rst(reset_n),      					//   reset.reset
//	.outclk_0(sysClock) 					// outclk0.clk
//);
wire [7:0] RD1;
wire [7:0] RD2;
wire [255:0] all_registers;
wire [7:0] tifr_timer0_O;
wire [7:0] timsk_timer0_O; 
wire [7:0] TCNT0_O;
wire [7:0] TCCR0_O;
wire [7:0] OCR0_O;
//********************************************************************************************************************************
// Instantiate the control unit
wire [7:0] tifr_timer1_O;
wire [7:0] timsk_timer1_O; 
wire [7:0] TCNT1H_O;
wire [7:0] TCNT1L_O;
wire [7:0] TCCR1_O;
wire [7:0] OCR1AH_O;
wire [7:0] OCR1AL_O;
wire CU_part2;
wire [2:0] CU_ALU_sel;
wire [7:0] RF_WD_selected;
wire CU_PC_inc;
wire CU_IREG_hold;
wire CU_PC_overwrite;
wire CU_GP_reg_write;
wire [7:0] DDRC_O;
wire [7:0] DDRB_O;
wire [7:0] PORTC_O;
wire [7:0] PORTB_O;
wire [7:0] PINC_O;
wire [7:0] PINB_O;
assign GPIOC_port = PORTC_O;
assign GPIOB_port = PORTB_O;
wire CU_USE_carry;
wire CU_STATUS_reg_sel;
wire CU_IO_only_flag;
wire CU_memory_write_en;
wire CU_SP_write_en;
wire [1:0] CU_clock_counter;
wire [1:0] INTERRUPT_STAGE;
wire [7:0] status_register_bus;
wire [15:0] alu_output;
wire [7:0] SREG_O = status_register_bus;
wire CU2_LPM_enable;
wire [7:0] MM_data_in_selected;
wire SP_inL_sel;
wire [15:0] MM_address_selected;
wire [7:0] SP_inL_selected;
wire [15:0] MM_address_mux_A = all_registers[239:224]; // Y reg
wire [2:0] MM_addr_sel;
wire [1:0] MM_data_sel;
wire [1:0] PM_PC_new_sel;
wire [1:0] ALU_arg2_sel;
wire ALU_arg1_sel;
wire RF_WA_sel;
wire [2:0] RF_WD_sel;
wire [15:0] sp;
wire [7:0] SPH_O;
wire [7:0] SPL_O; 
// D unused 
wire [13:0] PM_PC_new_selected;
wire [63:0] MM_IO_we_bus; // 64 bit bus for the write enable signals for the memory map
wire MM_reg_WE;
wire [4:0] MM_reg_write_addr;
wire [7:0] MM_write_data; 
wire [7:0] MM_Q_O; // 8 bit output from the memory map
wire [7:0] argument_1;
wire [7:0] argument_2;
wire [7:0] instruction_id;
wire [13:0] program_counter;
wire [15:0] PM_instruction_O; // 16 bit instruction output from the program memory
wire [7:0] PM_LPM_O;
wire [7:0] ALU_arg2_selected;
wire [7:0] ALU_arg1_selected; 
wire [4:0] RF_WA_selected;
wire [7:0] TIFR_O = tifr_timer0_O | tifr_timer1_O;
wire [7:0] TIMSK_O = timsk_timer0_O | timsk_timer1_O;
wire [15:0] MM_address_mux_B = {8'b0, argument_2};	// 8 bit argument 2
wire [15:0] MM_address_mux_D = {sp[15:8], alu_output[7:0]}; // 16 bit stack pointer
wire [7:0] MM_PCH = {2'b0, program_counter[13:8]};
wire [7:0] MM_SREG_I = {(SREG_O[7]^1'b1), SREG_O[6:0]};

wire [13:0] TC_arg = ~{argument_2[5:0], argument_1} + 14'b1;

//wire [13:0] PC_new_C = program_counter + {argument_2[5:0], argument_1} + 14'h1;
reg [13:0] PC_new_C; 
always @(program_counter, TC_arg) begin
	if(argument_2[5] == 1'b1) begin
		PC_new_C = program_counter - TC_arg + 14'h1;
	end
	else begin
		PC_new_C = program_counter + {argument_2[5:0], argument_1} + 14'h1;
	end
end

wire [511:0] IO_cat_bus = {
	SREG_O, SPH_O, SPL_O, OCR0_O,
	16'B0, // 2 registers 
	TIMSK_O, TIFR_O,
	32'B0,	// 4 registers 
	TCCR0_O, TCNT0_O,
	24'B0,	// 3 registers 
	TCCR1_O, TCNT1H_O, TCNT1L_O, OCR1AH_O, OCR1AL_O,
	136'B0, // 17 registers 
	PORTB_O, DDRB_O, PINB_O, PORTC_O, DDRC_O, PINC_O, 
	152'B0	// 19 registers 
};

control_unit control_unit(
    .clk(sysClock),
	 .reset_n(reset_n),

    .instruction_id(instruction_id),
    .status_register(SREG_O),
	.OC_flag(TIFR_O[4]),

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
	.SP_WRITE_ENABLE(CU_SP_write_en), 
	.CLOCK_COUNTER(CU_clock_counter),
	.INTERRUPT_STAGE(INTERRUPT_STAGE)
);

//*******************************************************************************************************************************



control_unit_2 control_unit_2 (
	.clk(sysClock),
	.reset_n(reset_n),
	.instruction_id(instruction_id),
	.clock_counter(CU_clock_counter),

	.LPM_enable(CU2_LPM_enable)
);

//*******************************************************************************************************************************
// Instatiate the control MUX unit

control_mux control_mux (
   	.clk(sysClock),
   	.reset_n(reset_n), 

   	.instruction_id(instruction_id),
   	.clock_counter(CU_clock_counter),
	.interrupt_stage(INTERRUPT_STAGE),
   
   // Output MUX selector signals
   	.SP_inL_sel(SP_inL_sel),
   	.MM_addr_sel(MM_addr_sel),
   	.MM_data_sel(MM_data_sel),
   	.PM_PC_new_sel(PM_PC_new_sel),
	.ALU_arg2_sel(ALU_arg2_sel),
   	.ALU_arg1_sel(ALU_arg1_sel),
   	.RF_WA_sel(RF_WA_sel),
   	.RF_WD_sel(RF_WD_sel)
);

//*******************************************************************************************************************************
// Stack pointer in multiplexers 
// either from ALU (+/- 1) or from memory map when writing to SPH or SPL


multi_bit_multiplexer_2way #(8) SP_inL_mux (
	.A(alu_output[7:0]), .B(MM_write_data), .S(SP_inL_sel), .out(SP_inL_selected)
);

// Instantiate the Stack Pointer

stack_pointer stack_pointer (
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

//*******************************************************************************************************************************
// multiplexer for MM address selection
// Can come from Y reg on register file or from decoder arguments or from SP, or ALU
// Option 5 is hard coded SREG address 


multi_bit_multiplexer_8way #(16) MM_address_mux (
	.reg0(MM_address_mux_A), .reg1(MM_address_mux_B), .reg2(sp), .reg3(MM_address_mux_D), 
	.reg4(16'h3F), .reg5(16'h0), .reg6(16'h0), .reg7(16'h0), 
	.S(MM_addr_sel), .out(MM_address_selected)
);

// mux for data in 
// can come from reg file, PCL or PCH, or from SREG toggle I


multi_bit_multiplexer_4way #(8) MM_data_in_mux (
	.A(RD1), .B(program_counter[7:0]), .C(MM_PCH), .D(MM_SREG_I), // PC + 1'b1 for storing next PC address 
	.S(MM_data_sel), .out(MM_data_in_selected)
);


// Instantiate the Memory Map
memory_map memory_map (
	.clk(sysClock),

	.addr(MM_address_selected),	//16 bit address	
	.register_bus(all_registers), //A bus of all 32 GP registers 
	.IO_bus(IO_cat_bus), //A bus of all 64 IO registers 
	
	.WE(CU_memory_write_en),	//write enable
	.data_in(MM_data_in_selected),
	
	.IO_only(CU_IO_only_flag),
	
	.Q(MM_Q_O),
	.IO_WE(MM_IO_we_bus), 
	.reg_WE(MM_reg_WE),
	.reg_write_addr(MM_reg_write_addr), 
	.write_data(MM_write_data)
);

//*******************************************************************************************************************************
// Instantiate the Instruction Decoder

instruction_decoder instruction_decoder (
	.instruction(PM_instruction_O),
	.part2(CU_part2),
	
	.instruction_id(instruction_id),	// 0x00 - 0x41 or 0xff if the read is an address for 32 bit instruction
	.argument_1(argument_1),
	.argument_2(argument_2)
);

//*******************************************************************************************************************************
// mux for PC_new
// can come from interrupt trigger, decoder argument, from the controller (call/Ret) 
// C is K from decoder for RJMP/RCALL 

multi_bit_multiplexer_4way #(14) PM_PC_new_mux (
	.A(14'h00E), .B((program_counter + {6'b0, argument_1} + 14'h1)), .C(PC_new_C), .D(14'b0), .S(PM_PC_new_sel), .out(PM_PC_new_selected)
);

// Instatiate the program memory
wire [15:0] ireg_test_sig;
prog_memory prog_memory(
	.clk(sysClock),
	.reset_n(reset_n), 			// resets everything

	// Inputs
	.PC_inc(CU_PC_inc),			//set by control unit when I reg changes 
	.hold(CU_IREG_hold),
	.PC_overwrite(CU_PC_overwrite),  			// set to overwrite the PC with PC_new  - May need to split this signal to interrupt and other 
	.PC_new(PM_PC_new_selected),
	.LPM_addr(all_registers[254:240]), // Z register hard coded 
	.LPM_read(CU2_LPM_enable),	// set to read with LPM	

	// Outputs
	.LPM_data(PM_LPM_O),
	.instruction(PM_instruction_O), 			// The I-reg output 
	.program_counter(program_counter),			// The PC output
	.ireg_test(ireg_test_sig)
);

//*******************************************************************************************************************************
// Multiplexer for ALU arg 2 selection 
// From register file output 2 or from arg2 of instruction decoder or from SP

multi_bit_multiplexer_4way #(8) ALU_arg2 (
	.A(RD2), .B(argument_2), .C(8'h1), .D(8'b0), .S(ALU_arg2_sel), .out(ALU_arg2_selected)
);

// ALU argument 1 selection
// comes from either RD1 or SP
multi_bit_multiplexer_2way #(8) ALU_arg1 (
	.A(RD1), .B(sp[7:0]), .S(ALU_arg1_sel), .out(ALU_arg1_selected)
);

// Instatiate the ALU

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
// wire sreg_selected_bit;
// multi_bit_multiplexer_8way #(1) status_register (
// 	.reg0(status_register_bus[0]), .reg1(status_register_bus[1]), .reg2(status_register_bus[2]), .reg3(status_register_bus[3]), 
// 	.reg4(status_register_bus[4]), .reg5(status_register_bus[5]), .reg6(status_register_bus[6]), .reg7(status_register_bus[7]),
// 	.S(), .out(sreg_selected_bit)
// );

//*******************************************************************************************************************************
// reg file WA mux
// can select from decoder argyment, memory map 

multi_bit_multiplexer_2way #(5) RegFile_WA_mux (
	.A(argument_1[4:0]), .B(MM_reg_write_addr), .S(RF_WA_sel), .out(RF_WA_selected) 
);

// reg file WD mux
// can come from ALU, memory map data, decoder argument or LPM output 

multi_bit_multiplexer_8way #(8) RegFile_WD_mux (
	.reg0(alu_output[7:0]), .reg1(MM_write_data), .reg2(argument_2), .reg3(PM_LPM_O), 
	.reg4(MM_Q_O), .reg5(8'h0), .reg6(8'h0), .reg7(8'h0),
	.S(RF_WD_sel), .out(RF_WD_selected)
);

// Instantiate the register file

register_file register_file(
	.clock(sysClock),						// Clock input
	.clr_n(reset_n),

	// Inputs
	.RA1(argument_1[4:0]),							// Read register 1
	.RA2(argument_2[4:0]),							// Read register 2
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


//*******************************************************************************************************************************
// Instantiate the 8-bit Timer 0

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


//*******************************************************************************************************************************
// Instantiate the 16-bit Timer 1

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
	.OCR1_write_enable(MM_IO_we_bus[43]),
	.OCR2_write_enable(MM_IO_we_bus[42]),
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


// Wire for IO bus for memory map 


endmodule

