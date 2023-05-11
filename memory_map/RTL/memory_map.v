// this unit could also contain the RAM

module memory_map (
	input [15:0] addr,	//16 bit address
	input clk,
	
	input [255:0] register_bus, //A bus of all 32 GP registers 
	input [511:0] IO_bus, //A bus of all 64 IO registers 
	
	input WE,	//write enable
	input [7:0] data_in,
	
	input IO_only,
	
	output [7:0] Q,
	output [63:0] IO_WE, 
	output [31:0] reg_WE
);

reg [7:0] data_out; 
assign Q = data_out;

reg [10:0] sram_addr;
reg sram_WE; 
wire [7:0] sram_out;

reg [63:0] IO_enable;
reg [31:0] reg_enable; 
assign IO_WE = IO_enable; 
assign reg_WE = reg_enable;

sram sram0 (
	.address(sram_addr),
	.clock(clk),
	.data(data_in),
	.wren(sram_WE),
	.q(sram_out)
);

integer i;  

always @(posedge(clk)) begin
	//if the io_only bit is set then the address just reads from the IO bus
	if (IO_only == 1'b1) begin
		sram_addr = 0;
		sram_WE = 0;
		reg_enable = 0;
		for (i=0; i < 64; i=i+1) begin 
			if (addr == i) begin 
				data_out = IO_bus[i*8 +: 8];
				if (WE == 1'b1) IO_enable = 64'h1 << i;
				else IO_enable = 0; 
			end
		end 
	end	
	//if address is in low section then read from register file 0x0000-0x001F
	else if (addr <= 16'h001F) begin
		sram_addr = 0; 
		sram_WE = 0; 
		IO_enable = 0; 
		for (i=0; i<32; i=i+1) begin 
			if(addr == i) begin 
				data_out = register_bus[i*8 +: 8];
				if (WE == 1'b1) reg_enable = 32'h1 << i;
				else reg_enable = 0; 
			end
		end
	end
	//if address is in middle then read from IO 0x0020-0x005F
	else if (addr <= 16'h005F) begin 
		sram_addr = 0;
		sram_WE = 0; 
		reg_enable = 0; 
		for (i=0; i < 64; i=i+1) begin 
			if ((addr-8'h20) == i)begin
				data_out = IO_bus[i*8 +: 8];
				if (WE == 1'b1) IO_enable = 64'h1 << i;
				else IO_enable = 0; 
			end
		end
	end
	//if address is in high section then read from RAM 0x0060-0x085F
	else begin 
		sram_addr = addr[10:0]-8'h5F;
		sram_WE = 1; 
		reg_enable = 0;
		IO_enable = 0;
		data_out = sram_out;
	end
end

endmodule 