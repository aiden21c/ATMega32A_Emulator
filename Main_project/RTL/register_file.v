// A module representing the register file of the ATMega32A. 
// This module allows for the simultaneous reading of two registers and the writing of one register (clocked I/O)
module register_file(
	input clock,						// Clock input
	input clr_n,
	input [4:0] RA1,					// Read register 1
	input [4:0] RA2,					// Read register 2
	input [4:0] WA,					// Write register
	input RegWrite,					// Write enable signal
	input [7:0] WD,					// Write data
	
	output [7:0] RD1,					// Output data read from RA1
	output [7:0] RD2,					// Output data read from RA2
	output [255:0]all_registers
);

// Wires connecting the selector to the registers
wire reg0_sel; wire reg1_sel; wire reg2_sel;
wire reg3_sel; wire reg4_sel; wire reg5_sel;
wire reg6_sel; wire reg7_sel; wire reg8_sel;
wire reg9_sel; wire reg10_sel; wire reg11_sel;
wire reg12_sel; wire reg13_sel; wire reg14_sel;
wire reg15_sel; wire reg16_sel; wire reg17_sel;
wire reg18_sel; wire reg19_sel; wire reg20_sel;
wire reg21_sel; wire reg22_sel; wire reg23_sel;
wire reg24_sel; wire reg25_sel; wire reg26_sel;
wire reg27_sel; wire reg28_sel; wire reg29_sel;
wire reg30_sel; wire reg31_sel;


// Selector used to select the register to write to
selector_32way selector(
	.S(WA),	
	.out0(reg0_sel), .out1(reg1_sel), .out2(reg2_sel), .out3(reg3_sel), 
	.out4(reg4_sel), .out5(reg5_sel), .out6(reg6_sel), .out7(reg7_sel), 
	.out8(reg8_sel), .out9(reg9_sel), .out10(reg10_sel), .out11(reg11_sel), 
	.out12(reg12_sel), .out13(reg13_sel), .out14(reg14_sel), .out15(reg15_sel), 
	.out16(reg16_sel), .out17(reg17_sel), .out18(reg18_sel), .out19(reg19_sel), 
	.out20(reg20_sel), .out21(reg21_sel), .out22(reg22_sel), .out23(reg23_sel), 
	.out24(reg24_sel), .out25(reg25_sel), .out26(reg26_sel), .out27(reg27_sel), 
	.out28(reg28_sel), .out29(reg29_sel), .out30(reg30_sel), .out31(reg31_sel) 
);

// Wires connecting the Mux to the d-type flip-flops
wire [7:0] reg0_in; wire [7:0] reg1_in; wire [7:0] reg2_in; wire [7:0] reg3_in; 
wire [7:0] reg4_in; wire [7:0] reg5_in; wire [7:0] reg6_in; wire [7:0] reg7_in; 
wire [7:0] reg8_in; wire [7:0] reg9_in; wire [7:0] reg10_in; wire [7:0] reg31_in;
wire [7:0] reg11_in; wire [7:0] reg12_in; wire [7:0] reg13_in; wire [7:0] reg14_in;
wire [7:0] reg15_in; wire [7:0] reg16_in; wire [7:0] reg17_in;wire [7:0] reg18_in;
wire [7:0] reg19_in; wire [7:0] reg20_in; wire [7:0] reg21_in; wire [7:0] reg22_in;
wire [7:0] reg23_in; wire [7:0] reg24_in; wire [7:0] reg25_in; wire [7:0] reg26_in;
wire [7:0] reg27_in; wire [7:0] reg28_in; wire [7:0] reg29_in; wire [7:0] reg30_in;

// Wires connecting the input to the outputs
wire [7:0] reg0_out; wire [7:0] reg1_out; wire [7:0] reg2_out; wire [7:0] reg3_out;
wire [7:0] reg4_out; wire [7:0] reg5_out; wire [7:0] reg6_out; wire [7:0] reg7_out;
wire [7:0] reg8_out; wire [7:0] reg9_out; wire [7:0] reg10_out; wire [7:0] reg11_out;
wire [7:0] reg12_out; wire [7:0] reg13_out; wire [7:0] reg14_out; wire [7:0] reg15_out;
wire [7:0] reg16_out; wire [7:0] reg17_out; wire [7:0] reg18_out; wire [7:0] reg19_out;
wire [7:0] reg20_out; wire [7:0] reg21_out; wire [7:0] reg22_out; wire [7:0] reg23_out;
wire [7:0] reg24_out; wire [7:0] reg25_out; wire [7:0] reg26_out; wire [7:0] reg27_out;
wire [7:0] reg28_out; wire [7:0] reg29_out; wire [7:0] reg30_out; wire [7:0] reg31_out;


