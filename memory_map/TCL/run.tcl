proc test {} {
      restart -force -nowave
      add wave *
      property wave -radix hex *

      force -deposit clk 1 0, 0 {100ns} -repeat 200ns

      force -freeze WE 0
      force -freeze addr 0
      force -freeze data_in 0
      force -freeze register_bus 16#0
      force -freeze IO_bus 16#0
      force -freeze IO_only 0
      run 200ns

      force -freeze IO_bus 16#12345678
      run 200ns

      force -freeze IO_only 1
      run 400ns

      force -freeze addr 16#1
      run 400ns 
}