module clockSelector (
	input sysClock,
	input S,
	output OUT
);

wire overflow;

reg divider;
reg out_reg = 0;
reg counter = 0;
reg clk_off = 1;

d_flip_flop_multi_bit #(1, 0) clkOut (.d(overflow), .clk(sysClock), .clr_n(), .Q(OUT), .Qn());

always @(posedge sysClock)
	begin
		counter = counter + 1;
		if (counter > divider)
				out_reg = 1;
		else
			out_reg = 0;
	end

always @(S)
	begin
		// No clock source
		if (S == 3'b000)
			begin
				divider = 0;
				clk_off = 1;
			end
		
		// clk (No prescaling)
		else if (S == 3'b001)
			begin
				divider = 1;
				clk_off = 0;
			end
		
		// clk/8 (From prescaler)
		else if (S == 3'b010)
			begin
				divider = 8;
				clk_off = 0;
			end
			
		// clk/64 (From prescaler)
		else if (S == 3'b011)
			begin
				divider = 64;
				clk_off = 0;
			end
			
		// clk/256 (From prescaler)
		else if (S == 3'b100)
			begin
				divider = 256;
				clk_off = 0;
			end
			
		// clk/1024 (From prescaler)
		else if (S == 3'b101)
			begin
				divider = 1024;
				clk_off = 0;
			end
		
		// Catch all
		else
			begin
				divider = 0;
				clk_off = 0;
			end
	end
		
assign overflow = out_reg & ~clk_off;


endmodule
