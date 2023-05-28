// 4-way multiplexer of parametised width
// S = 00: A output
// S = 01: B output
// S = 10: C output
// S = 11: D output

module multi_bit_multiplexer_4way #(parameter WIDTH = 1) (
	A, B, C, D, S, out
);

input [WIDTH-1:0] A;
input [WIDTH-1:0] B;
input [WIDTH-1:0] C;
input [WIDTH-1:0] D;
input [1:0] S;
output [WIDTH-1:0] out;

wire [WIDTH-1:0] m1out;
wire [WIDTH-1:0] m2out;

multi_bit_multiplexer_2way #(WIDTH) m1 (.A(A), .B(C), .S(S[0]), .out(m1out));
multi_bit_multiplexer_2way #(WIDTH) m2 (.A(B), .B(D), .S(S[0]), .out(m2out));
multi_bit_multiplexer_2way #(WIDTH) m3 (.A(m1out), .B(m2out), .S(S[1]), .out(out));

endmodule
