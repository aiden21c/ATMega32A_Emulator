// Full Adder Circuit
// Author: Dr Glenn Matthews

module fullAdder(
	// Declare the inputs and outputs
	input A, B, Cin, 
	input Add_n_Sub,	// Add (0) subtract (1)
	output Sum, Cout
);

// Asynchronous outputs
assign Sum = (A ^ (B ^ Add_n_Sub)) ^ Cin;
assign Cout = (A & (B ^ Add_n_Sub)) | ((A ^ (B ^ Add_n_Sub)) & Cin);

endmodule
