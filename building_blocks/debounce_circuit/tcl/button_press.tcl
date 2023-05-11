proc runSim {} {

	# Clear the current simulation and add in all waveforms.
	restart -force -nowave
	add wave *

	# Set the radix of the buses.
	property wave -radix hex *

	# Set the device into reset
	force -freeze reset_n	0
	force -freeze buttonSignal	0

	# Generate the system clock (50MHz) that will be used for the simulation.
	force -deposit clock50M 1 0, 0 {10ns} -repeat 20000

	# Run for 100ns
	run 100

	# Let the reset go and clock for 0.1 ns
	force -freeze reset_n 	1
	run 100000000ns

	# Simulate a button press with bounce
	force -freeze buttonSignal	1
	run 2000000ns
	force -freeze buttonSignal	0
	run 200000ns
	force -freeze buttonSignal	1
	run 100000ns
	force -freeze buttonSignal	0
	run 15500000ns
	force -freeze buttonSignal	1
	run 26000000ns

	# Release button and run for 0.5 second
	force -freeze buttonSignal	0
	run 26000000ns

	# Simulate a button press with bounce
	force -freeze buttonSignal	1
	run 2000000ns
	force -freeze buttonSignal	0
	run 200000ns
	force -freeze buttonSignal	1
	run 100000ns
	force -freeze buttonSignal	0
	run 15500000ns
	force -freeze buttonSignal	1
	run 26000000ns

	# Run idle
	run 46000000ns

	# Release button and run for 0.5 second
	force -freeze buttonSignal	0
	run 26000000ns

}

