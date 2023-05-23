
module instruction_decoder (
	input [15:0] instruction,
	input part2,
	
	output [7:0] instruction_id,	// 0x00 - 0x41 or 0xff if the read is an address for 32 bit instruction
	output [7:0] argument_1,
	output [7:0] argument_2
);

wire [3:0] n3 = instruction[15:12];
wire [3:0] n2 = instruction[11:8];
wire [3:0] n1 = instruction[7:4];
wire [3:0] n0 = instruction[3:0];

reg [7:0] id;
reg [7:0] arg1;
reg [7:0] arg2;	

always @(*) begin 
	if (part2 == 1'b1) begin 
		id = 8'hff;
		arg1 = instruction[7:0]; // low byte 
		arg2 = instruction[15:8]; // high byte
	end 
	else if (instruction == 16'b0) begin //NOP
		id = 8'b0;
		arg1 = 8'b0;
		arg2 = 8'b0;	
	end 
	else if (n3 == 4'b0001 && n2[3:2] == 2'b11) begin // ADC
		id = 8'h1;
		arg1 = {3'b000, n2[0], n1};	// Rd
		arg2 = {3'b000, n2[1], n0};	// Rr 
	end
	else if (n3 == 4'b0000 && n2[3:2] == 2'b11) begin // ADD
		id = 8'h2;
		arg1 = {3'b000, n2[0], n1};	// Rd
		arg2 = {3'b000, n2[1], n0};	// Rr 
	end 
	else if (n3 == 4'b0010 && n2[3:2] == 2'b00) begin // AND 
		id = 8'h3;
		arg1 = {3'b000, n2[0], n1};	// Rd
		arg2 = {3'b000, n2[1], n0};	// Rr
	end
	else if (n3 == 4'b1111) begin // branch instructions 
		if (n2[3:2] == 2'b01 && n0[2:0] == 3'b000) begin // BRCC
			id = 8'h4;
			arg1 = {1'b0, n2[1:0], n1, n0[3]};
			arg2 = 8'b0;
		end 
		else if (n2[3:2] == 2'b00 && n0[2:0] == 3'b000) begin // BRCS / BRLO
			id = 8'h5;
			arg1 = {1'b0, n2[1:0], n1, n0[3]};
			arg2 = 8'b0;
		end 
		else if (n2[3:2] == 2'b00 && n0[2:0] == 3'b001) begin // BREQ
			id = 8'h6;
			arg1 = {1'b0, n2[1:0], n1, n0[3]};
			arg2 = 8'b0;
		end
		// BRLO with id 7 (Duplicate of BRCS)
		else if (n2[3:0] == 2'b01 && n0[2:0] == 3'b001) begin // BRNE
			id = 8'h8;
			arg1 = {1'b0, n2[1:0], n1, n0[3]};
			arg2 = 8'b0;
		end 
	end 
	else if (n3 == 4'b1001 && n2[3:1] == 3'b101 && n0[3:1] == 3'b111) begin // CALL
	 	// Handle 2nd part of K
		id = 8'h8;
		arg1 = {2'b00, n2[0], n1, n0[3]};
		arg2 = 8'b0;
	end 
end

assign instruction_id = id;
assign argument_1 = arg1;
assign argument_2 = arg2;

endmodule