// Multiplexers to select whether to write the data to the register or keep the current register data
multi_bit_multiplexer_2way #(8) reg0_in_Mux (.A(reg0_out), .B(WD), .S(RegWrite & reg0_sel), .out(reg0_in));
multi_bit_multiplexer_2way #(8) reg1_in_Mux (.A(reg1_out), .B(WD), .S(RegWrite & reg1_sel), .out(reg1_in));
multi_bit_multiplexer_2way #(8) reg2_in_Mux (.A(reg2_out), .B(WD), .S(RegWrite & reg2_sel), .out(reg2_in));
multi_bit_multiplexer_2way #(8) reg3_in_Mux (.A(reg3_out), .B(WD), .S(RegWrite & reg3_sel), .out(reg3_in));
multi_bit_multiplexer_2way #(8) reg4_in_Mux (.A(reg4_out), .B(WD), .S(RegWrite & reg4_sel), .out(reg4_in));
multi_bit_multiplexer_2way #(8) reg5_in_Mux (.A(reg5_out), .B(WD), .S(RegWrite & reg5_sel), .out(reg5_in));
multi_bit_multiplexer_2way #(8) reg6_in_Mux (.A(reg6_out), .B(WD), .S(RegWrite & reg6_sel), .out(reg6_in));
multi_bit_multiplexer_2way #(8) reg7_in_Mux (.A(reg7_out), .B(WD), .S(RegWrite & reg7_sel), .out(reg7_in));
multi_bit_multiplexer_2way #(8) reg8_in_Mux (.A(reg8_out), .B(WD), .S(RegWrite & reg8_sel), .out(reg8_in));
multi_bit_multiplexer_2way #(8) reg9_in_Mux (.A(reg9_out), .B(WD), .S(RegWrite & reg9_sel), .out(reg9_in));
multi_bit_multiplexer_2way #(8) reg10_in_Mux (.A(reg10_out), .B(WD), .S(RegWrite & reg10_sel), .out(reg10_in));
multi_bit_multiplexer_2way #(8) reg11_in_Mux (.A(reg11_out), .B(WD), .S(RegWrite & reg11_sel), .out(reg11_in));
multi_bit_multiplexer_2way #(8) reg12_in_Mux (.A(reg12_out), .B(WD), .S(RegWrite & reg12_sel), .out(reg12_in));
multi_bit_multiplexer_2way #(8) reg13_in_Mux (.A(reg13_out), .B(WD), .S(RegWrite & reg13_sel), .out(reg13_in));
multi_bit_multiplexer_2way #(8) reg14_in_Mux (.A(reg14_out), .B(WD), .S(RegWrite & reg14_sel), .out(reg14_in));
multi_bit_multiplexer_2way #(8) reg15_in_Mux (.A(reg15_out), .B(WD), .S(RegWrite & reg15_sel), .out(reg15_in));
multi_bit_multiplexer_2way #(8) reg16_in_Mux (.A(reg16_out), .B(WD), .S(RegWrite & reg16_sel), .out(reg16_in));
multi_bit_multiplexer_2way #(8) reg17_in_Mux (.A(reg17_out), .B(WD), .S(RegWrite & reg17_sel), .out(reg17_in));
multi_bit_multiplexer_2way #(8) reg18_in_Mux (.A(reg18_out), .B(WD), .S(RegWrite & reg18_sel), .out(reg18_in));
multi_bit_multiplexer_2way #(8) reg19_in_Mux (.A(reg19_out), .B(WD), .S(RegWrite & reg19_sel), .out(reg19_in));
multi_bit_multiplexer_2way #(8) reg20_in_Mux (.A(reg20_out), .B(WD), .S(RegWrite & reg20_sel), .out(reg20_in));
multi_bit_multiplexer_2way #(8) reg21_in_Mux (.A(reg21_out), .B(WD), .S(RegWrite & reg21_sel), .out(reg21_in));
multi_bit_multiplexer_2way #(8) reg22_in_Mux (.A(reg22_out), .B(WD), .S(RegWrite & reg22_sel), .out(reg22_in));
multi_bit_multiplexer_2way #(8) reg23_in_Mux (.A(reg23_out), .B(WD), .S(RegWrite & reg23_sel), .out(reg23_in));
multi_bit_multiplexer_2way #(8) reg24_in_Mux (.A(reg24_out), .B(WD), .S(RegWrite & reg24_sel), .out(reg24_in));
multi_bit_multiplexer_2way #(8) reg25_in_Mux (.A(reg25_out), .B(WD), .S(RegWrite & reg25_sel), .out(reg25_in));
multi_bit_multiplexer_2way #(8) reg26_in_Mux (.A(reg26_out), .B(WD), .S(RegWrite & reg26_sel), .out(reg26_in));
multi_bit_multiplexer_2way #(8) reg27_in_Mux (.A(reg27_out), .B(WD), .S(RegWrite & reg27_sel), .out(reg27_in));
multi_bit_multiplexer_2way #(8) reg28_in_Mux (.A(reg28_out), .B(WD), .S(RegWrite & reg28_sel), .out(reg28_in));
multi_bit_multiplexer_2way #(8) reg29_in_Mux (.A(reg29_out), .B(WD), .S(RegWrite & reg29_sel), .out(reg29_in));
multi_bit_multiplexer_2way #(8) reg30_in_Mux (.A(reg30_out), .B(WD), .S(RegWrite & reg30_sel), .out(reg30_in));
multi_bit_multiplexer_2way #(8) reg31_in_Mux (.A(reg31_out), .B(WD), .S(RegWrite & reg31_sel), .out(reg31_in));

