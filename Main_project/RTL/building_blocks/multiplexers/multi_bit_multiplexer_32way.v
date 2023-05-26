module multi_bit_multiplexer_32way #(parameter WIDTH = 1) (
	reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9, reg10, 
	reg11, reg12, reg13, reg14, reg15, reg16, reg17, reg18, reg19, reg20, reg21, 
	reg22, reg23, reg24, reg25, reg26, reg27, reg28, reg29, reg30, reg31,
	S, out
);

input [WIDTH-1:0] reg0;input [WIDTH-1:0] reg1;
input [WIDTH-1:0] reg2;input [WIDTH-1:0] reg3;
input [WIDTH-1:0] reg4;input [WIDTH-1:0] reg5;
input [WIDTH-1:0] reg6;input [WIDTH-1:0] reg7;
input [WIDTH-1:0] reg8;input [WIDTH-1:0] reg9;
input [WIDTH-1:0] reg10;input [WIDTH-1:0] reg11;
input [WIDTH-1:0] reg12;input [WIDTH-1:0] reg13;
input [WIDTH-1:0] reg14;input [WIDTH-1:0] reg15;
input [WIDTH-1:0] reg16;input [WIDTH-1:0] reg17;
input [WIDTH-1:0] reg18;input [WIDTH-1:0] reg19;
input [WIDTH-1:0] reg20;input [WIDTH-1:0] reg21;
input [WIDTH-1:0] reg22;input [WIDTH-1:0] reg23;
input [WIDTH-1:0] reg24;input [WIDTH-1:0] reg25;
input [WIDTH-1:0] reg26;input [WIDTH-1:0] reg27;
input [WIDTH-1:0] reg28;input [WIDTH-1:0] reg29;
input [WIDTH-1:0] reg30;input [WIDTH-1:0] reg31;

input [4:0] S;
output [WIDTH-1:0] out;

reg [WIDTH-1:0] outReg;


always @(reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9, reg10, 
			reg11, reg12, reg13, reg14, reg15, reg16, reg17, reg18, reg19, reg20, reg21, 
			reg22, reg23, reg24, reg25, reg26, reg27, reg28, reg29, reg30, reg31, S)
	begin
		case(S)
			5'b00000:
				begin
					outReg = reg0;
				end
			5'b00001:
				begin
					outReg = reg1;
				end
			5'b00010:
				begin
					outReg = reg2;
				end
			5'b00011:
				begin
					outReg = reg3;
				end
			5'b00100:
				begin
					outReg = reg4;
				end
			5'b00101:
				begin
					outReg = reg5;
				end
			5'b00110:
				begin
					outReg = reg6;
				end
			5'b00111:
				begin
					outReg = reg7;
				end
			5'b01000:
				begin
					outReg = reg8;
				end
			5'b01001:
				begin
					outReg = reg9;
				end
			5'b01010:
				begin
					outReg = reg10;
				end
			5'b01011:
				begin
					outReg = reg11;
				end
			5'b01100:
				begin
					outReg = reg12;
				end
			5'b01101:
				begin
					outReg = reg13;
				end
			5'b01110:
				begin
					outReg = reg14;
				end
			5'b01111:
				begin
					outReg = reg15;
				end
			5'b10000:
				begin
					outReg = reg16;
				end
			5'b10001:
				begin
					outReg = reg17;
				end
			5'b10010:
				begin
					outReg = reg18;
				end
			5'b10011:
				begin
					outReg = reg19;
				end
			5'b10100:
				begin
					outReg = reg20;
				end
			5'b10101:
				begin
					outReg = reg21;
				end
			5'b10110:
				begin
					outReg = reg22;
				end
			5'b10111:
				begin
					outReg = reg23;
				end
			5'b11000:
				begin
					outReg = reg24;
				end
			5'b11001:
				begin
					outReg = reg25;
				end
			5'b11010:
				begin
					outReg = reg26;
				end
			5'b11011:
				begin
					outReg = reg27;
				end
			5'b11100:
				begin
					outReg = reg28;
				end
			5'b11101:
				begin
					outReg = reg29;
				end
			5'b11110:
				begin
					outReg = reg30;
				end
			5'b11111:
				begin
					outReg = reg31;
				end
		endcase
	end

assign out = outReg;


endmodule
