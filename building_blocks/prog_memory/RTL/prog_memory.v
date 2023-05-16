module prog_memory (
	input clk,
	input reset_n, 	
	input PC_overwrite,
	input [13:0] PC_new,
	output [15:0] instruction,
	output [13:0] program_counter
);

reg [13:0] PC; 

wire [7:0] Ireg_low;
wire [7:0] Ireg_high;
wire [14:0] read_addr = PC << 1'b1;

assign instruction = {Ireg_high, Ireg_low};
assign program_counter = PC;

/*
ROM_IP prog_mem (
	.clock(clk),
	.address_a(read_addr),
	.address_b(read_addr + 1'b1),
	.q_a(Ireg_low),
	.q_b(Ireg_high)
);
*/

dual_ROM prog_mem (
	.clk(clk),
	.data(8'h0),
	.write_addr(15'h0),
	.WE(1'b0),
	.addr_a(read_addr),
	.addr_b(read_addr + 1'b1),
	.Qa(Ireg_low),
	.Qb(Ireg_high)
);

always @(posedge(clk), negedge(reset_n)) begin 
	if (reset_n == 1'b0) PC = 0; 
	else if (PC_overwrite == 1'b1) PC = PC_new;
	else PC = PC + 1'b1;
end

endmodule
