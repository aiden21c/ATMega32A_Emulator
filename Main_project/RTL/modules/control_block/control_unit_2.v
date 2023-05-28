module control_unit_2(
   input clk,
   input reset_n, 

   input [7:0] instruction_id,
   input [1:0] clock_counter,
   
   output LPM_enable
);

reg LPM_enable_reg;
assign LPM_enable = LPM_enable_reg;

always @(posedge(clk), negedge(reset_n)) begin
   if (reset_n == 1'b0) begin 
      LPM_enable_reg = 1'b0; 
   end
   else if(instruction_id == 8'b00000000)	begin 		// NOP
      LPM_enable_reg = 1'b0;
   end
   else if(instruction_id == 8'h22) begin 		// LPM
       if (clock_counter == 2'b00 || clock_counter == 2'b01) begin
          LPM_enable_reg = 1'b1;
       end
       else begin
          LPM_enable_reg = 1'b0;
       end
   end
   else begin
      LPM_enable_reg = 1'b0;
   end
end

endmodule