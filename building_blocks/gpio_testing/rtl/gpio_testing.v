module gpio_testing(
	input rst_n, 
	input clock50,
	input [7:0] PINA_input_data,	// Data read into the PINA register
	input [7:0] PORTA_data,			// Data used to change the PORTA output
	
	output [7:0] GPIOB_port,		// Output of the PORTB register
	output [7:0] GPIOA_port			// Output of the PORTA register
);



// The clock to be used for the system
wire clock_100Hz;
parametised_counter #(18, 12143) counter (.MR_n(rst_n), .clock50(clock50), .Qn_out(), .clock(clock_100Hz));

wire [7:0] write_to_leds;
wire portB_wr_en;

wire [7:0] pinA_in;

gpio gpio(
	.clk(clock_100Hz), .clr_n(rst_n),
	
	// GPIOA inputs and outputs
	.DDRA_write_enable(),
	.DDRA_input_data(),
	
	.PORTA_write_enable(|(PORTA_data)),
	.PORTA_input_data(PORTA_data),
	
	.PINA_input_data(PINA_input_data),	

	.DDRA_output(DDRA_out),
	.PORTA_output(GPIOA_port),
	.PINA_output(pinA_in),
	
	// GPIOA inputs and outputs
	.DDRB_write_enable(),
	.DDRB_input_data(),
	
	.PORTB_write_enable(|(~pinA_in)),
	.PORTB_input_data(pinA_in),
	
	.PINB_input_data(),	

	.DDRB_output(),
	.PORTB_output(GPIOB_port),
	.PINB_output()
);

endmodule



