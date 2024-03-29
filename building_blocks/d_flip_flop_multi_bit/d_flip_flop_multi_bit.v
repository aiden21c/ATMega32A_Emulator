// A multi-bit D-type flip-flop which has a default width of 1-bit and a default reset value of 0
// The width of the flip flop and the reset value can be adjusted using parameters


module d_flip_flop_multi_bit #(parameter WIDTH = 1, parameter RESETVAL = 0)
(
	d, clk, clr_n,				// System inputs: data, clock and the reset signal
	Q, Qn
);

// Define the input and outputs with their data width
input [WIDTH-1:0] d;
input clk, clr_n;
output [WIDTH-1:0] Q;
output [WIDTH-1:0] Qn;

reg [WIDTH-1:0] q;


always @(posedge(clk), negedge(clr_n))
	if(!clr_n)						// clr_n is active low and hence the system is reset when it is low
		begin
			q <= RESETVAL;
		end
	else
		begin
			q <= d;					// Q is assigned the value of D on the rising clock edge
		end
		
		
assign Q = q;
assign Qn = ~q;


endmodule
