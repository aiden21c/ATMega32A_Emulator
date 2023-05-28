

module decoder_test (
	input clk,
	input reset_n, 
	
	output [13:0] PC,
	output [15:0] ireg,
	
	output [7:0] id,
	output [7:0] arg1,
	output [7:0] arg2
);

wire [15:0] ireg_temp;

prog_memory pm (
	.clk(clk),
	.reset_n(reset_n),
	.PC_inc(1'b1),
	.hold(1'b0),
	.PC_overwrite(1'b0),
	.PC_new(14'b0),
	.instruction(ireg_temp),
	.program_counter(PC)
);

instruction_decoder decoder (
	.instruction(ireg_temp),
	.part2(1'b0),
	.instruction_id(id),
	.argument_1(arg1),
	.argument_2(arg2)
);

assign ireg = ireg_temp; 

endmodule
