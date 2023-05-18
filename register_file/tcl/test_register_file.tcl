proc runSim {} {
	# Clear the current simulation and add in all waveforms.
	restart -force -nowave
	add wave *

	# Set the radix of the buses.
	property wave -radix hex *

	# Generate the system clock (50MHz) that will be used for the simulation.
	force -deposit clock 1 0, 0 {10ns} -repeat 20000

    # Reset the system
    force -freeze clr_n 1
    run 50ns
    force -freeze clr_n 0
    run 50ns

    # Set up the simulation
    force -freeze clr_n 1
    force -freeze RA1 00000
    force -freeze RA2 00001
    force -freeze WA 00000
    force -freeze RegWrite 0
    force -freeze WD 11111111
    run 30ns

    # Read from register 2
    force -freeze RA2 00010
    run 30ns

    # Write to register 2
    force -freeze clr_n 1
    force -freeze RA1 00000
    force -freeze RA2 00001
    force -freeze WA 00010
    force -freeze RegWrite 1
    force -freeze WD 11111111
    run 30ns

    # Read from Register 2, write to register 1
    force -freeze clr_n 1
    force -freeze RA1 00000
    force -freeze RA2 00010
    force -freeze WA 00001
    force -freeze RegWrite 1
    force -freeze WD 11110000
    run 60ns

    # Read from Register 1, dont write to any register
    force -freeze clr_n 1
    force -freeze RA1 00000
    force -freeze RA2 00001
    force -freeze WA 00010
    force -freeze RegWrite 0
    force -freeze WD 11111111
    run 30ns
}