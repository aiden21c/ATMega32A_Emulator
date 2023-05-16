
module dual_ROM (
	input clk,
	input [7:0] data,
	input [14:0] write_addr,
	input WE,

	input [14:0] addr_a, // 2 address ports 
	input [14:0] addr_b,
	
	output [7:0] Qa,	// 2 output ports
	output [7:0] Qb
);

reg [7:0] rom [32767:0];
reg [7:0] outA;
reg [7:0] outB;

initial $readmemh("D:/Documents/Uni/QuartusProjects/EEET2162_ATMega32A_Emulation/building_blocks/prog_memory/mem.hex", rom);

always @(posedge(clk)) begin 
	if (WE == 1'b1) rom[write_addr] = data;
end

always @(posedge(clk)) begin 
	outA = rom[addr_a];
	outB = rom[addr_b];
end

assign Qa = outA;
assign Qb = outB;

endmodule
