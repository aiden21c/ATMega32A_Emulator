// This document is an instruction decoder for the AVR instruction set
// It will decode a reduced set of the OP codes into the instruction and its arguments 

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
		else begin 
			id = 8'b0;
			arg1 = 8'b0;
			arg2 = 8'b0;
		end
	end 
	else if (n3 == 4'b1001 && n2[3:1] == 3'b101 && n0[3:1] == 3'b111) begin // CALL
	 	// Handle 2nd part of K
		id = 8'h8;
		arg1 = {2'b00, n2[0], n1, n0[3]};
		arg2 = 8'b0;
	end
	else if (instruction == 16'b1001010011111000) begin // CLI 
		id = 8'ha;
		arg1 = 8'b0;
		arg2 = 8'b0;
	end	
	// CLR skipped at 0x0B 
	else if (n3 == 4'b0001 && n2[3:2] == 2'b01) begin // CP
		id = 8'hC;
		arg1 = {3'b000, n2[0], n1};	// Rd
		arg2 = {3'b000, n2[1], n0};	// Rr
	end
	else if (n3 == 4'b0011) begin	// CPI 
		id = 8'hD;
		arg1 = {4'b0000, n1};	// Rd
		arg2 = {n2, n0}; // K
	end
	else if (n3 == 0001 && n2[3:0] == 00) begin // CPSE
		id = 8'hE;
		arg1 = {3'b000, n2[0], n1};	// Rd
		arg2 = {3'b000, n2[1], n0};	// Rr
	end
	else if (n3 == 4'b1001 && n2[3:1] == 3'b010 && n0 == 4'b1010) begin // DEC
		id = 8'hF;
		arg1 = {3'b000, n2[0], n1};	// Rd
		arg2 = 8'b1; // set to 1 to send to ALU for -1 
	end 
	else if (n3 == 4'b0010 && n2[3:2] == 2'b01) begin //EOR
		id = 8'h10;
		arg1 = {3'b000, n2[0], n1};	// Rd
		arg2 = {3'b000, n2[1], n0};	// Rr
	end 
	else if (n3 == 4'b1011 && n2[3] == 1'b0) begin //IN
		id = 8'h11;
		arg1 = {3'b000, n2[0], n1};	// Rd
		arg2 = {n2[2:1], n0}; // A
	end
	else if (n3 == 4'b1001 && n2[3:1] == 3'b010 && n0 == 4'b0011) begin // INC
		id = 8'h12;
		arg1 = {3'b000, n2[0], n1};	// Rd
		arg2 = 8'b1; // set to 1 to send to ALU for +1 
	end 
	else if (n3 == 4'b1001 && n2[3:1] == 3'b010 && n0[3:1] == 3'b110) begin // JMP
		// handle 32 bit part 2 
		id = 8'h13;
		arg1 = {2'b00, n2[0], n1, n0[0]};	// Rd
		arg2 = 8'b0; 
	end 
	// Skip LD (X) is 0x14 to 0x17
	// Skip 0x18 for replica instruction 
	else if (n3 == 4'b1000 && n2[3:1] == 3'b000 && n0 == 4'b1000) begin // LD(Y)
		id = 8'h19;
		arg1 = {3'b000, n2[0], n1};	// Rd
		arg2 = 8'b0;
	end
	else if (n3 == 4'b1001 && n2[3:1] == 3'b000 && n0 == 4'b1001) begin // LD(Y+)
		id = 8'h1a;
		arg1 = {3'b000, n2[0], n1};	// Rd
		arg2 = 8'b1; // set to 1 to send to ALU for +1
	end
	else if (n3 == 4'b1001 && n2[3:1] == 000 && n0 == 4'b1001) begin // LD(-Y)
		id = 8'h1b;
		arg1 = {3'b000, n2[0], n1};	// Rd
		arg2 = 8'b1; // set to 1 to send to ALU for -1
	end
	// skip 0x1C to 0x1F for LD Z
	else if (n3 == 4'b1110) begin // LDI
		id = 8'h20;
		arg1 = {4'b0000, n1};	// Rd
		arg2 = {n2, n0}; // K
	end
	else if (n3 == 4'b1001 && n2[3:1] == 3'b000 && n0 == 4'b0000) begin // LDS 
		id = 8'h21;
		arg1 = {3'b000, n2[0], n1};	// Rd
		arg2 = 8'b0;
	end 
	else if (n3 == 4'b1001 && n2[3:1] == 3'b000 && n0 == 4'b0100) begin // LPM
		id = 8'h22;
		arg1 = {3'b000, n2[0], n1};	// Rd
		arg2 = 8'b0;
	end
	// LSL skipped at 0x23 (Uses add with itself)
	else if (n3 == 4'b1001 && n2[3:1] == 3'b010 && n0 == 4'b0110) begin // LSR
		id = 8'h24;
		arg1 = {3'b000, n2[0], n1};	// Rd
		arg2 = 8'b0;
	end
	else if (n3 == 4'b0010 && n2[3:2] == 2'b11) begin // MOV
		id = 8'h25;
		arg1 = {3'b000, n2[0], n1};	// Rd
		arg2 = {3'b000, n2[1], n0};	// Rr
	end
	else if (n3 == 4'b1001 && n2[3:0] == 2'b11) begin // MUL
		id = 8'h26;
		arg1 = {3'b000, n2[0], n1};	// Rd
		arg2 = {3'b000, n2[1], n0};	// Rr
	end
	else if (n3 == 4'b0010 && n2[3:2] == 2'b10) begin // OR
		id = 8'h27;
		arg1 = {3'b000, n2[0], n1};	// Rd
		arg2 = {3'b000, n2[1], n0};	// Rr
	end
	else if (n3 == 4'b0110) begin // ORI
		id = 8'h28;
		arg1 = {4'b0000, n1};	// Rd
		arg2 = {n2, n0}; // K
	end 
	else if (n3 == 4'b1011 && n2[3] == 1'b1) begin // OUT
		id = 8'h29;
		arg1 = {3'b000, n2[0], n1}; // Rd
		arg2 = {2'b00, n2[2:1], n0};	// A
	end
	else if (n3 == 4'b1001 && n2[3:1] == 3'b000 && n0 == 4'b1111) begin // POP
		id = 8'h2a;
		arg1 = {3'b000, n2[0], n1};	// Rd
		arg2 = 8'b0;
	end
	else if (n3 == 4'b1001 && n2[3:1] == 3'b001 && n0 == 4'b1111) begin // PUSH
		id = 8'h2b;
		arg1 = {3'b000, n2[0], n1};	// Rd
		arg2 = 8'b0;
	end
	else if (n3 == 4'b1101) begin // RCALL
		id = 8'h2c;
		arg1 = {n1, n0};	// K low 8 bits
		arg2 = {4'b0, n2}; // K high 4 bits
	end
	else if (instruction == 16'b1001010100001000) begin // RET
		id = 8'h2d;
		arg1 = 8'b0;
		arg2 = 8'b0;
	end
	else if (instruction == 16'b001010100011000) begin // RETI
		id = 8'h2e;
		arg1 = 8'b0;
		arg2 = 8'b0;
	end
	else if (n3 == 4'b1100) begin // RJMP
		id = 8'h2f;
		arg1 = {n1, n0};	// K low 8 bits
		arg2 = {4'b0, n2}; // K high 4 bits
	end
	// ROL skipped at 0x30 (Uses ADC with itself)
	else if (n3 == 4'b1001 && n2[3:1] == 3'b010 && n0 == 4'b0111) begin // ROR
		id = 8'h31;
		arg1 = {3'b000, n2[0], n1};	// Rd
		arg2 = 8'b0;
	end
	else if (instruction == 16'b1001010001111000) begin // SEI
		id = 8'h32;
		arg1 = 8'b0;
		arg2 = 8'b0;
	end // skip 0x33 to 0x36 for st(x) 		skip 0x37 for replica 
	else if (n3 == 4'b1000 && n2[3:1] == 3'b001 && n0 == 4'b1000) begin // ST(Y)
		id = 8'h38;
		arg1 = {3'b000, n2[0], n1};	// Rr
		arg2 = 8'b0; 
	end
	else if (n3 == 4'b1001 && n2[3:1] == 3'b001 && n0 == 4'b1001) begin // ST(Y+)
		id = 8'h39;
		arg1 = {3'b000, n2[0], n1};	// Rr
		arg2 = 8'b0;
	end
	else if (n3 == 4'b1001 && n2[3:1] == 3'b001 && n0 == 4'b1010) begin // ST(-Y)
		id = 8'h3a;
		arg1 = {3'b000, n2[0], n1};	// Rr
		arg2 = 8'b0;
	end 
	// skip 0x3b to 0x3e for st(Z)
	else if (n3 == 4'b1001 && n2[3:1] == 3'b001 && n0 == 4'b0000) begin // STS
		id = 8'h3f;
		arg1 = {3'b000, n2[0], n1};	// Rd
		arg2 = 8'b0;
	end
	else if (n3 == 4'b0001 && n2[3:2] == 2'b10) begin // SUB
		id = 8'h40;
		arg1 = {3'b000, n2[0], n1};	// Rd
		arg2 = {3'b000, n2[1], n0};	// Rr
	end
	else if (n3 == 4'b0101) begin // SUBI
		id = 8'h41;
		arg1 = {4'b0000, n1};	// Rd
		arg2 = {n2, n0}; // K
	end
	else begin 
		id = 8'b0;
		arg1 = 8'b0;
		arg2 = 8'b0;
	end
end

assign instruction_id = id;
assign argument_1 = arg1;
assign argument_2 = arg2;

endmodule
