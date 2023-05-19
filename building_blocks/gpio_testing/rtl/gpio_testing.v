module gpio_testing(
	input rst_n, 
	input clock50,
	input [7:0] PINA_input_data,
	input [7:0] PORTA_data,
	
	output [7:0] GPIOB_port,
	output [7:0] GPIOA_port
);

// The clock to be used for the system
wire clock_100Hz;
parametised_counter #(18, 12143) counter (.MR_n(!rst_n), .clock50(clock50), .Qn_out(), .clock(clock_100Hz));

wire [7:0] write_to_leds;
wire portB_wr_en;

wire pinA_in;

gpio gpio(
	.clk(clock_100Hz), .clr_n(!rst_n),
	
	// GPIOA inputs and outputs
	.DDRA_write_enable(),
	.DDRA_input_data(),
	
	.PORTA_write_enable(|(PORTA_data)),
	.PORTA_input_data(PORTA_data),
	
	.PINA_input_data(PINA_input_data),	

	.DDRA_output(),
	.PORTA_output(GPIOA_port),
	.PINA_output(pinA_in),
	
	// GPIOA inputs and outputs
	.DDRB_write_enable(),
	.DDRB_input_data(),
	
	.PORTB_write_enable(portB_wr_en),
	.PORTB_input_data(write_to_leds),
	
	.PINB_input_data(),	

	.DDRB_output(),
	.PORTB_output(GPIOB_port),
	.PINB_output()
);


reg [7:0] pB_write;
reg pb_wr_en;

always @(GPIOA_port, pinA_in)
	begin
		if(pinA_in == 8'b11100000)
			begin
				if(GPIOA_port == 8'b00001110)
					begin
						pB_write = 8'b00001101;
						pb_wr_en = 1;
					end
			end
//		else if()
//		else if()
//		else if()
		
		else
			begin
				pB_write = 8'b10101010;
				pb_wr_en = 1;
			end
		
		
	end


assign write_to_leds = pB_write;
assign portB_wr_en = pb_wr_en;

endmodule
