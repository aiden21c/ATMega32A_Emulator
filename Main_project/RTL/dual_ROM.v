
module dual_ROM (
	input clk,
	input [7:0] data,
	input [14:0] write_addr,
	input WE,

	input [14:0] addr_a, // 2 address ports 
	input [14:0] addr_b,
	
	input clr_reg_n,
	input en_reg,
	
	output [7:0] Qa,	// 2 output ports
	output [7:0] Qb
);

reg [7:0] rom [32767:0];
wire [7:0] dataA = rom[addr_a];
wire [7:0] dataB = rom[addr_b];
wire [7:0] outA;
wire [7:0] outB;

initial $readmemh("C:/Users/jkdow/Documents/QuartusPrime/EEET2162_ATMega32A_Emulation/Main_project/resources/mem.hex", rom);
//initial $readmemh("mem.hex", rom);

always @(posedge(clk)) begin 
	if (WE == 1'b1) rom[write_addr] = data;
end

d_flip_flop_multi_bit_en #(.WIDTH(4'h8), .RESETVAL(8'b0)) IregHigh (
	.d(dataA),
	.clk(clk),
	.clr_n(clr_reg_n),
	.enable(en_reg),
	.Q(outA),
	.Qn()
);

d_flip_flop_multi_bit_en #(.WIDTH(4'h8), .RESETVAL(8'b0)) IregLow (
	.d(dataB),
	.clk(clk),
	.clr_n(clr_reg_n),
	.enable(en_reg),
	.Q(outB),
	.Qn()
);

assign Qa = outA;
assign Qb = outB; 

endmodule
