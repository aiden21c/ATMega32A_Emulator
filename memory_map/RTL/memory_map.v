// this unit could also contain the RAM

module memory_map (
	input [15:0] addr,	//16 bit address
	input clk,
	input [1:0] register_bus, //size TBD
	input [1:0] IO_bus, //size TBD
	input WE,	//write enable
	input io_only,	//set this for I/O instructions where only reading from I/O
	
	output [7:0] data
);

reg [7:0] data_out; 
assign data = data_out;

//initialize ram here 
//it shouldnt need to be accessed elsewhere 

always @(posedge(clk)) begin
	//if the io_only bit is set then the address just reads from the IO bus
	//used for in and out instructions 

	//if address is in low section then read from register file 

	//if address is in middle then read from IO

	//if address is in high section then read from RAM
end

endmodule 