// 2-way Multiplexer of parametised bit width (WIDTH)
// S = 0: A output
// S = 1: B output
module multi_bit_multiplexer_2way #(parameter WIDTH = 1) (
	A, B, S, out
);

input [WIDTH-1:0] A;
input [WIDTH-1:0] B;
input S;
output [WIDTH-1:0] out;

reg [WIDTH-1:0] o;

always @(A, B, S)
	if(S == 0)
		o = A;
	else 
		o = B;

assign out = o;
endmodule
