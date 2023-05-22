/*
Performs Q = A (op) B 
Also updates sreg 
OP:
	0 - add
	1 - subtract
	2 - multiply
	3 - left shift
	4 - right shift
	5 - logical and
	6 - logical or
	7 - logical xor 
*/
module ALU (
	input clk,
	input reset_n,
	input mem_write,
	input [7:0] mem_data,

	input [7:0] A,
	input [7:0] B,
	
	input [2:0] op,
	
	input use_carry, // if set will incorporate carry into add, sub and shifts 
	
	output [7:0] Q,
	output [7:0] sreg
);

// SREG: ITHSVNZC
reg [7:0] result; 
reg I; // interrupt
reg T; // bit copy storage 
reg H; // half carry
reg S; // sign bit
reg V; // twos complement overflow
reg N; // negative 
reg Z; // zero
reg C; // carry 
wire [7:0] status = {I,T,H,S,V,N,Z,C}
wire [7:0] mux_out;

multi_bit_multiplexer_2way #(.WIDTH = 4'h8) sreg_sel (
	.A(status),
	.B(mem_data),
	.S(mem_write),
	.out(mux_out)
)

d_flip_flop_multi_bit_en #(.WIDTH = 4'h8) status_reg (
	.d(mux_out),
	.clk(clk),
	.clr_n(reset_n),
	.enable(1'b1),
	.Q(sreg),
	.Qn()
);

always @(*) begin 
	case (op)
		3'b000: begin //Adition 
			if (use_carry == 1'b1) begin //ADC	
				result = A + B + sreg[0];
				C = A[7] & B[7] | A[7] & ~result[7] | B[7] & ~result[7];
				Z = !(|result);
				N = result[7];
				V = A[7] & B[7] & ~result[7] + ~A[7] & ~B[7] & result[7];
				S = V ^ N; 
				H = A[3] & B[3] | A[3] & ~result[3] | B[3] & ~result[3];
				T = sreg[6];
				I = sreg[7];
			end
			else begin //ADD
				result = A + B;
				C = A[7] & B[7] | A[7] & ~result[7] | B[7] & ~result[7];
				Z = !(|result);
				N = result[7];
				V = A[7] & B[7] & ~result[7] + ~A[7] & ~B[7] & result[7];
				S = V ^ N; 
				H = A[3] & B[3] | A[3] & ~result[3] | B[3] & ~result[3];
				T = sreg[6];
				I = sreg[7];
			end
		end 
		3'b001: begin
			if (use_carry == 1'b1) begin 
				result = A - B - sreg[0];
				C = !A[7] & B[7] | B[7] & result[7] | result[7] & !A[7];
				Z = !(|result);
				N = result[7];
				V = A[7] & !B[7] & ~result[7] + ~A[7] & ~B[7] & result[7];
				S = V ^ N; 
				H = !A[3] & B[3] | B[3] & result[3] | result[3] & !A[3];
				T = sreg[6];
				I = sreg[7];
			end 
			else begin
				result = A - B;
				C = !A[7] & B[7] | B[7] & result[7] | result[7] & !A[7];
				Z = !(|result);
				N = result[7];
				V = A[7] & !B[7] & ~result[7] + ~A[7] & ~B[7] & result[7];
				S = V ^ N; 
				H = !A[3] & B[3] | B[3] & result[3] | result[3] & !A[3];
				T = sreg[6];
				I = sreg[7];
			end
		end
		3'b010: begin // this needs to use 2 registers 
			result = A * B;
		end
		3'b011: 
			begin
				if (use_carry == 1'b1) begin 
					result = A << B;
				end
				else begin 
					result = A << B;
				end
			end
		3'b100: result = A >> B;
		3'b101: begin //AND
			result = A & B;
			C = sreg[0];
			Z = !(|result);
			N = result[7];
			V = 1'b0;
			S = V ^ N;
			H = sreg[5]
			T = sreg[6];
			I = sreg[7];
		end
		3'b110: begin // OR
			result = A | B;
			C = sreg[0];
			Z = !(|result);
			N = result[7];
			V = 1'b0;
			S = V ^ N;
			H = sreg[5]
			T = sreg[6];
			I = sreg[7];
		end
		3'b111: begin //xor 
			result = A ^ B;
			C = sreg[0];
			Z = !(|result);
			N = result[7];
			V = 1'b0;
			S = V ^ N;
			H = sreg[5]
			T = sreg[6];
			I = sreg[7];
		end 
		default: begin 
			result = 8'b0;
		end
	endcase 
end 

assign Q = result;

endmodule
