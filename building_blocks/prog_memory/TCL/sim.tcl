proc runSim {} {
   restart -force -nowave
   add wave *
   property wave -radix hex *

   force -deposit clk 1 0, 0 {100ns} -repeat 200ns 


   force -freeze reset_n 0
   force -freeze PC_overwrite 0
   force -freeze PC_new 0
   force -freeze PC_inc 1
   force -freeze hold 0 

   run 200ns

   force -freeze reset_n 1

   run 4000ns 
}