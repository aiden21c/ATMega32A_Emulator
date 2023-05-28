proc runSim {} {
   restart -force -nowave
   add wave *
   property wave -radix hex *

   force -deposit clk 1 0, 0 {100ns} -repeat 200ns 


   force -freeze reset_n 0
   run 200ns

   force -freeze reset_n 1

   run 4000ns 
}