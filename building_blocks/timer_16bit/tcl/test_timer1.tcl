proc runSim {} {
	# Clear the current simulation and add in all waveforms.
	restart -force -nowave
	add wave *

	# Set the radix of the buses.
	property wave -radix hex *

	# Generate the system clock (50MHz) that will be used for the simulation.
	force -deposit sysClock 1 0, 0 {10ns} -repeat 20000

    # Reset the system
    force -freeze rst_n 1
    run 50ns
    force -freeze rst_n 0
    run 50ns

    # Set up static variables for the simulation
    force -freeze rst_n 1
    force -freeze clear_count 0
    force -freeze TCNT1H_input 00000001
    force -freeze TCNT1L_input 11111111
    force -freeze OCR1AH_input 00000001
    force -freeze OCR1AL_input 11111111
    force -freeze TCCR_input 00000001
    force -freeze TIMSK_input 00000000
    force -freeze TIFR_input 00000000
    # run 200ns
	

    # Write the data to the registers
    force -freeze TCNT_write_enable 0
    force -freeze TCCR_write_enable 1
    force -freeze OCR1_write_enable 1
    force -freeze OCR2_write_enable 1
    force -freeze TIFR_write_enable 1
    force -freeze TIMSK_write_enable 1
    run 200ns

    # Run in idle
    force -freeze TCNT_write_enable 0
    force -freeze TCCR_write_enable 0
    force -freeze OCR1_write_enable 0
    force -freeze OCR2_write_enable 0
    force -freeze TIFR_write_enable 0
    force -freeze TIMSK_write_enable 0
    run 50000ns

    # Testing clearing of the OCF bit
    force -freeze TIFR_input 00010000
    force -freeze TIFR_write_enable 1
    run 200ns
    force -freeze TIFR_write_enable 0
    run 20000ns

    force -freeze clear_count 1
    run 20000ns

}