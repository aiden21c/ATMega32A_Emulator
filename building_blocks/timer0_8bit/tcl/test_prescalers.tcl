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
    run 100
    force -freeze rst_n 0
    run 100
    force -freeze rst_n 1
    run 100

	# # Run for 6000ns (No clock source)
    # force -freeze S	000
	# run 6000ns

	# # Run for 6000ns (No prescaling)
    # force -freeze S	001
	# run 6000ns
    
	# # Run for 6000ns (clk/8 from prescaler)
    # force -freeze S	010
	# run 6000ns

	# # Run for 6000ns (clk/64 from prescaler)
    # force -freeze S	011
	# run 6000ns

	# Run for 6000ns (clk/256 from prescaler)
    force -freeze S	100
	run 15000ns

	# # Run for 6000ns (clk/1024 from prescaler)
    # force -freeze S	101
	# run 20000ns
}

