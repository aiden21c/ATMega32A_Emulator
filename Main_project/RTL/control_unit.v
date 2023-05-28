module control_unit (
    input clk,
    input reset_n,

    input [7:0] instruction_id,
    input [7:0] status_register,
    input OC_flag,

    output instruction_decoder_part2,

    output [2:0] ALU_SEL,
    output PC_INC,
    output IREG_HOLD,
    output PC_OVERWRITE,
    output GP_REG_WRITE,
    output USE_CARRY,
    output STATUS_REG_SEL,
    output IO_ONLY_FLAG,
    output MEMORY_WRITE_EN,
    output SP_WRITE_ENABLE,

    output [1:0] CLOCK_COUNTER,
    output [1:0] INTERRUPT_STAGE
);

reg [1:0] clock_counter;

parameter I = 3'b111; parameter T = 3'b110; parameter H = 3'b101; parameter S = 3'b100;
parameter V = 3'b011; parameter N = 3'b010; parameter Z = 3'b001; parameter C = 3'b000;

reg [2:0] alu_sel;
reg pc_inc;
reg ireg_hold;
reg pc_overwrite;
reg gp_reg_write;
reg use_carry;
reg status_reg_sel;
reg io_only_flag;
reg memory_write_en;
reg sp_write_enable;

reg [1:0] interrupt_stage; 

