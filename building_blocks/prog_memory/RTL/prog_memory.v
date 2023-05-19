module prog_memory (
	input clk,
	input reset_n, // resets everything
	input instruction_running, // 1 if instruction in I-reg is running (for multi bit instructions)
	input PC_overwrite,  // set to overwrite the PC with PC_new  - May need to split this signal to interrupt and other 
	input [13:0] PC_new,
	output [15:0] instruction, // The I-reg output 
	output [13:0] program_counter	// The PC output
);

reg [13:0] PC; 
reg [7:0] Ireg_high;
reg [7:0] Ireg_low; 

wire [7:0] rom_low; // output of the rom 
wire [7:0] rom_high;	// will be the data pointed to by PC and PC+1
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
	.Qa(rom_low),
	.Qb(rom_high)
);

always @(posedge(clk), negedge(reset_n)) begin 
	if (reset_n == 1'b0) PC = 0; // reset 
	else if (PC_overwrite == 1'b1) PC = PC_new; // overwrite for branch, jump, etc 
	else if (instruction_running == 1'b0) PC = PC + 1'b1;  // normal inc if instruction finishes 
	else PC = PC;	// else save state 
end

// I reg update 
always @(posedge(clk), negedge(reset_n)) begin 
	if (reset_n == 1'b0) begin	// reset 
		Ireg_high = 8'b0;
		Ireg_low = 8'b0; 
	end
	else if (instruction_running == 1'b0) begin // need to handle flushing pipeline 
		Ireg_high = rom_high;
		Ireg_low = rom_low;
	end
	else begin 
		Ireg_high = Ireg_high;
		Ireg_low = Ireg_low;
	end
end

endmodule
