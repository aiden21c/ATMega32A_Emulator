module gpio (
	input clk,
	input clr_n,
	
	// GPIOA inputs and outputs
	input DDRA_write_enable,
	input [7:0] DDRA_input_data,
	
	input PORTA_write_enable,
	input [7:0] PORTA_input_data,
	
	input [7:0] PINA_input_data,	

	output [7:0] DDRA_output,
	output [7:0] PORTA_output,
	output [7:0] PINA_output,
	
	// GPIOA inputs and outputs
	input DDRB_write_enable,
	input [7:0] DDRB_input_data,
	
	input PORTB_write_enable,
	input [7:0] PORTB_input_data,
	
	input [7:0] PINB_input_data,	

	output [7:0] DDRB_output,
	output [7:0] PORTB_output,
	output [7:0] PINB_output
);

gpio_registers #(8, 8'b00001111) gpioA (
	.clk(clk), .clr_n(clr_n),
	
	.DDRx_write_enable(DDRA_write_enable), .PORTx_write_enable(PORTA_write_enable),
	.DDRx_input_data(DDRA_input_data), .PORTx_input_data(PORTA_input_data), .PINx_input_data(PINA_input_data),

	.DDRx_output(DDRA_output), .PORTx_output(PORTA_output), .PINx_output(PINA_output)
);

gpio_registers #(8, 8'b11111111) gpioB (
	.clk(clk), .clr_n(clr_n),
	
	.DDRx_write_enable(DDRB_write_enable), .PORTx_write_enable(PORTB_write_enable),
	.DDRx_input_data(DDRB_input_data), .PORTx_input_data(PORTB_input_data), .PINx_input_data(PINB_input_data),

	.DDRx_output(DDRB_output), .PORTx_output(PORTB_output), .PINx_output(PINB_output)
);

endmodule
