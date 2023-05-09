// this unit could also contain the RAM

module memory_map (
	input [15:0] addr,	//16 bit address
	input clk,
	
	input [255:0] register_bus, //A bus of all 32 GP registers 
	input [511:0] IO_bus, //A bus of all 64 IO registers 
	
	input WE,	//write enable
	input [7:0] data_in,
	
	input IO_only,
	
	output [7:0] Q
);

reg [7:0] data_out; 
assign Q = data_out;

reg [10:0] sram_addr;
wire [7:0] sram_out;

sram sram0 (
	.address(sram_addr),
	.clock(clk),
	.data(data_in),
	.wren(WE),
	.q(sram_out)
);

integer i;  

always @(posedge(clk)) begin
	//if the io_only bit is set then the address just reads from the IO bus
	if (IO_only == 1'b1) begin
		sram_addr = 0;
		for (i=0; i < 64; i=i+1) begin 
			if (addr == i) data_out = IO_bus[i*8 +: 8];
		end 
	end	
	//if address is in low section then read from register file 0x0000-0x001F
	else if (addr <= 4'h001F) begin
		sram_addr = 0; 
		for (i=0; i<32; i=i+1) begin 
			if(addr == i) data_out = register_bus[i*8 +: 8];
		end
	end
	//if address is in middle then read from IO 0x0020-0x005F
	else if (addr <= 4'h005F) begin 
		sram_addr = 0;
		for (i=0; i < 64; i=i+1) begin 
			if ((addr-2'h20)== i) data_out = IO_bus[i*8 +: 8];
		end
	end
	else begin 
		sram_addr = addr[10:0];
		data_out = sram_out;
	end
	//if address is in high section then read from RAM 0x0060-0x085F
end

endmodule 