// D-type flip flops used for the registers themselves
d_flip_flop_multi_bit #(8,0) register0 (.d(reg0_in), .clk(clock), .clr_n(clr_n), .Q(reg0_out), .Qn());
d_flip_flop_multi_bit #(8,0) register1 (.d(reg1_in), .clk(clock), .clr_n(clr_n), .Q(reg1_out), .Qn());
d_flip_flop_multi_bit #(8,0) register2 (.d(reg2_in), .clk(clock), .clr_n(clr_n), .Q(reg2_out), .Qn());
d_flip_flop_multi_bit #(8,0) register3 (.d(reg3_in), .clk(clock), .clr_n(clr_n), .Q(reg3_out), .Qn());
d_flip_flop_multi_bit #(8,0) register4 (.d(reg4_in), .clk(clock), .clr_n(clr_n), .Q(reg4_out), .Qn());
d_flip_flop_multi_bit #(8,0) register5 (.d(reg5_in), .clk(clock), .clr_n(clr_n), .Q(reg5_out), .Qn());
d_flip_flop_multi_bit #(8,0) register6 (.d(reg6_in), .clk(clock), .clr_n(clr_n), .Q(reg6_out), .Qn());
d_flip_flop_multi_bit #(8,0) register7 (.d(reg7_in), .clk(clock), .clr_n(clr_n), .Q(reg7_out), .Qn());
d_flip_flop_multi_bit #(8,0) register8 (.d(reg8_in), .clk(clock), .clr_n(clr_n), .Q(reg8_out), .Qn());
d_flip_flop_multi_bit #(8,0) register9 (.d(reg9_in), .clk(clock), .clr_n(clr_n), .Q(reg9_out), .Qn());
d_flip_flop_multi_bit #(8,0) register10 (.d(reg10_in), .clk(clock), .clr_n(clr_n), .Q(reg10_out), .Qn());
d_flip_flop_multi_bit #(8,0) register11 (.d(reg11_in), .clk(clock), .clr_n(clr_n), .Q(reg11_out), .Qn());
d_flip_flop_multi_bit #(8,0) register12 (.d(reg12_in), .clk(clock), .clr_n(clr_n), .Q(reg12_out), .Qn());
d_flip_flop_multi_bit #(8,0) register13 (.d(reg13_in), .clk(clock), .clr_n(clr_n), .Q(reg13_out), .Qn());
d_flip_flop_multi_bit #(8,0) register14 (.d(reg14_in), .clk(clock), .clr_n(clr_n), .Q(reg14_out), .Qn());
d_flip_flop_multi_bit #(8,0) register15 (.d(reg15_in), .clk(clock), .clr_n(clr_n), .Q(reg15_out), .Qn());
d_flip_flop_multi_bit #(8,0) register16 (.d(reg16_in), .clk(clock), .clr_n(clr_n), .Q(reg16_out), .Qn());
d_flip_flop_multi_bit #(8,0) register17 (.d(reg17_in), .clk(clock), .clr_n(clr_n), .Q(reg17_out), .Qn());
d_flip_flop_multi_bit #(8,0) register18 (.d(reg18_in), .clk(clock), .clr_n(clr_n), .Q(reg18_out), .Qn());
d_flip_flop_multi_bit #(8,0) register19 (.d(reg19_in), .clk(clock), .clr_n(clr_n), .Q(reg19_out), .Qn());
d_flip_flop_multi_bit #(8,0) register20 (.d(reg20_in), .clk(clock), .clr_n(clr_n), .Q(reg20_out), .Qn());
d_flip_flop_multi_bit #(8,0) register21 (.d(reg21_in), .clk(clock), .clr_n(clr_n), .Q(reg21_out), .Qn());
d_flip_flop_multi_bit #(8,0) register22 (.d(reg22_in), .clk(clock), .clr_n(clr_n), .Q(reg22_out), .Qn());
d_flip_flop_multi_bit #(8,0) register23 (.d(reg23_in), .clk(clock), .clr_n(clr_n), .Q(reg23_out), .Qn());
d_flip_flop_multi_bit #(8,0) register24 (.d(reg24_in), .clk(clock), .clr_n(clr_n), .Q(reg24_out), .Qn());
d_flip_flop_multi_bit #(8,0) register25 (.d(reg25_in), .clk(clock), .clr_n(clr_n), .Q(reg25_out), .Qn());
d_flip_flop_multi_bit #(8,0) register26 (.d(reg26_in), .clk(clock), .clr_n(clr_n), .Q(reg26_out), .Qn());
d_flip_flop_multi_bit #(8,0) register27 (.d(reg27_in), .clk(clock), .clr_n(clr_n), .Q(reg27_out), .Qn());
d_flip_flop_multi_bit #(8,0) register28 (.d(reg28_in), .clk(clock), .clr_n(clr_n), .Q(reg28_out), .Qn());
d_flip_flop_multi_bit #(8,0) register29 (.d(reg29_in), .clk(clock), .clr_n(clr_n), .Q(reg29_out), .Qn());
d_flip_flop_multi_bit #(8,0) register30 (.d(reg30_in), .clk(clock), .clr_n(clr_n), .Q(reg30_out), .Qn());
d_flip_flop_multi_bit #(8,0) register31 (.d(reg31_in), .clk(clock), .clr_n(clr_n), .Q(reg31_out), .Qn());

