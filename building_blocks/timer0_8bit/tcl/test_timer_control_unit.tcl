proc runSim {} {
	# Clear the current simulation and add in all waveforms.
	restart -force -nowave
	add wave *

	# Set the radix of the buses.
	property wave -radix hex *

	# Generate the system clock (50MHz) that will be used for the simulation.
	force -deposit sysClock 1 0, 0 {10ns} -repeat 20000

    # Generate the count clock (6.25MHz) that will be used for the simulation.
    force -deposit countClock 1 0, 0 {80ns} -repeat 160000

    # Set up static variables for the simulation
    force -freeze TCNT_data 00000001
    force -freeze OCR_data 00100000
    force -freeze TCNT_write_enable 0

	# Run for 6000ns
	run 6000ns

    # Loading TCNT with a preload value
    force -freeze TCNT_data 00011011
    force -freeze OCR_data 11111111
    force -freeze TCNT_write_enable 1
    run 20000ns

    # Run for 6000ns
    force -freeze TCNT_write_enable 0
	run 6000ns


}

