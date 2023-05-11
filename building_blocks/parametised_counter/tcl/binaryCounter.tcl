proc runSim {} {

	# Clear the current simulation and add in all waveforms.
	restart -force -nowave
	add wave *

	# Set the radix of the buses.
	property wave -radix hex *

	# Set the device into reset
	force -freeze MR_n 	0
	force -freeze CEP 	0
	force -freeze PE_n	1
	force -freeze Dn	4'b0000

	# Generate the system clock (50MHz) that will be used for the simulation.
	force -deposit clock50 1 0, 0 {10ns} -repeat 20000

	# Run for 100ns
	run 100000

	# Let the reset go and clock for 100 ns
	force -freeze MR_n 	1
	run 100000

	# Bring the count enable high.
	force -freeze CEP 	1

	# Run for 1000ns
	run 1000000

	# Bring the count enable low.
	force -freeze CEP 	0

	# Run for 1000ns
	run 1000000

}

