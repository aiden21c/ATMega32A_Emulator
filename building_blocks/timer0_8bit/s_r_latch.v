module s_r_latch(
	input s, r,
	output Q, Q_n
);

reg q = 0;												// Initialise q to 0 as a known state of reset

always @(s, r)
	begin				
		if ((s == 1'b1) && (r == 1'b1))			// SR = 11 (Q=1)
			begin
				q <= 1'b1;
			end
		else if ((s == 1'b0) && (r == 1'b0))	// SR = 00 (Hold)
			begin
				q <= q;
			end	
	
		else if((s == 1'b1) && (r == 1'b0))		// SR = 10 (Hold)
			begin
				q <= q;
			end
		else if((s == 1'b0) && (r == 1'b1))		// SR = 10 (Q=0)
			begin
				q <= 0;
			end
	end
	
assign Q = q;
assign Q_n = !q;

endmodule
