proc runSim {} {
	# Clear the current simulation and add in all waveforms.
	restart -force -nowave
	add wave *

	# Set the radix of the buses.
	property wave -radix hex *

    #  Set the values for each of the input signals
    force -freeze reg0_out 00000
    force -freeze reg1_out 00001
    force -freeze reg2_out 00010
    force -freeze reg3_out 00011
    force -freeze reg4_out 00100
    force -freeze reg5_out 00101
    force -freeze reg6_out 00110
    force -freeze reg7_out 00111
    force -freeze reg8_out 01000
    force -freeze reg9_out 01001
    force -freeze reg10_out 01010
    force -freeze reg11_out 01011
    force -freeze reg12_out 01100
    force -freeze reg13_out 01101
    force -freeze reg14_out 01110
    force -freeze reg15_out 01111
    force -freeze reg16_out 10000
    force -freeze reg17_out 10001
    force -freeze reg18_out 10010
    force -freeze reg19_out 10011
    force -freeze reg20_out 10100
    force -freeze reg21_out 10101
    force -freeze reg22_out 10110
    force -freeze reg23_out 10111
    force -freeze reg24_out 11000
    force -freeze reg25_out 11001
    force -freeze reg26_out 11010
    force -freeze reg27_out 11011
    force -freeze reg28_out 11100
    force -freeze reg29_out 11101
    force -freeze reg30_out 11110
    force -freeze reg31_out 11111

    # Test adjusting the selector input
    force -freeze S 00000
    run 10ns

    force -freeze S 00001
    run 10ns

    force -freeze S 00010
    run 10ns

    force -freeze S 00011
    run 10ns

    force -freeze S 00100
    run 10ns

    force -freeze S 00101
    run 10ns

    force -freeze S 00110
    run 10ns

    force -freeze S 00111
    run 10ns

    force -freeze S 01000
    run 10ns

    force -freeze S 01001
    run 10ns

    force -freeze S 01010
    run 10ns

    force -freeze S 01011
    run 10ns

    force -freeze S 01100
    run 10ns

    force -freeze S 01101
    run 10ns

    force -freeze S 01110
    run 10ns

    force -freeze S 01111
    run 10ns

    force -freeze S 10000
    run 10ns

    force -freeze S 10001
    run 10ns

    force -freeze S 10010
    run 10ns

    force -freeze S 10011
    run 10ns

    force -freeze S 10100
    run 10ns

    force -freeze S 10101
    run 10ns

    force -freeze S 10110
    run 10ns

    force -freeze S 10111
    run 10ns

    force -freeze S 11000
    run 10ns

    force -freeze S 11001
    run 10ns

    force -freeze S 11010
    run 10ns

    force -freeze S 11011
    run 10ns

    force -freeze S 11100
    run 10ns

    force -freeze S 11101
    run 10ns

    force -freeze S 11110
    run 10ns

    force -freeze S 11111
    run 10ns
}