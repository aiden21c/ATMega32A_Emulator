module prog_memory (
	input clk,
	input reset_n, // resets everything
	input PC_inc,	//set by control unit when I reg changes 
	input hold,
	input PC_overwrite,  // set to overwrite the PC with PC_new  - May need to split this signal to interrupt and other 
	input [13:0] PC_new,
	output [15:0] instruction, // The I-reg output 
	output [13:0] program_counter	// The PC output
);

reg [13:0] PC; 

wire [7:0] Ireg_low; // output of the rom 
wire [7:0] Ireg_high;	// will be the data pointed to by PC and PC+1
wire [14:0] read_addr = PC << 1'b1;

assign instruction = {Ireg_high, Ireg_low};
assign program_counter = PC;

dual_ROM prog_mem (
	.clk(clk),
	.data(8'h0),
	.write_addr(15'h0),
	.WE(1'b0),	// its a ROM, no writing
	.addr_a(read_addr),
	.addr_b(read_addr + 1'b1),
	.clr_reg_n(~PC_overwrite),
	.en_reg(~hold),
	.Qa(Ireg_low),
	.Qb(Ireg_high)
);

always @(posedge(clk), negedge(reset_n)) begin 
	if (reset_n == 1'b0) PC = 0; // reset 
	else if (PC_overwrite == 1'b1) PC = PC_new; // overwrite for branch, jump, etc 
	else if (PC_inc == 1'b1) PC = PC + 1'b1;  // normal inc
	else PC = PC;	// else save state 
end

endmodule
