// this unit could also contain the RAM

module memory_map (
	input [15:0] addr,	//16 bit address
	input clk,
	
	input [31:0] register_bus, //A bus of all 32 GP registers 
	input [31:0] IO_bus, //A bus of all 64 IO registers 
	
	input WE,	//write enable
	input [7:0] data_in,
	
	input IO_only,
	
	output [7:0] Q
);

reg [7:0] data_out; 
assign Q = data_out;

wire [10:0] sram_addr;
wire [7:0] sram_out;

sram sram0 (
	.address(sram_addr),
	.clock(clk),
	.data(data_in),
	.wren(WE),
	.q(sram_out)
);

wire [15:0]temp = addr << 3; 

always @(posedge(clk)) begin
	//if the io_only bit is set then the address just reads from the IO bus
	if (IO_only == 1'b1) begin
		data_out = {
			IO_bus[temp], 
			IO_bus[temp+1], 
			IO_bus[temp+2],
			IO_bus[temp+3],
			IO_bus[temp+4],
			IO_bus[temp+5],
			IO_bus[temp+6],
			IO_bus[temp+7],
		};
	end	
	else 
		data_out = 8'b11111111;
	//if address is in low section then read from register file 0x0000-0x001F

	//if address is in middle then read from IO 0x0020-0x005F

	//if address is in high section then read from RAM 0x0060-0x085F
end

endmodule 