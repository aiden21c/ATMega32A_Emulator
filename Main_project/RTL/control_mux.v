module control_mux(
   input clk,
   input reset_n, 

   input [7:0] instruction_id,
   input [1:0] clock_counter,
   input [1:0] interrupt_stage,
   
   output reg SP_inL_sel,
   output reg [2:0] MM_addr_sel,
   output reg [1:0] MM_data_sel,
   output reg [1:0] PM_PC_new_sel,
   output reg [1:0] ALU_arg2_sel,
   output reg ALU_arg1_sel,
   output reg RF_WA_sel,
   output reg [2:0] RF_WD_sel
);

// SP_inL_sel
always @(*) 
begin
   if (reset_n == 1'b0) SP_inL_sel <= 1'b0; 
   else if(instruction_id == 8'h29 || instruction_id == 8'h38) SP_inL_sel <= 1'b1;
   else SP_inL_sel <= 1'b0;
end

// MM_addr_sel
always @(*) 
begin
   // 0 = Y reg - for LD/ST
   // 1 = decoder arg2 - for IN/OUT
   // 2 = SP - for PUSH
   // 3 = SP from ALU for pre inc for POP
   // 4 - SREG address for CLI & SEI
   if (reset_n == 1'b0) MM_addr_sel <= 3'b0; 
   else if(instruction_id == 8'h19 || instruction_id == 8'h38) MM_addr_sel <= 3'b0; // LD and ST
   else if (instruction_id == 8'h11 || instruction_id == 8'h29) MM_addr_sel <= 3'h1; // IN and OUT
   else if (instruction_id == 8'h2B) MM_addr_sel <= 3'h2; // PUSH
   else if (instruction_id == 8'h2A) MM_addr_sel <= 3'h3; // POP
   else if (instruction_id == 8'h0A || instruction_id == 8'h32) MM_addr_sel <= 3'h4; // CLI and SEI
   else MM_addr_sel <= 3'b0;
end

// MM_data_sel
always @(*) 
begin
   // 0 = RD1 - for LD/ST and OUT
   // 1 = PC_low - for rcall and interrupt
   // 2 = PC_high - for rcall and interrupt 
   // 3 = SREG - inverted I for CLI and SEI
   if (reset_n == 1'b0) MM_data_sel <= 2'b00; 
   else if (instruction_id == 8'h2C || interrupt_stage > 2'b0) begin
      if (clock_counter == 2'b10 || interrupt_stage == 2'b10) MM_data_sel <= 2'b01; 
      else if (clock_counter == 2'b01 || interrupt_stage == 2'b01) MM_data_sel <= 2'b10; 
      else MM_data_sel <= 2'b00;
   end
   else if (instruction_id == 8'h32 || instruction_id == 8'h0A) MM_data_sel <= 2'b11; 
   else MM_data_sel <= 2'b00;
end

// PM_PC_new_sel
always @(*) 
begin
   // 0 = interrupt - set in last interrupt stage 
   // 1 = decoder arg1 - for branches 
   // 2 = 12 bit arg - for rcall/rjmp 
   if (reset_n == 1'b0) PM_PC_new_sel <= 2'b00; 
   else if (interrupt_stage == 2'b11) PM_PC_new_sel <= 2'b00; 
   else if ((instruction_id >= 8'h4) && (instruction_id <= 8'h8)) PM_PC_new_sel <= 2'b01;
   else if (instruction_id == 8'h2C || instruction_id == 8'h2F) PM_PC_new_sel <= 2'b10;
   else PM_PC_new_sel <= 2'b00;  
end

// ALU_arg2_sel
always @(*) 
begin
   // 0 = RD2 
   // 1 = arg 2 decoder - for subi and cpi
   // 2 = 1 value // for push/pop/inc/dec/ rcall/ ret/ reti 
   if (reset_n == 1'b0) ALU_arg2_sel <= 2'b00;
   else if (instruction_id == 8'hD || instruction_id == 8'h41) ALU_arg2_sel <= 2'b01; 
   else if (instruction_id == 8'h2B || instruction_id == 8'h2C || instruction_id == 8'h12 || instruction_id == 8'hF || 
      (instruction_id == 8'h2C && (clock_counter == 2'b01 || clock_counter == 2'b10)) || ((instruction_id == 8'h2D || instruction_id == 8'h2E) && clock_counter <= 2'b10)
   ) ALU_arg2_sel <= 2'b10;
   else ALU_arg2_sel <= 2'b00;  
end

// ALU_arg1_sel
always @(*) 
begin
   // 0 = RD1
   // 1 = SPL - for push/pop/rcall/ret/reti
   if (reset_n == 1'b0) ALU_arg1_sel <= 1'b0; 
   else if (instruction_id == 8'h2B || instruction_id == 8'h2C || instruction_id == 8'h2D || instruction_id == 8'h2E || instruction_id == 8'h2C) ALU_arg1_sel <= 1'b1;
   else ALU_arg1_sel = 1'b0;  
end

// RF_WA_sel
always @(*) 
begin
   // 0 = arg1 decoder 
   // 1 = MM address // for LD/ST
   if (reset_n == 1'b0) RF_WA_sel = 1'b0;
   else if (instruction_id == 8'h19 || instruction_id == 8'h38) RF_WA_sel = 1'b1;
   else RF_WA_sel = 1'b0;
end

// RF_WD_sel
always @(*) 
begin
   // 0 = ALU output
   // 1 = MM data // for ST
   // 2 = arg2 decoder for ldi 
   // 3 = PM LPM - for lpm
   // 4 = MM Q for LD 
   if (reset_n == 1'b0) RF_WD_sel <= 3'b000;
   else if (instruction_id == 8'h38) RF_WD_sel = 3'b001;
   else if (instruction_id == 8'h20) RF_WD_sel = 3'b010;
   else if (instruction_id == 8'h22) RF_WD_sel = 3'b011;
   else if (instruction_id == 8'h19) RF_WD_sel = 3'b100;
   else RF_WD_sel <= 3'b000;   
end

endmodule