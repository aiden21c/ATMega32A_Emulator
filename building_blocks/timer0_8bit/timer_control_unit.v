module timer_control_unit(
	input sysClock,					// The system clock
	input [7:0] TCNT_data,			// 8 bit input used to update the TCNT0 register with a specified value
	input [7:0] OCR_data,			// 8 bit input used to update the OCR0 register

	input countClock,					// Clock signal used to count timer	
	input TCNT_write_enable,		// Input signal to specify whether the TCNT value should be written to with a preload
	
	output TIFR_write_enable,		// Output used to write to the TIFR register		
	output [7:0] TCNT_output,		// 8 bit output for the TCNT register
	output [7:0] TIFR_output		// 8 bit output for the TIFR register
);

reg [7:0] TCNT_write_data = 0;	// The value to be written to the TCNT register
reg [7:0] TIFR_write_data = 0;	// Data to be written to the TIFR register
reg TIFR_we;							// Reg for the write enable for the TIFR register

always @(posedge countClock)
	begin
		if(TCNT_write_enable == 1'b1)
			TCNT_write_data <= TCNT_data;									// If the enable is active, set the TCNT register to the input value
		else if(TCNT_write_data == OCR_data)
				TCNT_write_data = 0;											// Reset the clock counter on OCR match
		else
			TCNT_write_data <= TCNT_write_data + 1'b1;				// If write enable is deactive, increment the count by 1
	end
	
always @(TCNT_write_data)
	begin
		if (TCNT_write_data == OCR_data)
			begin
				TIFR_we = 1'b1;
				TIFR_write_data = TIFR_write_data | 8'b00000010;			// Set the OCF of the TIFR on successful compare with OCR
			end
		else if (TCNT_write_data == 8'b11111111)
			begin
				TIFR_we = 1'b1;
				TIFR_write_data = TIFR_write_data | 8'b00000001;			// Set the TOV flag of the TIFR on overflow
			end		
		else
			begin
				TIFR_we = 1'b0;
				TIFR_write_data = TIFR_write_data;	
			end	
	end
	
assign TCNT_output = TCNT_write_data;
assign TIFR_output = TIFR_write_data;
assign TIFR_write_enable = TIFR_we;
	
	
endmodule
