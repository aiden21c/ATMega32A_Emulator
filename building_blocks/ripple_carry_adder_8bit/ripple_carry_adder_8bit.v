// Ripple Carry Adder/Subtractor
//		Adapted from the 4 bit design in the lecture notes to support 8 bit operations
// Author: Dr Glenn Matthews
module ripple_carry_adder_8bit(
	input [7:0] A,			// 8-bit input A
	input [7:0] B,			// 8-bit input B
	input Add_n_Sub,		// Add (0) or subtract (1)
	output [7:0] S,		//	8-bit addition/subtraction output
	output Cout				//	Carry/Borrow out
);

// Wires to link between the carry out of each of the full Adders to the input of the next stage
wire cout0; wire cout1; wire cout2; wire cout3; wire cout4; wire cout5; wire cout6;

// Create 8 instances of the 1-bit full adder
fullAdder adder0(.A(A[0]), .B(B[0]), .Add_n_Sub(Add_n_Sub), .Cin(Add_n_Sub), .Sum(S[0]), .Cout(cout0));
fullAdder adder1(.A(A[1]), .B(B[1]), .Add_n_Sub(Add_n_Sub), .Cin(cout0), .Sum(S[1]), .Cout(cout1));
fullAdder adder2(.A(A[2]), .B(B[2]), .Add_n_Sub(Add_n_Sub), .Cin(cout1), .Sum(S[2]), .Cout(cout2));
fullAdder adder3(.A(A[3]), .B(B[3]), .Add_n_Sub(Add_n_Sub), .Cin(cout2), .Sum(S[3]), .Cout(cout3));
fullAdder adder4(.A(A[4]), .B(B[4]), .Add_n_Sub(Add_n_Sub), .Cin(cout3), .Sum(S[4]), .Cout(cout4));
fullAdder adder5(.A(A[5]), .B(B[5]), .Add_n_Sub(Add_n_Sub), .Cin(cout4), .Sum(S[5]), .Cout(cout5));
fullAdder adder6(.A(A[6]), .B(B[6]), .Add_n_Sub(Add_n_Sub), .Cin(cout5), .Sum(S[6]), .Cout(cout6));
fullAdder adder7(.A(A[7]), .B(B[7]), .Add_n_Sub(Add_n_Sub), .Cin(cout6), .Sum(S[7]), .Cout(Cout));

endmodule