always @(posedge(clk), negedge(reset_n))
begin
	if(!reset_n)
    // 0	0	0	0	000	0	0	0	0
	begin
        clock_counter <= 2'b00;

        interrupt_stage <= 2'b00;
	end
    else if (interrupt_stage > 2'h0) begin 
        // Handle interrupt 
        // Save PC
        // Update PC
        if (interrupt_stage == 2'h1) 
        begin 

            clock_counter <= 2'b00;

            interrupt_stage <= 2'b10;
        end
        else if (interrupt_stage == 2'h2) 
        begin 

            clock_counter <= 2'b00;

            interrupt_stage <= 2'b11;
        end
        else if (interrupt_stage == 2'h3) 
        begin

            clock_counter <= 2'b00;

            interrupt_stage <= 2'b00;
        end
        else
        begin
            clock_counter <= 2'b00;

            interrupt_stage <= 2'b00;  
        end
    end 
    else if ((OC_flag == 1'b1) && (status_register[I] == 2'b00) && (clock_counter == 2'b00)) 
    begin // handle interrupt
        interrupt_stage <= 2'b01; //set stage to 1 
        // clear I bit 
        clock_counter <= 2'b00;
    end 
    else if(instruction_id == 8'b00000000)			// NOP
    // 0	0	0	0	000	0	0	0	0
	begin
        clock_counter <= 2'b00;
        interrupt_stage <= 2'b00;
	end

	else if(instruction_id == 8'b00000001)			// ADC (1 cycle)
    // 1	0	0	1	000	1	0	0	0
	begin
        
        clock_counter <= 2'b00;
        interrupt_stage <= 2'b00;
	end

	else if(instruction_id == 8'b00000010)			// ADD (1 cycle)
    // 1	0	0	1	000	0	0	0	0
	begin
        
        clock_counter <= 2'b00;
        interrupt_stage <= 2'b00;
	end

	else if(instruction_id == 8'b00000011)			// AND (1 cycle)
    // 1	0	0	1	101	0	0	0	0
	begin
        
        clock_counter <= 2'b00;
        interrupt_stage <= 2'b00;
	end

	else if(instruction_id == 8'b00000100)			// BRCC (2 cycles)
	begin
		if(clock_counter == 2'b00)
        // 1	0	!C	0	000	0	0	0	0
        begin
            
            clock_counter <= 2'b00;
            interrupt_stage <= 2'b00;
        end

        else if (clock_counter == 2'b01)
        // 0	0	0	0	000	0	0	0	0
        begin
        
            clock_counter <= 2'b00;
            interrupt_stage <= 2'b00;
        end

        else
        // 0	0	0	0	000	0	0	0	0
        begin
            
            clock_counter <= 2'b00;
            interrupt_stage <= 2'b00;
        end
	end

	else if(instruction_id == 8'b00000101)			// BRCS (2 cycles)
    begin
		if(clock_counter == 2'b00)
        // 1	0	C	0	000	0	0	0	0
        begin
            interrupt_stage <= 2'b00;
            clock_counter <= 2'b00;
        end

        else if (clock_counter == 2'b01)
        // 0	0	0	0	000	0	0	0	0
        begin
            
            clock_counter <= 2'b00;
            interrupt_stage <= 2'b00;
        end

        else
        // 0	0	0	0	000	0	0	0	0
        begin
            
            clock_counter <= 2'b00;
            interrupt_stage <= 2'b00;
        end
    end

	else if(instruction_id == 8'b00000110)			// BREQ (2 cycles)
	begin
		if(clock_counter == 2'b00)
        // 1	0	Z	0	000	0	0	0	0
        begin
            
            clock_counter <= 2'b00;
            interrupt_stage <= 2'b00;
        end

        else if (clock_counter == 2'b01)
        // 0	0	0	0	000	0	0	0	0
        begin
                        
            clock_counter <= 2'b00;
            interrupt_stage <= 2'b00;            
        end

        else
        // 0	0	0	0	000	0	0	0	0
        begin
                        
            clock_counter <= 2'b00;
            interrupt_stage <= 2'b00;
        end
	end

	else if(instruction_id == 8'b00000111)			// BRLO (2 cycles)
	begin
		if(clock_counter == 2'b00)
        // 0	0	0	0	000	0	0	0	0
        begin
                        
            clock_counter <= 2'b00;
            interrupt_stage <= 2'b00;
        end

        else if (clock_counter == 2'b01)
        // 0	0	0	0	000	0	0	0	0
        begin
                        
            clock_counter <= 2'b00;
            interrupt_stage <= 2'b00;
        end

        else
        // 0	0	0	0	000	0	0	0	0
        begin
                        
            clock_counter <= 2'b00;
            interrupt_stage <= 2'b00;
        end
	end

	else if(instruction_id == 8'b00001000)			// BRNE (2 cycles)
	begin
		if(clock_counter == 2'b00)
        // 1	0	!Z	0	000	0	0	0	0
        begin
                        
            clock_counter <= 2'b00;
            interrupt_stage <= 2'b00;
        end

        else if (clock_counter == 2'b01)
        // 0	0	0	0	000	0	0	0	0
        begin
                        
            clock_counter <= 2'b00;
            interrupt_stage <= 2'b00;
        end

        else
        // 0	0	0	0	000	0	0	0	0
        begin
                        
            clock_counter <= 2'b00;
            interrupt_stage <= 2'b00;
        end
	end

	else if(instruction_id == 8'b00001001)			// CALL (4 cycles)
    // 0	0	0	0	000	0	0	0	0
	begin
        
        clock_counter <= 2'b00;
        interrupt_stage <= 2'b00;
	end

	else if(instruction_id == 8'b00001010)			// CLI (1 cycle)
    // 1	0	0	0	000	0	1	1	1
	begin
                    
        clock_counter <= 2'b00;
        interrupt_stage <= 2'b00;
	end

	else if(instruction_id == 8'b00001011)			// CLR (1 cycle)
    // 0	0	0	0	000	0	0	0	0
    begin
                            
        clock_counter <= 2'b00;
        interrupt_stage <= 2'b00;
	end

	else if(instruction_id == 8'b00001100)			// CP (1 cycle)
    // 1	0	0	0	001	0	0	0	0
	begin
                            
        clock_counter <= 2'b00;
        interrupt_stage <= 2'b00;
	end

	else if(instruction_id == 8'b00001101)			// CPI (1 cycle)
    // 1	0	0	0	001	0	0	0	0
	begin
                            
        clock_counter <= 2'b00;	
        interrupt_stage <= 2'b00;	
	end

	else if(instruction_id == 8'b00001110)			// CPSE (2 cycles)
	begin
        if(clock_counter == 2'b00)
        begin
                                
            clock_counter <= 2'b01;
            interrupt_stage <= 2'b00;
        end
        else if(clock_counter == 2'b01)
        begin
                                
            clock_counter <= 2'b00;
            interrupt_stage <= 2'b00;
        end

        else
        begin
                                
            clock_counter <= 2'b00;
            interrupt_stage <= 2'b00;
        end
	end

	else if(instruction_id == 8'b00001111)			// DEC
    // 1	0	0	1	001	0	0	0	0
	begin
        clock_counter <= 2'b00;
        interrupt_stage <= 2'b00;
	end

	else if(instruction_id == 8'b00010000)			// EOR
    // 1	0	0	1	111	0	0	0	0
	begin
        clock_counter <= 2'b00;
        interrupt_stage <= 2'b00;	
	end

	else if(instruction_id == 8'b00010001)			// IN
    // 1	0	0	1	000	0	1	1	0
	begin
                            
        clock_counter <= 2'b00;		
        interrupt_stage <= 2'b00;	
	end

	else if(instruction_id == 8'b00010010)			// INC
    // 1	0	0	1	000	0	0	0	0
	begin
                            
        clock_counter <= 2'b00;
        interrupt_stage <= 2'b00;
	end

	else if(instruction_id == 8'b00010011)			// JMP (3 cycles)
    // 0	0	0	0	000	0	0	0	0
	begin
        
        clock_counter <= 2'b00;
        interrupt_stage <= 2'b00;
	end

	else if(instruction_id == 8'b00010100)			// LD (X)
    // 0	0	0	0	000	0	0	0	0
	begin
                            
        clock_counter <= 2'b00;
        interrupt_stage <= 2'b00;
	end

	else if(instruction_id == 8'b00010101)			// LD(X) - i
    // 0	0	0	0	000	0	0	0	0
	begin
                            
        clock_counter <= 2'b00;
        interrupt_stage <= 2'b00;
	end

	else if(instruction_id == 8'b00010110)			// LD(X) - ii
    // 0	0	0	0	000	0	0	0	0
	begin
                            
        clock_counter <= 2'b00;
        interrupt_stage <= 2'b00;
	end

	else if(instruction_id == 8'b00010111)			// LD(X) - iii
    // 0	0	0	0	000	0	0	0	0
	begin
                            
        clock_counter <= 2'b00;
        interrupt_stage <= 2'b00;
	end

	else if(instruction_id == 8'b00011000)			// LD (Y) (2 cycles)
    // 0	0	0	0	000	0	0	0	0
	begin
                            
        clock_counter <= 2'b00;
        interrupt_stage <= 2'b00;
	end

	else if(instruction_id == 8'b00011001)			// LD(Y) - i (2 cycles)
	begin
        if(clock_counter == 2'b00)
        begin
                                
            clock_counter <= 2'b01;
            interrupt_stage <= 2'b00;
        end

        else if(clock_counter == 2'b01)
        begin
                                
            clock_counter <= 2'b00;		
            interrupt_stage <= 2'b00;
        end

        else
        begin
                                
            clock_counter <= 2'b00;
            interrupt_stage <= 2'b00;
        end
	end

	else if(instruction_id == 8'b00011010)			// LD(Y) - ii (3 cycles)
    // 0	0	0	0	000	0	0	0	0
	begin
                            
        clock_counter <= 2'b00;
        interrupt_stage <= 2'b00;
	end

	else if(instruction_id == 8'b00011011)			// LD(Y) - iii (3 cycles)
    // 0	0	0	0	000	0	0	0	0
	begin
                            
        clock_counter <= 2'b00;
        interrupt_stage <= 2'b00;
	end

	else if(instruction_id == 8'b00011100)			// LD (Z)
    // 0	0	0	0	000	0	0	0	0
	begin                            
        clock_counter <= 2'b00;
        interrupt_stage <= 2'b00;
	end

	else if(instruction_id == 8'b00011101)			// LD(Z) - i
    // 0	0	0	0	000	0	0	0	0
	begin
                            
        clock_counter <= 2'b00;
        interrupt_stage <= 2'b00;
	end

	else if(instruction_id == 8'b00011110)			// LD(Z) - ii
    // 0	0	0	0	000	0	0	0	0
	begin
                            
        clock_counter <= 2'b00;
        interrupt_stage <= 2'b00;
	end

	else if(instruction_id == 8'b00011111)			// LD(Z) - iii
    // 0	0	0	0	000	0	0	0	0
	begin
        clock_counter <= 2'b00;
        interrupt_stage <= 2'b00;
	end

	else if(instruction_id == 8'b00100000)			// LDI (1 cycle)
    // 1	0	0	1	0	0	0	0	0
	begin
                            
        clock_counter <= 2'b00;
        interrupt_stage <= 2'b00;
	end

	else if(instruction_id == 8'b00100001)			// LDS (2 cycles)
    // 0	0	0	0	000	0	0	0	0
	begin   
        clock_counter <= 2'b00;
        interrupt_stage <= 2'b00;
	end

	else if(instruction_id == 8'b00100010)			// LPM (3 cycles)
    begin
        if(clock_counter == 2'b00)
        begin    
            clock_counter <= 2'b01;
            interrupt_stage <= 2'b00;
        end

        else if(clock_counter == 2'b01)
        begin         
            clock_counter <= 2'b10;
            interrupt_stage <= 2'b00;
        end

        else if(clock_counter == 2'b10)
        begin                  
            clock_counter <= 2'b00;
            interrupt_stage <= 2'b00;
        end

        else
        begin            
            clock_counter <= 2'b00;
            interrupt_stage <= 2'b00;
        end
    end

	else if(instruction_id == 8'b00100011)			// LSL (1 cycle)
    // 0	0	0	0	000	0	0	0	0
	begin               
        clock_counter <= 2'b00;
        interrupt_stage <= 2'b00;
	end

	else if(instruction_id == 8'b00100100)			// LSR
    // 1	0	0	1	100	0	0	0	0
	begin             
        clock_counter <= 2'b00;
        interrupt_stage <= 2'b00;
	end

	else if(instruction_id == 8'b00100101)			// MOV (1 cycle)
    // 1	0	0	1	000	0	0	0	0
	begin              
        clock_counter <= 2'b00;
        interrupt_stage <= 2'b00;
	end

	else if(instruction_id == 8'b00100110)			// MUL (2 cycle)
	begin
        if(clock_counter == 2'b00)
        // 1	1	0	1	010	0	0	0	0
        begin           
            clock_counter <= 2'b00;
            interrupt_stage <= 2'b00;
        end

        else if (clock_counter == 2'b01)
        // 0	0	0	1	010	0	0	0	0
        begin            
            clock_counter <= 2'b00;
            interrupt_stage <= 2'b00;
        end
        

        else
        // 0	0	0	0	000	0	0	0	0
        begin              
            clock_counter <= 2'b00;
            interrupt_stage <= 2'b00;
        end
	end

	else if(instruction_id == 8'b00100111)			// OR (1 cycle)
    // 1	0	0	1	110	0	0	0	0
	begin         
        clock_counter <= 2'b00;
        interrupt_stage <= 2'b00;
	end

	else if(instruction_id == 8'b00101000)			// ORI (1 cycle)
    // 1	0	0	1	110	0	0	0	0
	begin         
        clock_counter <= 2'b00;		
        interrupt_stage <= 2'b00;
	end

	else if(instruction_id == 8'b00101001)			// OUT (2 cycle)
    // 1	0	0	0	000	0	0	0	1
	begin       
        if (clock_counter == 2'b00)
        begin 
            clock_counter <= 2'b01;		
            interrupt_stage <= 2'b00;
        end
        else if (clock_counter == 2'b01)
        begin 
            clock_counter <= 2'b00;		
            interrupt_stage <= 2'b00;
        end
        else 
        begin 
            clock_counter <= 2'b00;		
            interrupt_stage <= 2'b00;
        end
	end

	else if(instruction_id == 8'b00101010)			// POP (2 cycles)
	begin
        if(clock_counter == 2'b00)
        // 1	0	0	0	000	0	0	0	1
        begin       
            clock_counter <= 2'b01;
            interrupt_stage <= 2'b00;
        end

        else if (clock_counter == 2'b01)
        // 0	0	0	1	000	0	0	0	0
        begin        
            clock_counter <= 2'b00;
            interrupt_stage <= 2'b00;
        end

        else
        // 0	0	0	0	000	0	0	0	0
        begin      
            clock_counter <= 2'b00;
            interrupt_stage <= 2'b00;
        end		
	end

	else if(instruction_id == 8'b00101011)			// PUSH (2 cycles)
	begin
        if(clock_counter == 2'b00)
        // 1	0	0	0	000	0	0	0	1
        begin           
            clock_counter <= 2'b01;
            interrupt_stage <= 2'b00;
        end

        else if (clock_counter == 2'b01)
        // 0	0	0	0	001	0	0	0	1
        begin       
            clock_counter <= 2'b00;
            interrupt_stage <= 2'b00;
        end

        else
        // 0	0	0	0	000	0	0	0	0
        begin      
            clock_counter <= 2'b00;
            interrupt_stage <= 2'b00;
        end			
	end

	else if(instruction_id == 8'b00101100)			// RCALL (4 cycles)
	begin
        if(clock_counter == 2'b00)
        begin        
            clock_counter <= 2'b01; 
            interrupt_stage <= 2'b00;
        end 
        else if(clock_counter == 2'b01)
        begin     
            clock_counter <= 2'b10; 
            interrupt_stage <= 2'b00;
        end
        else if(clock_counter == 2'b10)
        begin      
            clock_counter <= 2'b11;
            interrupt_stage <= 2'b00;
        end

        else if(clock_counter == 2'b11)
        begin      
            clock_counter <= 2'b00;	
            interrupt_stage <= 2'b00;	
        end
        else
        begin       
            clock_counter <= 2'b00;
            interrupt_stage <= 2'b00;
        end
	end

	else if(instruction_id == 8'b00101101)			// RET (4 cycles)
	begin
        if(clock_counter == 2'b00)
        begin     
            clock_counter <= 2'b01;
            interrupt_stage <= 2'b00;
        end

        else if(clock_counter == 2'b01)
        begin
        // clock cycle 1     
            clock_counter <= 2'b10;	
            interrupt_stage <= 2'b00;
        end

        else if (clock_counter == 2'b10)
        begin
        // clock cycle 2
            clock_counter <= 2'b11;	
            interrupt_stage <= 2'b00;
        end

        else if(clock_counter == 2'b11)
        begin
        // clock cycle 3 
            clock_counter <= 2'b00;	
            interrupt_stage <= 2'b00;
        end
	end

	else if(instruction_id == 8'b00101110)			// RETI (4 cycles)
	begin
        if(clock_counter == 2'b00)
        begin
        // clock cycle 0
            clock_counter <= 2'b01;
            interrupt_stage <= 2'b00;
        end

        else if(clock_counter == 2'b01)
        begin
        // clock cycle 1  
            clock_counter <= 2'b10;	
            interrupt_stage <= 2'b00;
        end

        else if (clock_counter == 2'b10)
        begin
        // clock cycle 2
            clock_counter <= 2'b11;	
            interrupt_stage <= 2'b00;
        end

        else if (clock_counter == 2'b11)
        begin
        // clock cycle 3
            clock_counter <= 2'b00;	
            interrupt_stage <= 2'b00;
        end
	end

	else if(instruction_id == 8'b00101111)			// RJMP (2 cycles)
	begin
        if(clock_counter == 2'b00)
        // 1	0	1	0	000	0	0	0	0
        begin
            clock_counter <= 2'b01;
            interrupt_stage <= 2'b00;
        end

        else if (clock_counter == 2'b01)
        // 0	0	0	0	0	0	0	0	0
        begin    
            clock_counter <= 2'b10;
            interrupt_stage <= 2'b00;
        end
        else
        // 0	0	0	0	000	0	0	0	0
        begin      
            clock_counter <= 2'b00;
            interrupt_stage <= 2'b00;
        end				
	end

	else if(instruction_id == 8'b00110000)			// ROL (1 cycle)
    // 1	0	0	1	011	0	0	0	0
	begin
        clock_counter <= 2'b00;	
        interrupt_stage <= 2'b00;
	end

	else if(instruction_id == 8'b00110001)			// ROR (1 cycle)
    // 1	0	0	1	100	0	0	0	0
	begin
        clock_counter <= 2'b00;
        interrupt_stage <= 2'b00;
	end

	else if(instruction_id == 8'b00110010)			// SEI (1 cycle)
    // 1	0	0	0	000	0	1	1	1
	begin
        clock_counter <= 2'b00;
        interrupt_stage <= 2'b00;
	end

	else if(instruction_id == 8'b00110011)			// ST (X)
    // 0	0	0	0	000	0	0	0	0
	begin   
        clock_counter <= 2'b00;
        interrupt_stage <= 2'b00;
	end

	else if(instruction_id == 8'b00110100)			// ST(X) - i
    // 0	0	0	0	000	0	0	0	0
	begin
        clock_counter <= 2'b00;
        interrupt_stage <= 2'b00;
	end

	else if(instruction_id == 8'b00110101)			// ST(X) - ii
    // 0	0	0	0	000	0	0	0	0
	begin 
        clock_counter <= 2'b00;
        interrupt_stage <= 2'b00;
	end

	else if(instruction_id == 8'b00110110)			// ST(X) - iii
    // 0	0	0	0	000	0	0	0	0
	begin 
        clock_counter <= 2'b00;
        interrupt_stage <= 2'b00;
	end

	else if(instruction_id == 8'b00110111)			// ST (Y)
    // 0	0	0	0	000	0	0	0	0
	begin 
        clock_counter <= 2'b00;
        interrupt_stage <= 2'b00;
	end

	else if(instruction_id == 8'b00111000)			// ST(Y) - i (2 cycles)
	begin
		if(clock_counter == 2'b00)
        begin    
            clock_counter <= 2'b01;
            interrupt_stage <= 2'b00;
        end

        else if(clock_counter == 2'b01)
        begin
        // clock cycle 1  
            clock_counter <= 2'b00;
            interrupt_stage <= 2'b00;
        end

        else
        begin
            clock_counter <= 2'b00;
            interrupt_stage <= 2'b00;
        end
    end

	else if(instruction_id == 8'b00111001)			// ST(Y) - ii (2 cycles)
    // 0	0	0	0	000	0	0	0	0
	begin
        clock_counter <= 2'b00;
        interrupt_stage <= 2'b00;
	end

	else if(instruction_id == 8'b00111010)			// ST(Y) - iii
    // 0	0	0	0	000	0	0	0	0
	begin 
        clock_counter <= 2'b00;
        interrupt_stage <= 2'b00;
	end

	else if(instruction_id == 8'b00111011)			// ST (Z)
    // 0	0	0	0	000	0	0	0	0
	begin
        clock_counter <= 2'b00;
        interrupt_stage <= 2'b00;
	end

	else if(instruction_id == 8'b00111100)			// ST(Z) - i
    // 0	0	0	0	000	0	0	0	0
	begin
        clock_counter <= 2'b00;
        interrupt_stage <= 2'b00;
	end

	else if(instruction_id == 8'b00111101)			// ST(Z) - ii
    // 0	0	0	0	000	0	0	0	0
	begin
        clock_counter <= 2'b00;
        interrupt_stage <= 2'b00;
	end

	else if(instruction_id == 8'b00111110)			// ST(Z) - iii
    // 0	0	0	0	000	0	0	0	0
	begin
        clock_counter <= 2'b00;
        interrupt_stage <= 2'b00;
	end

	else if(instruction_id == 8'b00111111)			// STS (2 cycles)
    // 0	0	0	0	000	0	0	0	0
	begin
        clock_counter <= 2'b00;
        interrupt_stage <= 2'b00;
	end

	else if(instruction_id == 8'b01000000)			// SUB (1 cycle)
    // 1	0	0	1	001	0	0	0	0
	begin         
        clock_counter <= 2'b00;	
        interrupt_stage <= 2'b00;	
	end

	else if(instruction_id == 8'b01000001)			// SUBI
    // 1	0	0	1	001	0	0	0	0
	begin        
        clock_counter <= 2'b00;	
        interrupt_stage <= 2'b00;	
	end

    else                                    // Catch All block                                                        
    // 0	0	0	0 000	0	0	0	0
	begin     
        clock_counter <= 2'b00;	
        interrupt_stage <= 2'b00;
	end
end

always @(instruction_id, clock_counter, interrupt_stage)
begin
	if(!reset_n)
    // 0	0	0	0	000	0	0	0	0
	begin
        pc_inc <= 1'b0;
        ireg_hold <= 1'b0;
        pc_overwrite <= 1'b0;
        gp_reg_write <= 1'b0;
        alu_sel <= 3'b000;
        use_carry <= 1'b0;
        status_reg_sel <= 1'b0;
        io_only_flag <= 1'b0;
        memory_write_en <= 1'b0;
        sp_write_enable <= 1'b0;
	end
    else if (interrupt_stage > 2'h0) begin 
        // Handle interrupt 
        // Save PC
        // Update PC
        if (interrupt_stage == 2'h1) 
        begin 
            // save PC high 
            pc_inc <= 1'b0;
            ireg_hold <= 1'b0;
            pc_overwrite <= 1'b0;
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b001;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b1;
            sp_write_enable <= 1'b1;
        end
        else if (interrupt_stage == 2'h2) 
        begin 
            // save PC low 
            pc_inc <= 1'b0;
            ireg_hold <= 1'b0;
            pc_overwrite <= 1'b0;
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b001;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b1;
            sp_write_enable <= 1'b1;

        end
        else if (interrupt_stage == 2'h3) 
        begin
            // update PC 
            pc_inc <= 1'b0;
            ireg_hold <= 1'b0;
            pc_overwrite <= 1'b1;
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b000;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b0;
            sp_write_enable <= 1'b0;

        end
        else
        begin
            pc_inc <= 1'b0;
            ireg_hold <= 1'b0;
            pc_overwrite <= 1'b0;
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b000;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b0;
            sp_write_enable <= 1'b0;
        end
    end 
    else if ((OC_flag == 1'b1) && (status_register[I] == 1'b0) && (clock_counter == 2'b00)) 
    begin // handle interrupt
        // clear I bit 
        pc_inc <= 1'b0;
        ireg_hold <= 1'b0;
        pc_overwrite <= 1'b0;
        gp_reg_write <= 1'b0;
        alu_sel <= 3'b000;
        use_carry <= 1'b0;
        status_reg_sel <= 1'b0;
        io_only_flag <= 1'b1;   //write to SREG
        memory_write_en <= 1'b1;
        sp_write_enable <= 1'b0;

    end 
    else if(instruction_id == 8'b00000000)			// NOP
    // 0	0	0	0	000	0	0	0	0
	begin
        pc_inc <= 1'b0;
        ireg_hold <= 1'b0;
        pc_overwrite <= 1'b0;
        gp_reg_write <= 1'b0;
        alu_sel <= 3'b000;
        use_carry <= 1'b0;
        status_reg_sel <= 1'b0;
        io_only_flag <= 1'b0;
        memory_write_en <= 1'b0;
        sp_write_enable <= 1'b0;
	end

	else if(instruction_id == 8'b00000001)			// ADC (1 cycle)
    // 1	0	0	1	000	1	0	0	0
	begin
		pc_inc <= 1'b1;
        ireg_hold <= 1'b0;
        pc_overwrite <= 1'b0;
        gp_reg_write <= 1'b1;
        alu_sel <= 3'b000;
        use_carry <= 1'b1;
        status_reg_sel <= 1'b0;
        io_only_flag <= 1'b0;
        memory_write_en <= 1'b0;
        sp_write_enable <= 1'b0;
        
	end

	else if(instruction_id == 8'b00000010)			// ADD (1 cycle)
    // 1	0	0	1	000	0	0	0	0
	begin
        pc_inc <= 1'b1;
        ireg_hold <= 1'b0;
        pc_overwrite <= 1'b0;
        gp_reg_write <= 1'b1;
        alu_sel <= 3'b000;
        use_carry <= 1'b0;
        status_reg_sel <= 1'b0;
        io_only_flag <= 1'b0;
        memory_write_en <= 1'b0;
        sp_write_enable <= 1'b0;
        
	end

	else if(instruction_id == 8'b00000011)			// AND (1 cycle)
    // 1	0	0	1	101	0	0	0	0
	begin
		pc_inc <= 1'b1;
        ireg_hold <= 1'b0;
        pc_overwrite <= 1'b0;
        gp_reg_write <= 1'b1;
        alu_sel <= 3'b101;
        use_carry <= 1'b0;
        status_reg_sel <= 1'b0;
        io_only_flag <= 1'b0;
        memory_write_en <= 1'b0;
        sp_write_enable <= 1'b0;
	end

	else if(instruction_id == 8'b00000100)			// BRCC (2 cycles)
	begin
		if(clock_counter == 2'b00)
        // 1	0	!C	0	000	0	0	0	0
        begin
            pc_inc <= 1'b1;
            ireg_hold <= 1'b0;
            pc_overwrite <= ~(status_register[C]);
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b000;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b0;
            sp_write_enable <= 1'b0;
            
        end

        else if (clock_counter == 2'b01)
        // 0	0	0	0	000	0	0	0	0
        begin
            pc_inc <= 1'b0;
            ireg_hold <= 1'b0;
            pc_overwrite <= 1'b0;
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b000;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b0;
            sp_write_enable <= 1'b0;
        end

        else
        // 0	0	0	0	000	0	0	0	0
        begin
            pc_inc <= 1'b0;
            ireg_hold <= 1'b0;
            pc_overwrite <= 1'b0;
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b000;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b0;
            sp_write_enable <= 1'b0;
        end
	end

	else if(instruction_id == 8'b00000101)			// BRCS (2 cycles)
    begin
		if(clock_counter == 2'b00)
        // 1	0	C	0	000	0	0	0	0
        begin
            pc_inc <= 1'b1;
            ireg_hold <= 1'b0;
            pc_overwrite <= status_register[C];
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b000;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b0;
            sp_write_enable <= 1'b0;
        end

        else if (clock_counter == 2'b01)
        // 0	0	0	0	000	0	0	0	0
        begin
            pc_inc <= 1'b0;
            ireg_hold <= 1'b0;
            pc_overwrite <= 1'b0;
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b000;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b0;
            sp_write_enable <= 1'b0;
        end

        else
        // 0	0	0	0	000	0	0	0	0
        begin
            pc_inc <= 1'b0;
            ireg_hold <= 1'b0;
            pc_overwrite <= 1'b0;
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b000;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b0;
            sp_write_enable <= 1'b0;
        end
    end

	else if(instruction_id == 8'b00000110)			// BREQ (2 cycles)
	begin
		if(clock_counter == 2'b00)
        // 1	0	Z	0	000	0	0	0	0
        begin
            pc_inc <= 1'b1;
            ireg_hold <= 1'b0;
            pc_overwrite <= status_register[Z];
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b000;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b0;
            sp_write_enable <= 1'b0;
        end

        else if (clock_counter == 2'b01)
        // 0	0	0	0	000	0	0	0	0
        begin
            pc_inc <= 1'b0;
            ireg_hold <= 1'b0;
            pc_overwrite <= 1'b0;
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b000;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b0;
            sp_write_enable <= 1'b0;          
        end

        else
        // 0	0	0	0	000	0	0	0	0
        begin
            pc_inc <= 1'b0;
            ireg_hold <= 1'b0;
            pc_overwrite <= 1'b0;
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b000;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b0;
            sp_write_enable <= 1'b0;
        end
	end

	else if(instruction_id == 8'b00000111)			// BRLO (2 cycles)
	begin
		if(clock_counter == 2'b00)
        // 0	0	0	0	000	0	0	0	0
        begin
            pc_inc <= 1'b0;
            ireg_hold <= 1'b0;
            pc_overwrite <= 1'b0;
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b000;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b0;
            sp_write_enable <= 1'b0;
        end

        else if (clock_counter == 2'b01)
        // 0	0	0	0	000	0	0	0	0
        begin
            pc_inc <= 1'b0;
            ireg_hold <= 1'b0;
            pc_overwrite <= 1'b0;
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b000;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b0;
            sp_write_enable <= 1'b0;
        end

        else
        // 0	0	0	0	000	0	0	0	0
        begin
            pc_inc <= 1'b0;
            ireg_hold <= 1'b0;
            pc_overwrite <= 1'b0;
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b000;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b0;
            sp_write_enable <= 1'b0;
        end
	end

	else if(instruction_id == 8'b00001000)			// BRNE (2 cycles)
	begin
		if(clock_counter == 2'b00)
        // 1	0	!Z	0	000	0	0	0	0
        begin
            pc_inc <= 1'b1;
            ireg_hold <= 1'b0;
            pc_overwrite <= ~(status_register[Z]);
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b000;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b0;
            sp_write_enable <= 1'b0;
        end

        else if (clock_counter == 2'b01)
        // 0	0	0	0	000	0	0	0	0
        begin
            pc_inc <= 1'b0;
            ireg_hold <= 1'b0;
            pc_overwrite <= 1'b0;
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b000;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b0;
            sp_write_enable <= 1'b0;
        end

        else
        // 0	0	0	0	000	0	0	0	0
        begin
            pc_inc <= 1'b0;
            ireg_hold <= 1'b0;
            pc_overwrite <= 1'b0;
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b000;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b0;
            sp_write_enable <= 1'b0;
        end
	end

	else if(instruction_id == 8'b00001001)			// CALL (4 cycles)
    // 0	0	0	0	000	0	0	0	0
	begin
        pc_inc <= 1'b0;
        ireg_hold <= 1'b0;
        pc_overwrite <= 1'b0;
        gp_reg_write <= 1'b0;
        alu_sel <= 3'b000;
        use_carry <= 1'b0;
        status_reg_sel <= 1'b0;
        io_only_flag <= 1'b0;
        memory_write_en <= 1'b0;
        sp_write_enable <= 1'b0;
	end

	else if(instruction_id == 8'b00001010)			// CLI (1 cycle)
    // 1	0	0	0	000	0	1	1	1
	begin
        pc_inc <= 1'b1;
        ireg_hold <= 1'b0;
        pc_overwrite <= 1'b0;
        gp_reg_write <= 1'b0;
        alu_sel <= 3'b000;
        use_carry <= 1'b0;
        status_reg_sel <= 1'b1;
        io_only_flag <= 1'b1;
        memory_write_en <= 1'b1;
        sp_write_enable <= 1'b0;
	end

	else if(instruction_id == 8'b00001011)			// CLR (1 cycle)
    // 0	0	0	0	000	0	0	0	0
    begin
        pc_inc <= 1'b0;
        ireg_hold <= 1'b0;
        pc_overwrite <= 1'b0;
        gp_reg_write <= 1'b0;
        alu_sel <= 3'b000;
        use_carry <= 1'b0;
        status_reg_sel <= 1'b0;
        io_only_flag <= 1'b0;
        memory_write_en <= 1'b0;
        sp_write_enable <= 1'b0;
	end

	else if(instruction_id == 8'b00001100)			// CP (1 cycle)
    // 1	0	0	0	001	0	0	0	0
	begin
        pc_inc <= 1'b1;
        ireg_hold <= 1'b0;
        pc_overwrite <= 1'b0;
        gp_reg_write <= 1'b0;
        alu_sel <= 3'b001;
        use_carry <= 1'b0;
        status_reg_sel <= 1'b0;
        io_only_flag <= 1'b0;
        memory_write_en <= 1'b0;
        sp_write_enable <= 1'b0;
	end

	else if(instruction_id == 8'b00001101)			// CPI (1 cycle)
    // 1	0	0	0	001	0	0	0	0
	begin
        pc_inc <= 1'b1;
        ireg_hold <= 1'b0;
        pc_overwrite <= 1'b0;
        gp_reg_write <= 1'b0;
        alu_sel <= 3'b001;
        use_carry <= 1'b0;
        status_reg_sel <= 1'b0;
        io_only_flag <= 1'b0;
        memory_write_en <= 1'b0;
        sp_write_enable <= 1'b0;	
	end

	else if(instruction_id == 8'b00001110)			// CPSE (2 cycles)
	begin
        if(clock_counter == 2'b00)
        begin
        // clock cycle 0
            pc_inc <= 1'b1;
            ireg_hold <= 1'b1;
            pc_overwrite <= 1'b0;
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b001;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b0;
            sp_write_enable <= 1'b0;
        end
        else if(clock_counter == 2'b01)
        begin
        // clock cycle 1  
            pc_inc <= status_register[Z];
            ireg_hold <= 1'b0;
            pc_overwrite <= 1'b0;
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b000;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b0;
            sp_write_enable <= 1'b0;
        end

        else
        begin
            pc_inc <= 1'b0;
            ireg_hold <= 1'b0;
            pc_overwrite <= 1'b0;
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b000;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b0;
            sp_write_enable <= 1'b0;
        end
	end

	else if(instruction_id == 8'b00001111)			// DEC
    // 1	0	0	1	001	0	0	0	0
	begin
        pc_inc <= 1'b1;
        ireg_hold <= 1'b0;
        pc_overwrite <= 1'b0;
        gp_reg_write <= 1'b1;
        alu_sel <= 3'b001;
        use_carry <= 1'b0;
        status_reg_sel <= 1'b0;
        io_only_flag <= 1'b0;
        memory_write_en <= 1'b0;
        sp_write_enable <= 1'b0;
	end

	else if(instruction_id == 8'b00010000)			// EOR
    // 1	0	0	1	111	0	0	0	0
	begin
        pc_inc <= 1'b1;
        ireg_hold <= 1'b0;
        pc_overwrite <= 1'b0;
        gp_reg_write <= 1'b1;
        alu_sel <= 3'b111;
        use_carry <= 1'b0;
        status_reg_sel <= 1'b0;
        io_only_flag <= 1'b0;
        memory_write_en <= 1'b0;
        sp_write_enable <= 1'b0;	
	end

	else if(instruction_id == 8'b00010001)			// IN
    // 1	0	0	1	000	0	1	1	0
	begin
        pc_inc <= 1'b1;
        ireg_hold <= 1'b0;
        pc_overwrite <= 1'b0;
        gp_reg_write <= 1'b1;
        alu_sel <= 3'b000;
        use_carry <= 1'b0;
        status_reg_sel <= 1'b1;
        io_only_flag <= 1'b1;
        memory_write_en <= 1'b0;
        sp_write_enable <= 1'b0;		
	end

	else if(instruction_id == 8'b00010010)			// INC
    // 1	0	0	1	000	0	0	0	0
	begin
        pc_inc <= 1'b1;
        ireg_hold <= 1'b0;
        pc_overwrite <= 1'b0;
        gp_reg_write <= 1'b1;
        alu_sel <= 3'b000;
        use_carry <= 1'b0;
        status_reg_sel <= 1'b0;
        io_only_flag <= 1'b0;
        memory_write_en <= 1'b0;
        sp_write_enable <= 1'b0;
	end

	else if(instruction_id == 8'b00010011)			// JMP (3 cycles)
    // 0	0	0	0	000	0	0	0	0
	begin
        pc_inc <= 1'b0;
        ireg_hold <= 1'b0;
        pc_overwrite <= 1'b0;
        gp_reg_write <= 1'b0;
        alu_sel <= 3'b000;
        use_carry <= 1'b0;
        status_reg_sel <= 1'b0;
        io_only_flag <= 1'b0;
        memory_write_en <= 1'b0;
        sp_write_enable <= 1'b0;
	end

	else if(instruction_id == 8'b00010100)			// LD (X)
    // 0	0	0	0	000	0	0	0	0
	begin
        pc_inc <= 1'b0;
        ireg_hold <= 1'b0;
        pc_overwrite <= 1'b0;
        gp_reg_write <= 1'b0;
        alu_sel <= 3'b000;
        use_carry <= 1'b0;
        status_reg_sel <= 1'b0;
        io_only_flag <= 1'b0;
        memory_write_en <= 1'b0;
        sp_write_enable <= 1'b0;
	end

	else if(instruction_id == 8'b00010101)			// LD(X) - i
    // 0	0	0	0	000	0	0	0	0
	begin
        pc_inc <= 1'b0;
        ireg_hold <= 1'b0;
        pc_overwrite <= 1'b0;
        gp_reg_write <= 1'b0;
        alu_sel <= 3'b000;
        use_carry <= 1'b0;
        status_reg_sel <= 1'b0;
        io_only_flag <= 1'b0;
        memory_write_en <= 1'b0;
        sp_write_enable <= 1'b0;
	end

	else if(instruction_id == 8'b00010110)			// LD(X) - ii
    // 0	0	0	0	000	0	0	0	0
	begin
        pc_inc <= 1'b0;
        ireg_hold <= 1'b0;
        pc_overwrite <= 1'b0;
        gp_reg_write <= 1'b0;
        alu_sel <= 3'b000;
        use_carry <= 1'b0;
        status_reg_sel <= 1'b0;
        io_only_flag <= 1'b0;
        memory_write_en <= 1'b0;
        sp_write_enable <= 1'b0;
	end

	else if(instruction_id == 8'b00010111)			// LD(X) - iii
    // 0	0	0	0	000	0	0	0	0
	begin
        pc_inc <= 1'b0;
        ireg_hold <= 1'b0;
        pc_overwrite <= 1'b0;
        gp_reg_write <= 1'b0;
        alu_sel <= 3'b000;
        use_carry <= 1'b0;
        status_reg_sel <= 1'b0;
        io_only_flag <= 1'b0;
        memory_write_en <= 1'b0;
        sp_write_enable <= 1'b0;
	end

	else if(instruction_id == 8'b00011000)			// LD (Y) (2 cycles)
    // 0	0	0	0	000	0	0	0	0
	begin
        pc_inc <= 1'b0;
        ireg_hold <= 1'b0;
        pc_overwrite <= 1'b0;
        gp_reg_write <= 1'b0;
        alu_sel <= 3'b000;
        use_carry <= 1'b0;
        status_reg_sel <= 1'b0;
        io_only_flag <= 1'b0;
        memory_write_en <= 1'b0;
        sp_write_enable <= 1'b0;
	end

	else if(instruction_id == 8'b00011001)			// LD(Y) - i (2 cycles)
	begin
        if(clock_counter == 2'b00)
        begin
        // clock cycle 0
            pc_inc <= 1'b1;
            ireg_hold <= 1'b1;
            pc_overwrite <= 1'b0;
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b000;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b0;
            sp_write_enable <= 1'b0;
        end

        else if(clock_counter == 2'b01)
        begin
        // clock cycle 1  
            pc_inc <= 1'b0;
            ireg_hold <= 1'b0;
            pc_overwrite <= 1'b0;
            gp_reg_write <= 1'b1;
            alu_sel <= 3'b000;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b0;
            sp_write_enable <= 1'b0;	
        end

        else
        begin
            pc_inc <= 1'b0;
            ireg_hold <= 1'b0;
            pc_overwrite <= 1'b0;
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b000;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b0;
            sp_write_enable <= 1'b0;
        end
	end

	else if(instruction_id == 8'b00011010)			// LD(Y) - ii (3 cycles)
    // 0	0	0	0	000	0	0	0	0
	begin
        pc_inc <= 1'b0;
        ireg_hold <= 1'b0;
        pc_overwrite <= 1'b0;
        gp_reg_write <= 1'b0;
        alu_sel <= 3'b000;
        use_carry <= 1'b0;
        status_reg_sel <= 1'b0;
        io_only_flag <= 1'b0;
        memory_write_en <= 1'b0;
        sp_write_enable <= 1'b0;
	end

	else if(instruction_id == 8'b00011011)			// LD(Y) - iii (3 cycles)
    // 0	0	0	0	000	0	0	0	0
	begin
        pc_inc <= 1'b0;
        ireg_hold <= 1'b0;
        pc_overwrite <= 1'b0;
        gp_reg_write <= 1'b0;
        alu_sel <= 3'b000;
        use_carry <= 1'b0;
        status_reg_sel <= 1'b0;
        io_only_flag <= 1'b0;
        memory_write_en <= 1'b0;
        sp_write_enable <= 1'b0;
	end

	else if(instruction_id == 8'b00011100)			// LD (Z)
    // 0	0	0	0	000	0	0	0	0
	begin
        pc_inc <= 1'b0;
        ireg_hold <= 1'b0;
        pc_overwrite <= 1'b0;
        gp_reg_write <= 1'b0;
        alu_sel <= 3'b000;
        use_carry <= 1'b0;
        status_reg_sel <= 1'b0;
        io_only_flag <= 1'b0;
        memory_write_en <= 1'b0;
        sp_write_enable <= 1'b0;
	end

	else if(instruction_id == 8'b00011101)			// LD(Z) - i
    // 0	0	0	0	000	0	0	0	0
	begin
        pc_inc <= 1'b0;
        ireg_hold <= 1'b0;
        pc_overwrite <= 1'b0;
        gp_reg_write <= 1'b0;
        alu_sel <= 3'b000;
        use_carry <= 1'b0;
        status_reg_sel <= 1'b0;
        io_only_flag <= 1'b0;
        memory_write_en <= 1'b0;
        sp_write_enable <= 1'b0;
	end

	else if(instruction_id == 8'b00011110)			// LD(Z) - ii
    // 0	0	0	0	000	0	0	0	0
	begin
        pc_inc <= 1'b0;
        ireg_hold <= 1'b0;
        pc_overwrite <= 1'b0;
        gp_reg_write <= 1'b0;
        alu_sel <= 3'b000;
        use_carry <= 1'b0;
        status_reg_sel <= 1'b0;
        io_only_flag <= 1'b0;
        memory_write_en <= 1'b0;
        sp_write_enable <= 1'b0;
	end

	else if(instruction_id == 8'b00011111)			// LD(Z) - iii
    // 0	0	0	0	000	0	0	0	0
	begin
        pc_inc <= 1'b0;
        ireg_hold <= 1'b0;
        pc_overwrite <= 1'b0;
        gp_reg_write <= 1'b0;
        alu_sel <= 3'b000;
        use_carry <= 1'b0;
        status_reg_sel <= 1'b0;
        io_only_flag <= 1'b0;
        memory_write_en <= 1'b0;
        sp_write_enable <= 1'b0;
	end

	else if(instruction_id == 8'b00100000)			// LDI (1 cycle)
    // 1	0	0	1	0	0	0	0	0
	begin
        pc_inc <= 1'b1;
        ireg_hold <= 1'b0;
        pc_overwrite <= 1'b0;
        gp_reg_write <= 1'b1;
        alu_sel <= 3'b000;
        use_carry <= 1'b0;
        status_reg_sel <= 1'b0;
        io_only_flag <= 1'b0;
        memory_write_en <= 1'b0;
        sp_write_enable <= 1'b0;
	end

	else if(instruction_id == 8'b00100001)			// LDS (2 cycles)
    // 0	0	0	0	000	0	0	0	0
	begin
        pc_inc <= 1'b0;
        ireg_hold <= 1'b0;
        pc_overwrite <= 1'b0;
        gp_reg_write <= 1'b0;
        alu_sel <= 3'b000;
        use_carry <= 1'b0;
        status_reg_sel <= 1'b0;
        io_only_flag <= 1'b0;
        memory_write_en <= 1'b0;
        sp_write_enable <= 1'b0;
	end

	else if(instruction_id == 8'b00100010)			// LPM (3 cycles)
    begin
        if(clock_counter == 2'b00)
        begin
        // clock cycle 0
            pc_inc <= 1'b1;
            ireg_hold <= 1'b0;
            pc_overwrite <= 1'b0;
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b000;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b0;
            sp_write_enable <= 1'b0;
        end

        else if(clock_counter == 2'b01)
        begin
        // clock cycle 1  
            pc_inc <= 1'b0;
            ireg_hold <= 1'b0;
            pc_overwrite <= 1'b0;
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b000;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b0;
            sp_write_enable <= 1'b0;
        end

        else if(clock_counter == 2'b10)
        begin
        // clock cycle 2
            pc_inc <= 1'b0;
            ireg_hold <= 1'b0;
            pc_overwrite <= 1'b0;
            gp_reg_write <= 1'b1;
            alu_sel <= 3'b000;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b0;
            sp_write_enable <= 1'b0;
        end

        else
        begin
            pc_inc <= 1'b0;
            ireg_hold <= 1'b0;
            pc_overwrite <= 1'b0;
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b000;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b0;
            sp_write_enable <= 1'b0;
        end
    end

	else if(instruction_id == 8'b00100011)			// LSL (1 cycle)
    // 0	0	0	0	000	0	0	0	0
	begin
        pc_inc <= 1'b0;
        ireg_hold <= 1'b0;
        pc_overwrite <= 1'b0;
        gp_reg_write <= 1'b0;
        alu_sel <= 3'b000;
        use_carry <= 1'b0;
        status_reg_sel <= 1'b0;
        io_only_flag <= 1'b0;
        memory_write_en <= 1'b0;
        sp_write_enable <= 1'b0;
	end

	else if(instruction_id == 8'b00100100)			// LSR
    // 1	0	0	1	100	0	0	0	0
	begin
	    pc_inc <= 1'b1;
        ireg_hold <= 1'b0;
        pc_overwrite <= 1'b0;
        gp_reg_write <= 1'b1;
        alu_sel <= 3'b100;
        use_carry <= 1'b0;
        status_reg_sel <= 1'b0;
        io_only_flag <= 1'b0;
        memory_write_en <= 1'b0;
        sp_write_enable <= 1'b0;
	end

	else if(instruction_id == 8'b00100101)			// MOV (1 cycle)
    // 1	0	0	1	000	0	0	0	0
	begin
	    pc_inc <= 1'b1;
        ireg_hold <= 1'b0;
        pc_overwrite <= 1'b0;
        gp_reg_write <= 1'b1;
        alu_sel <= 3'b000;
        use_carry <= 1'b0;
        status_reg_sel <= 1'b0;
        io_only_flag <= 1'b0;
        memory_write_en <= 1'b0;
        sp_write_enable <= 1'b0;
	end

	else if(instruction_id == 8'b00100110)			// MUL (2 cycle)
	begin
        if(clock_counter == 2'b00)
        // 1	1	0	1	010	0	0	0	0
        begin
            pc_inc <= 1'b1;
            ireg_hold <= 1'b1;
            pc_overwrite <= 1'b0;
            gp_reg_write <= 1'b1;
            alu_sel <= 3'b010;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b0;
            sp_write_enable <= 1'b0;
        end

        else if (clock_counter == 2'b01)
        // 0	0	0	1	010	0	0	0	0
        begin
            pc_inc <= 1'b0;
            ireg_hold <= 1'b0;
            pc_overwrite <= 1'b0;
            gp_reg_write <= 1'b1;
            alu_sel <= 3'b010;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b0;
            sp_write_enable <= 1'b0;
        end

        else
        // 0	0	0	0	000	0	0	0	0
        begin
            pc_inc <= 1'b0;
            ireg_hold <= 1'b0;
            pc_overwrite <= 1'b0;
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b000;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b0;
            sp_write_enable <= 1'b0;
        end
	end

	else if(instruction_id == 8'b00100111)			// OR (1 cycle)
    // 1	0	0	1	110	0	0	0	0
	begin
        pc_inc <= 1'b1;
        ireg_hold <= 1'b0;
        pc_overwrite <= 1'b0;
        gp_reg_write <= 1'b1;
        alu_sel <= 3'b110;
        use_carry <= 1'b0;
        status_reg_sel <= 1'b0;
        io_only_flag <= 1'b0;
        memory_write_en <= 1'b0;
        sp_write_enable <= 1'b0;
	end

	else if(instruction_id == 8'b00101000)			// ORI (1 cycle)
    // 1	0	0	1	110	0	0	0	0
	begin
        pc_inc <= 1'b1;
        ireg_hold <= 1'b0;
        pc_overwrite <= 1'b0;
        gp_reg_write <= 1'b1;
        alu_sel <= 3'b110;
        use_carry <= 1'b0;
        status_reg_sel <= 1'b0;
        io_only_flag <= 1'b0;
        memory_write_en <= 1'b0;
        sp_write_enable <= 1'b0;	
	end

	else if(instruction_id == 8'b00101001)			// OUT (2 cycle)
    // 1	0	0	0	000	0	0	0	1
	begin
        if (clock_counter == 2'b00)
        begin 
            pc_inc <= 1'b0;
            ireg_hold <= 1'b1;
            pc_overwrite <= 1'b0;
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b000;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b1;
            memory_write_en <= 1'b1;
            sp_write_enable <= 1'b0;
        end
        else if (clock_counter == 2'b01)
        begin 
            pc_inc <= 1'b1;
            ireg_hold <= 1'b0;
            pc_overwrite <= 1'b0;
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b000;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b0;
            sp_write_enable <= 1'b0;
        end		
        else 
        begin 
            pc_inc <= 1'b0;
            ireg_hold <= 1'b0;
            pc_overwrite <= 1'b0;
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b000;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b0;
            sp_write_enable <= 1'b0;
        end	
	end

	else if(instruction_id == 8'b00101010)			// POP (2 cycles)
	begin
        if(clock_counter == 2'b00)
        // 1	0	0	0	000	0	0	0	1
        begin
            pc_inc <= 1'b1;
            ireg_hold <= 1'b1;
            pc_overwrite <= 1'b0;
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b000;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b1;
            sp_write_enable <= 1'b1;
        end

        else if (clock_counter == 2'b01)
        // 0	0	0	1	000	0	0	0	0
        begin
            pc_inc <= 1'b0;
            ireg_hold <= 1'b0;
            pc_overwrite <= 1'b0;
            gp_reg_write <= 1'b1;
            alu_sel <= 3'b000;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b0;
            sp_write_enable <= 1'b0;
        end

        else
        // 0	0	0	0	000	0	0	0	0
        begin
            pc_inc <= 1'b0;
            ireg_hold <= 1'b0;
            pc_overwrite <= 1'b0;
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b000;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b0;
            sp_write_enable <= 1'b0;
        end		
	end

	else if(instruction_id == 8'b00101011)			// PUSH (2 cycles)
	begin
        if(clock_counter == 2'b00)
        // 1	0	0	0	000	0	0	0	1
        begin
            pc_inc <= 1'b1;
            ireg_hold <= 1'b1;
            pc_overwrite <= 1'b0;
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b000;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b1;
            sp_write_enable <= 1'b0;
        end

        else if (clock_counter == 2'b01)
        // 0	0	0	0	001	0	0	0	1
        begin
            pc_inc <= 1'b0;
            ireg_hold <= 1'b0;
            pc_overwrite <= 1'b0;
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b001;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b1;
            sp_write_enable <= 1'b1;
        end

        else
        // 0	0	0	0	000	0	0	0	0
        begin
            pc_inc <= 1'b0;
            ireg_hold <= 1'b0;
            pc_overwrite <= 1'b0;
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b000;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b0;
            sp_write_enable <= 1'b0;
        end			
	end

	else if(instruction_id == 8'b00101100)			// RCALL (4 cycles)
	begin
        if(clock_counter == 2'b00)
        begin 
            pc_inc <= 1'b1;
            ireg_hold <= 1'b1;
            pc_overwrite <= 1'b0;
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b000;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b0;
            sp_write_enable <= 1'b0;
        end 
        else if(clock_counter == 2'b01)
        begin
		// clock cycle 1
            pc_inc <= 1'b0;
            ireg_hold <= 1'b1;
            pc_overwrite <= 1'b0;
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b001;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b1;
            sp_write_enable <= 1'b1;
        end
        else if(clock_counter == 2'b10)
        begin
        // clock cycle 2 
            pc_inc <= 1'b0;
            ireg_hold <= 1'b1;
            pc_overwrite <= 1'b0;
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b001;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b1;
            sp_write_enable <= 1'b1;
        end

        else if(clock_counter == 2'b11)
        begin
        // clock cycle 3  
            pc_inc <= 1'b0;
            ireg_hold <= 1'b0;
            pc_overwrite <= 1'b1;
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b000;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b0;
            sp_write_enable <= 1'b0;	
        end
        else
        begin
            pc_inc <= 1'b0;
            ireg_hold <= 1'b0;
            pc_overwrite <= 1'b0;
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b000;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b0;
            sp_write_enable <= 1'b0;
        end
	end

	else if(instruction_id == 8'b00101101)			// RET (4 cycles)
	begin
        if(clock_counter == 2'b00)
        begin
		// clock cycle 0
            pc_inc <= 1'b0;
            ireg_hold <= 1'b1;
            pc_overwrite <= 1'b0;
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b000;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b0;
            sp_write_enable <= 1'b1;
        end

        else if(clock_counter == 2'b01)
        begin
        // clock cycle 1  
            pc_inc <= 1'b0;
            ireg_hold <= 1'b1;
            pc_overwrite <= 1'b0;
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b000;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b0;
            sp_write_enable <= 1'b1;
        end

        else if (clock_counter == 2'b10)
        begin
        // clock cycle 2
            pc_inc <= 1'b0;
            ireg_hold <= 1'b1;
            pc_overwrite <= 1'b0;
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b000;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b0;
            sp_write_enable <= 1'b0;
        end

        else if(clock_counter == 2'b11)
        begin
        // clock cycle 3
            pc_inc <= 1'b0;
            ireg_hold <= 1'b0;
            pc_overwrite <= 1'b1;
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b000;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b0;
            sp_write_enable <= 1'b0;
        end
	end

	else if(instruction_id == 8'b00101110)			// RETI (4 cycles)
	begin
        if(clock_counter == 2'b00)
        begin
        // clock cycle 0
            pc_inc <= 1'b0;
            ireg_hold <= 1'b1;
            pc_overwrite <= 1'b0;
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b000;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b0;
            sp_write_enable <= 1'b1;
        end

        else if(clock_counter == 2'b01)
        begin
        // clock cycle 1  
            pc_inc <= 1'b0;
            ireg_hold <= 1'b1;
            pc_overwrite <= 1'b0;
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b000;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b0;
            sp_write_enable <= 1'b1;
        end

        else if (clock_counter == 2'b10)
        begin
        // clock cycle 2
            pc_inc <= 1'b0;
            ireg_hold <= 1'b1;
            pc_overwrite <= 1'b0;
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b000;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b0;
            sp_write_enable <= 1'b0;
        end

        else if (clock_counter == 2'b11)
        begin
        // clock cycle 3
            pc_inc <= 1'b0;
            ireg_hold <= 1'b0;
            pc_overwrite <= 1'b1;
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b000;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b1;
            sp_write_enable <= 1'b0;
        end
	end

	else if(instruction_id == 8'b00101111)			// RJMP (2 cycles)
	begin
        if(clock_counter == 2'b00)
        // 1	0	1	0	000	0	0	0	0
        begin
            pc_inc <= 1'b0;
            ireg_hold <= 1'b1;
            pc_overwrite <= 1'b1;
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b000;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b0;
            sp_write_enable <= 1'b0;
        end

        else if (clock_counter == 2'b01)
        // 0	0	0	0	0	0	0	0	0
        begin
            pc_inc <= 1'b0;
            ireg_hold <= 1'b0;
            pc_overwrite <= 1'b0; 
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b000;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b0;
            sp_write_enable <= 1'b0;
        end
        else
        // 0	0	0	0	000	0	0	0	0
        begin
            pc_inc <= 1'b0;
            ireg_hold <= 1'b0;
            pc_overwrite <= 1'b0;
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b000;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b0;
            sp_write_enable <= 1'b0;
        end				
	end

	else if(instruction_id == 8'b00110000)			// ROL (1 cycle)
    // 1	0	0	1	011	0	0	0	0
	begin
        pc_inc <= 1'b1;
        ireg_hold <= 1'b0;
        pc_overwrite <= 1'b0;
        gp_reg_write <= 1'b1;
        alu_sel <= 3'b011;
        use_carry <= 1'b0;
        status_reg_sel <= 1'b0;
        io_only_flag <= 1'b0;
        memory_write_en <= 1'b0;	
        sp_write_enable <= 1'b0;
	end

	else if(instruction_id == 8'b00110001)			// ROR (1 cycle)
    // 1	0	0	1	100	0	0	0	0
	begin
        pc_inc <= 1'b1;
        ireg_hold <= 1'b0;
        pc_overwrite <= 1'b0;
        gp_reg_write <= 1'b1;
        alu_sel <= 3'b100;
        use_carry <= 1'b0;
        status_reg_sel <= 1'b0;
        io_only_flag <= 1'b0;
        memory_write_en <= 1'b0;
        sp_write_enable <= 1'b0;
	end

	else if(instruction_id == 8'b00110010)			// SEI (1 cycle)
    // 1	0	0	0	000	0	1	1	1
	begin
        pc_inc <= 1'b1;
        ireg_hold <= 1'b0;
        pc_overwrite <= 1'b0;
        gp_reg_write <= 1'b0;
        alu_sel <= 3'b000;
        use_carry <= 1'b0;
        status_reg_sel <= 1'b1;
        io_only_flag <= 1'b1;
        memory_write_en <= 1'b1;	
        sp_write_enable <= 1'b0;	
	end

	else if(instruction_id == 8'b00110011)			// ST (X)
    // 0	0	0	0	000	0	0	0	0
	begin
        pc_inc <= 1'b0;
        ireg_hold <= 1'b0;
        pc_overwrite <= 1'b0;
        gp_reg_write <= 1'b0;
        alu_sel <= 3'b000;
        use_carry <= 1'b0;
        status_reg_sel <= 1'b0;
        io_only_flag <= 1'b0;
        memory_write_en <= 1'b0;
        sp_write_enable <= 1'b0;
	end

	else if(instruction_id == 8'b00110100)			// ST(X) - i
    // 0	0	0	0	000	0	0	0	0
	begin
        pc_inc <= 1'b0;
        ireg_hold <= 1'b0;
        pc_overwrite <= 1'b0;
        gp_reg_write <= 1'b0;
        alu_sel <= 3'b000;
        use_carry <= 1'b0;
        status_reg_sel <= 1'b0;
        io_only_flag <= 1'b0;
        memory_write_en <= 1'b0;
        sp_write_enable <= 1'b0;
	end

	else if(instruction_id == 8'b00110101)			// ST(X) - ii
    // 0	0	0	0	000	0	0	0	0
	begin
        pc_inc <= 1'b0;
        ireg_hold <= 1'b0;
        pc_overwrite <= 1'b0;
        gp_reg_write <= 1'b0;
        alu_sel <= 3'b000;
        use_carry <= 1'b0;
        status_reg_sel <= 1'b0;
        io_only_flag <= 1'b0;
        memory_write_en <= 1'b0;
        sp_write_enable <= 1'b0;
	end

	else if(instruction_id == 8'b00110110)			// ST(X) - iii
    // 0	0	0	0	000	0	0	0	0
	begin
        pc_inc <= 1'b0;
        ireg_hold <= 1'b0;
        pc_overwrite <= 1'b0;
        gp_reg_write <= 1'b0;
        alu_sel <= 3'b000;
        use_carry <= 1'b0;
        status_reg_sel <= 1'b0;
        io_only_flag <= 1'b0;
        memory_write_en <= 1'b0;
        sp_write_enable <= 1'b0;
	end

	else if(instruction_id == 8'b00110111)			// ST (Y)
    // 0	0	0	0	000	0	0	0	0
	begin
        pc_inc <= 1'b0;
        ireg_hold <= 1'b0;
        pc_overwrite <= 1'b0;
        gp_reg_write <= 1'b0;
        alu_sel <= 3'b000;
        use_carry <= 1'b0;
        status_reg_sel <= 1'b0;
        io_only_flag <= 1'b0;
        memory_write_en <= 1'b0;
        sp_write_enable <= 1'b0;
	end

	else if(instruction_id == 8'b00111000)			// ST(Y) - i (2 cycles)
	begin
		if(clock_counter == 2'b00)
        begin
        // clock cycle 0
            pc_inc <= 1'b1;
            ireg_hold <= 1'b1;
            pc_overwrite <= 1'b0;
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b000;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b1;
            sp_write_enable <= 1'b0;
        end

        else if(clock_counter == 2'b01)
        begin
        // clock cycle 1  
            pc_inc <= 1'b0;
            ireg_hold <= 1'b0;
            pc_overwrite <= 1'b0;
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b000;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b0;
            sp_write_enable <= 1'b0;
        end

        else
        begin
            pc_inc <= 1'b0;
            ireg_hold <= 1'b0;
            pc_overwrite <= 1'b0;
            gp_reg_write <= 1'b0;
            alu_sel <= 3'b000;
            use_carry <= 1'b0;
            status_reg_sel <= 1'b0;
            io_only_flag <= 1'b0;
            memory_write_en <= 1'b0;
            sp_write_enable <= 1'b0;
        end
    end

	else if(instruction_id == 8'b00111001)			// ST(Y) - ii (2 cycles)
    // 0	0	0	0	000	0	0	0	0
	begin
        pc_inc <= 1'b0;
        ireg_hold <= 1'b0;
        pc_overwrite <= 1'b0;
        gp_reg_write <= 1'b0;
        alu_sel <= 3'b000;
        use_carry <= 1'b0;
        status_reg_sel <= 1'b0;
        io_only_flag <= 1'b0;
        memory_write_en <= 1'b0;
        sp_write_enable <= 1'b0;
	end

	else if(instruction_id == 8'b00111010)			// ST(Y) - iii
    // 0	0	0	0	000	0	0	0	0
	begin
        pc_inc <= 1'b0;
        ireg_hold <= 1'b0;
        pc_overwrite <= 1'b0;
        gp_reg_write <= 1'b0;
        alu_sel <= 3'b000;
        use_carry <= 1'b0;
        status_reg_sel <= 1'b0;
        io_only_flag <= 1'b0;
        memory_write_en <= 1'b0;
        sp_write_enable <= 1'b0;
	end

	else if(instruction_id == 8'b00111011)			// ST (Z)
    // 0	0	0	0	000	0	0	0	0
	begin
        pc_inc <= 1'b0;
        ireg_hold <= 1'b0;
        pc_overwrite <= 1'b0;
        gp_reg_write <= 1'b0;
        alu_sel <= 3'b000;
        use_carry <= 1'b0;
        status_reg_sel <= 1'b0;
        io_only_flag <= 1'b0;
        memory_write_en <= 1'b0;
        sp_write_enable <= 1'b0;
	end

	else if(instruction_id == 8'b00111100)			// ST(Z) - i
    // 0	0	0	0	000	0	0	0	0
	begin
        pc_inc <= 1'b0;
        ireg_hold <= 1'b0;
        pc_overwrite <= 1'b0;
        gp_reg_write <= 1'b0;
        alu_sel <= 3'b000;
        use_carry <= 1'b0;
        status_reg_sel <= 1'b0;
        io_only_flag <= 1'b0;
        memory_write_en <= 1'b0;
        sp_write_enable <= 1'b0;
	end

	else if(instruction_id == 8'b00111101)			// ST(Z) - ii
    // 0	0	0	0	000	0	0	0	0
	begin
        pc_inc <= 1'b0;
        ireg_hold <= 1'b0;
        pc_overwrite <= 1'b0;
        gp_reg_write <= 1'b0;
        alu_sel <= 3'b000;
        use_carry <= 1'b0;
        status_reg_sel <= 1'b0;
        io_only_flag <= 1'b0;
        memory_write_en <= 1'b0;
        sp_write_enable <= 1'b0;   
	end

	else if(instruction_id == 8'b00111110)			// ST(Z) - iii
    // 0	0	0	0	000	0	0	0	0
	begin
        pc_inc <= 1'b0;
        ireg_hold <= 1'b0;
        pc_overwrite <= 1'b0;
        gp_reg_write <= 1'b0;
        alu_sel <= 3'b000;
        use_carry <= 1'b0;
        status_reg_sel <= 1'b0;
        io_only_flag <= 1'b0;
        memory_write_en <= 1'b0;
        sp_write_enable <= 1'b0;
	end

	else if(instruction_id == 8'b00111111)			// STS (2 cycles)
    // 0	0	0	0	000	0	0	0	0
	begin
        pc_inc <= 1'b0;
        ireg_hold <= 1'b0;
        pc_overwrite <= 1'b0;
        gp_reg_write <= 1'b0;
        alu_sel <= 3'b000;
        use_carry <= 1'b0;
        status_reg_sel <= 1'b0;
        io_only_flag <= 1'b0;
        memory_write_en <= 1'b0;
        sp_write_enable <= 1'b0;
	end

	else if(instruction_id == 8'b01000000)			// SUB (1 cycle)
    // 1	0	0	1	001	0	0	0	0
	begin
        pc_inc <= 1'b1;
        ireg_hold <= 1'b0;
        pc_overwrite <= 1'b0;
        gp_reg_write <= 1'b1;
        alu_sel <= 3'b001;
        use_carry <= 1'b0;
        status_reg_sel <= 1'b0;
        io_only_flag <= 1'b0;
        memory_write_en <= 1'b0;
        sp_write_enable <= 1'b0;	
	end

	else if(instruction_id == 8'b01000001)			// SUBI
    // 1	0	0	1	001	0	0	0	0
	begin
        pc_inc <= 1'b1;
        ireg_hold <= 1'b0;
        pc_overwrite <= 1'b0;
        gp_reg_write <= 1'b1;
        alu_sel <= 3'b001;
        use_carry <= 1'b0;
        status_reg_sel <= 1'b0;
        io_only_flag <= 1'b0;
        memory_write_en <= 1'b0;	
        sp_write_enable <= 1'b0;	
	end

    else                                    // Catch All block                                                        
    // 0	0	0	0 000	0	0	0	0
	begin
        pc_inc <= 1'b0;
        ireg_hold <= 1'b0;
        pc_overwrite <= 1'b0;
        gp_reg_write <= 1'b0;
        alu_sel <= 3'b000;
        use_carry <= 1'b0;
        status_reg_sel <= 1'b0;
        io_only_flag <= 1'b0;
        memory_write_en <= 1'b0;
        sp_write_enable <= 1'b0;
	end
end

assign ALU_SEL = alu_sel;
assign PC_INC = pc_inc;
assign IREG_HOLD = ireg_hold;
assign PC_OVERWRITE = pc_overwrite;
assign GP_REG_WRITE = gp_reg_write;
assign USE_CARRY = use_carry;
assign STATUS_REG_SEL = status_reg_sel;
assign IO_ONLY_FLAG = io_only_flag;
assign MEMORY_WRITE_EN = memory_write_en;
assign SP_WRITE_ENABLE = sp_write_enable;
assign CLOCK_COUNTER = clock_counter;
assign instruction_decoder_part2 = 1'b0;
assign INTERRUPT_STAGE = interrupt_stage;

endmodule