// Multiplexers used to select the relevant read addresses for the outputs
wire [7:0] outputData1; wire [7:0] outputData2;
multi_bit_multiplexer_32way #(8) RD1_mux(
	.reg0(reg0_out), .reg1(reg1_out), .reg2(reg2_out), .reg3(reg3_out), .reg4(reg4_out), .reg5(reg5_out), .reg6(reg6_out), .reg7(reg7_out), .reg8(reg8_out), .reg9(reg9_out), .reg10(reg10_out), 
	.reg11(reg11_out), .reg12(reg12_out), .reg13(reg13_out), .reg14(reg14_out), .reg15(reg15_out), .reg16(reg16_out), .reg17(reg17_out), .reg18(reg18_out), .reg19(reg19_out), .reg20(reg20_out), .reg21(reg21_out), 
	.reg22(reg22_out), .reg23(reg23_out), .reg24(reg24_out), .reg25(reg25_out), .reg26(reg26_out), .reg27(reg27_out), .reg28(reg28_out), .reg29(reg29_out), .reg30(reg30_out), .reg31(reg31_out),
	.S(RA1), .out(outputData1)
);

multi_bit_multiplexer_32way #(8) RD2_mux(
	.reg0(reg0_out), .reg1(reg1_out), .reg2(reg2_out), .reg3(reg3_out), .reg4(reg4_out), .reg5(reg5_out), .reg6(reg6_out), .reg7(reg7_out), .reg8(reg8_out), .reg9(reg9_out), .reg10(reg10_out), 
	.reg11(reg11_out), .reg12(reg12_out), .reg13(reg13_out), .reg14(reg14_out), .reg15(reg15_out), .reg16(reg16_out), .reg17(reg17_out), .reg18(reg18_out), .reg19(reg19_out), .reg20(reg20_out), .reg21(reg21_out), 
	.reg22(reg22_out), .reg23(reg23_out), .reg24(reg24_out), .reg25(reg25_out), .reg26(reg26_out), .reg27(reg27_out), .reg28(reg28_out), .reg29(reg29_out), .reg30(reg30_out), .reg31(reg31_out),
	.S(RA2), .out(outputData2)
);

// Output D-type flip flops
d_flip_flop_multi_bit #(8,0) RD1_out (.d(outputData1), .clk(clock), .clr_n(clr_n), .Q(RD1), .Qn());
d_flip_flop_multi_bit #(8,0) RD2_out (.d(outputData2), .clk(clock), .clr_n(clr_n), .Q(RD2), .Qn());

// Assign the output memory bus
assign all_registers = {
	reg31_out,
	reg30_out,
	reg29_out,
	reg28_out,
	reg27_out,
	reg26_out,
	reg25_out,
	reg24_out,
	reg23_out,
	reg22_out,
	reg21_out,
	reg20_out,
	reg19_out,
	reg18_out,
	reg17_out,
	reg16_out,
	reg15_out,
	reg14_out,
	reg13_out,
	reg12_out,
	reg11_out,
	reg10_out,
	reg9_out,
	reg8_out,
	reg7_out,
	reg6_out,
	reg5_out,
	reg4_out,
	reg3_out,
	reg2_out,
	reg1_out,
	reg0_out
};
	
endmodule
