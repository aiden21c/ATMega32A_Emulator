// EEET2162
// Parametised Counter
// N-bit Synchronous Counter without a count enable signal
// Author: Dr Glenn Matthews

module param_counter_noCEP(MR_n, clock50, Qn_out, TC_out);

parameter counterWidth = 1;
parameter startValue = 0;				// A start value for the clock to restart it's count cycle at

// Define the system inputs and outputs
input MR_n;									// Master reset
input clock50;								// System clock

output [counterWidth-1:0] Qn_out;	// Current count value
output TC_out;								// Count complete

// Arithmatic operations
reg [counterWidth-1:0] counterValue;

always @(posedge(clock50))
	begin
		// Reset characteristics
		if(MR_n == 1'b0)
			begin
				// Device is in reset state. Set counter to start value
				counterValue = startValue;
			end		
		else
			begin
				// The count is active, check its expiry
				if(counterValue == ((2**counterWidth) - 1'b1))
					begin
						counterValue = startValue;
					end
				else
					begin
						counterValue = counterValue + 1'b1;
					end
			end
	end

assign Qn_out = counterValue;				// Current count value
assign TC_out = &counterValue;			// Count complete

endmodule	
	
	