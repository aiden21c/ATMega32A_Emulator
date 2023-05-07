// Full Adder Circuit
// Author: Dr Glenn Matthews

module fullAdder(
	// Declare the inputs and outputs
	input A, B, Cin,
	output Sum, Cout
);

// Asynchronous outputs
assign Sum = (A ^ B) ^ Cin;
assign Cout = (A & B) | ((A ^ B) & Cin);

endmodule
