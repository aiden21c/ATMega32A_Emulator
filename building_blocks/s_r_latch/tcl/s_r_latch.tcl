proc runSim { } {
    # Clear current sim and add all waveforms
    restart -force -nowave
    add wave *


    # Set the bys radix
    property wave -radix hex *

    # S = 0; R = 0; - Hold state
    force -freeze s 0
    force -freeze r 0
    run 100

    # S = 1; R = 1; - Invalid state (Hold)
    force -freeze s 1
    force -freeze r 1
    run 100

    # S = 0; R = 1; - Reset state
    force -freeze s 0
    force -freeze r 1
    run 100

    # S = 1; R = 0; - Set state
    force -freeze s 1
    force -freeze r 0
    run 100

    # S = 0; R = 0; - Hold state
    force -freeze s 0
    force -freeze r 0
    run 100

    # S = 1; R = 1; - Reset state
    force -freeze s 1
    force -freeze r 1
    run 100
}