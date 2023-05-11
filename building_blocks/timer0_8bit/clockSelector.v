// Select between the various prescaled clock sources for the ATMega32A
module clockSelector (
	input sysClock,
	input [2:0] S,
	input rst_n,
	output OUT
);

reg [11:0] divider = 0;			// The divider used to divide the clock speed
reg [11:0] counter = 0;			// The counter used to count up to the desired diviser

reg system_output = 1'b0;		// Reg used for the system output

always @(posedge (sysClock), negedge(rst_n))
	begin
		if(!rst_n)			// Set the output to no clock source if the system is in reset
			begin
				divider = 0;
			end
		else
			begin
				counter = counter + 1;			// Increment the counter on every toggle of the input clock
				if (counter == divider)								// If the counter has reached the divider value
					begin
						counter = 0;									// Reset the counter to 0
						system_output = system_output ^ 1;		// Toggle the output clock
					end		
				else
					begin
						system_output = system_output;			// Hold condition for the system output							
						counter = counter;							// Hold condition for the counter
					end	
			end
	end

always @(S)	
	begin		
		// No clock source
		if (S == 3'b000)
			begin
				divider = 0;
			end
		
		// clk (No prescaling)
		else if (S == 3'b001)
			begin
				divider = 1;
			end
		
		// clk/8 (From prescaler)
		else if (S == 3'b010)
			begin
				divider = 8/2;
			end
			
		// clk/64 (From prescaler)
		else if (S == 3'b011)
			begin
				divider = 64/2;
			end
			
		// clk/256 (From prescaler)
		else if (S == 3'b100)
			begin
				divider = 256/2;
			end
			
		// clk/1024 (From prescaler)
		else if (S == 3'b101)
			begin
				divider = 1024/2;
			end
		
		// Catch all
		else
			begin
				divider = 0;
			end
	end

assign OUT = system_output;

endmodule
