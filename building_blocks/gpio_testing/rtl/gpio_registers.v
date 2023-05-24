module gpio_registers #(parameter WIDTH = 1, parameter DDRx_default = 0) (
	clk, clr_n,
	
	DDRx_write_enable, PORTx_write_enable,
	DDRx_input_data, PORTx_input_data, PINx_input_data,

	DDRx_output, PORTx_output, PINx_output
);

// Define I/O
input clk; input clr_n;

input DDRx_write_enable; input PORTx_write_enable;

input [WIDTH-1:0] DDRx_input_data;
input [WIDTH-1:0] PORTx_input_data;
input [WIDTH-1:0] PINx_input_data;

output [WIDTH-1:0] DDRx_output;
output [WIDTH-1:0] PORTx_output;
output [WIDTH-1:0] PINx_output;

// Wire connecting the multiplexer to the DDRx register
wire [WIDTH-1:0] DDRx_input_wire;

// Multiplexer used to select whether to retain current value or override with new value
multi_bit_multiplexer_2way #(WIDTH) DDRx_input_selector (.A(DDRx_output), .B(DDRx_input_data), .S(DDRx_write_enable), .out(DDRx_input_wire));

// The data direction regsiter. Default bits the entire register as input pins
d_flip_flop_multi_bit #(WIDTH, DDRx_default) DDRx (.d(DDRx_input_wire), .clk(clk), .clr_n(clr_n), .Q(DDRx_output), .Qn());

// Wire connecting the multiplexer to the PORTx register
wire [WIDTH-1:0] PORTx_input_wire;

// Multiplexer used to select whether to retain current value or override with new value
multi_bit_multiplexer_2way #(WIDTH) PORTx_input_selector (.A(PORTx_output), .B(PORTx_input_data & DDRx_output), .S(PORTx_write_enable), .out(PORTx_input_wire));

// The PORT (output) regsiter
d_flip_flop_multi_bit #(WIDTH, DDRx_default) PORTx (.d(PORTx_input_wire), .clk(clk), .clr_n(clr_n), .Q(PORTx_output), .Qn());

// The PIN (input) register
d_flip_flop_multi_bit #(WIDTH, DDRx_default) PINx (.d((PINx_input_data & ~(DDRx_output)) | (PORTx_output & DDRx_output)), .clk(clk), .clr_n(clr_n), .Q(PINx_output), .Qn());

endmodule
