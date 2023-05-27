module multi_bit_multiplexer_8way #(parameter WIDTH = 1) (
	reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7,
	S, out
);

input [WIDTH-1:0] reg0;input [WIDTH-1:0] reg1;
input [WIDTH-1:0] reg2;input [WIDTH-1:0] reg3;
input [WIDTH-1:0] reg4;input [WIDTH-1:0] reg5;
input [WIDTH-1:0] reg6;input [WIDTH-1:0] reg7;

input [2:0] S;
output [WIDTH-1:0] out;

reg [WIDTH-1:0] outReg;


always @(reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7, S)
	begin
		case(S)
			3'b000:
				begin
					outReg = reg0;
				end
			3'b001:
				begin
					outReg = reg1;
				end
			3'b010:
				begin
					outReg = reg2;
				end
			3'b011:
				begin
					outReg = reg3;
				end
			3'b100:
				begin
					outReg = reg4;
				end
			3'b101:
				begin
					outReg = reg5;
				end
			3'b110:
				begin
					outReg = reg6;
				end
			3'b111:
				begin
					outReg = reg7;
				end
		endcase
	end

assign out = outReg;


endmodule
