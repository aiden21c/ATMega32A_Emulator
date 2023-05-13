proc runSim {} {

	# Clear the current simulation and add in all waveforms.
	restart -force -nowave
	add wave *

	# Set the radix of the buses.
	property wave -radix hex *

	# Set the device into reset
	force -freeze MR_n 	0

	# Generate the system clock (50MHz) that will be used for the simulation.
	force -deposit clock50 1 0, 0 {10ns} -repeat 20ns

	# Run for 100ns
	run 100ns

	# Let the reset go
	force -freeze MR_n 	1

	# Run for 0.1 seconds
	run 12000000000ns



}

