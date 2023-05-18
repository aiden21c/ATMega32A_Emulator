module multi_bit_multiplexer_32way_test (
	input [4:0] reg0_out, input [4:0] reg1_out, input [4:0] reg2_out, input [4:0] reg3_out,
	input [4:0] reg4_out, input [4:0] reg5_out, input [4:0] reg6_out, input [4:0] reg7_out,
	input [4:0] reg8_out, input [4:0] reg9_out, input [4:0] reg10_out, input [4:0] reg11_out,
	input [4:0] reg12_out, input [4:0] reg13_out, input [4:0] reg14_out, input [4:0] reg15_out,
	input [4:0] reg16_out, input [4:0] reg17_out, input [4:0] reg18_out, input [4:0] reg19_out,
	input [4:0] reg20_out, input [4:0] reg21_out, input [4:0] reg22_out, input [4:0] reg23_out,
	input [4:0] reg24_out, input [4:0] reg25_out, input [4:0] reg26_out, input [4:0] reg27_out,
	input [4:0] reg28_out, input [4:0] reg29_out, input [4:0] reg30_out, input [4:0] reg31_out,
	
	input [4:0] S,
	
	output [4:0] out
);

multi_bit_multiplexer_32way #(5) mux(
	.reg0(reg0_out), .reg1(reg1_out), .reg2(reg2_out), .reg3(reg3_out), .reg4(reg4_out), .reg5(reg5_out), .reg6(reg6_out), .reg7(reg7_out), .reg8(reg8_out), .reg9(reg9_out), .reg10(reg10_out), 
	.reg11(reg11_out), .reg12(reg12_out), .reg13(reg13_out), .reg14(reg14_out), .reg15(reg15_out), .reg16(reg16_out), .reg17(reg17_out), .reg18(reg18_out), .reg19(reg19_out), .reg20(reg20_out), .reg21(reg21_out), 
	.reg22(reg22_out), .reg23(reg23_out), .reg24(reg24_out), .reg25(reg25_out), .reg26(reg26_out), .reg27(reg27_out), .reg28(reg28_out), .reg29(reg29_out), .reg30(reg30_out), .reg31(reg31_out),
	.S(S), .out(out)
);

endmodule
