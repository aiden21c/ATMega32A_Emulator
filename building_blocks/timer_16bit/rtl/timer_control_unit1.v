module timer_control_unit1(
	input sysClock,					// The system clock
	input [7:0] TCNT1H_input,		// 8 bit input used to update the TCNT1 high register with a specified value
	input [7:0] TCNT1L_input,		// 8 bit input used to update the TCNT1 low register with a specified value
	input [7:0] OCR1AH_input,		// 8 bit input used to update the OCR1 register
	input [7:0] OCR1AL_input,		// 8 bit input used to update the OCR1 register
	
	input countClock,					// Clock signal used to count timer	
	input TCNT_write_enable,		// Input signal to specify whether the TCNT value should be written to with a preload
	
	output TIFR_write_enable,		// Output used to write to the TIFR register		
	output [7:0] TCNT1H_output,	// 8 bit high output for the TCNT register
	output [7:0] TCNT1L_output,	// 8 bit low output for the TCNT register
	output [7:0] TIFR_output		// 8 bit output for the TIFR register
);

reg [16:0] TCNT_write_data = 0;	// The value to be written to the TCNT register
reg [7:0] TIFR_write_data = 0;	// Data to be written to the TIFR register
reg TIFR_we;							// Reg for the write enable for the TIFR register

wire [15:0] TCNT_data = (TCNT1H_input << 8) | TCNT1L_input;
wire [15:0] OCR_data = (OCR1AH_input << 8) | OCR1AL_input;

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
				TIFR_write_data = TIFR_write_data | 8'b00001000;			// Set the OCF1 of the TIFR on successful compare with OCR
			end
		else if (TCNT_write_data == 16'b1111111111111111)
			begin
				TIFR_we = 1'b1;
				TIFR_write_data = TIFR_write_data | 8'b00000001;			// Set the TOV1 flag of the TIFR on overflow
			end		
		else
			begin
				TIFR_we = 1'b0;
				TIFR_write_data = TIFR_write_data;	
			end	
	end
	
assign TCNT1H_output = TCNT_write_data[15:8];
assign TCNT1L_output = TCNT_write_data[7:0];
assign TIFR_output = TIFR_write_data;
assign TIFR_write_enable = TIFR_we;
	
	
endmodule
