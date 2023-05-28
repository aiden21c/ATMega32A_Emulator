module stack_pointer(
    input clk,
    input clr_n,

    input [7:0]data_inH,
    input [7:0]data_inL,
    input WE_H,
    input WE_L,
    output [7:0]spH,
    output [7:0]spL,
    output [15:0]sp
);

wire [7:0]sp_high;
wire [7:0]sp_low;

d_flip_flop_multi_bit_en #(8, 0) stack_registerH (
	.d(data_inH), .clk(clk), .clr_n(clr_n), .enable(WE_H),
	.Q(sp_high), .Qn()
);

d_flip_flop_multi_bit_en #(8, 0) stack_registerL (
	.d(data_inL), .clk(clk), .clr_n(clr_n), .enable(WE_L),
	.Q(sp_low), .Qn()
);

assign spH = sp_high;
assign spL = sp_low;

assign sp = {
    sp_high,
    sp_low
};

endmodule