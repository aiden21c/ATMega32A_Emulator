proc runSim {} {
   restart -force -nowave
   add wave *
   property wave -radix hex *

   force -deposit clk 1 0, 0 {100ns} -repeat 200ns 

   force -freeze reset_n 0
   force -freeze mem_write 0
   force -freeze mem_data 0

   force -freeze arg1 0 
   force -freeze arg2 0
   force -freeze op 0
   force -freeze use_carry 0
   run 200ns

   force -freeze reset_n 1
   run 200ns
}