onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clock /hierarquia_memoria/clock
add wave -noupdate -label read /hierarquia_memoria/read
add wave -noupdate -label address /hierarquia_memoria/address
add wave -noupdate -label mem_clock /hierarquia_memoria/mem_clock
add wave -noupdate -label hit_l1 /hierarquia_memoria/hit_L1
add wave -noupdate -label read_data /hierarquia_memoria/read_data
add wave -noupdate -label wire_read_data /hierarquia_memoria/wire_read_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {146 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 220
configure wave -valuecolwidth 302
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {2664 ps}
view wave 
wave clipboard store
wave create -driver freeze -pattern clock -initialvalue HiZ -period 100ps -dutycycle 50 -starttime 0ps -endtime 10000ps sim:/hierarquia_memoria/clock 
wave create -driver freeze -pattern constant -value 1 -starttime 0ps -endtime 100ps sim:/hierarquia_memoria/reset 
wave create -driver freeze -pattern constant -value 0 -range 15 0 -starttime 0ps -endtime 100ps sim:/hierarquia_memoria/address 
wave create -driver freeze -pattern constant -value 00 -range 15 0 -starttime 0ps -endtime 1000ps sim:/hierarquia_memoria/address 
wave create -driver freeze -pattern constant -value 0000 -range 15 0 -starttime 0ps -endtime 1000ps sim:/hierarquia_memoria/address 
wave create -driver freeze -pattern constant -value 000000000000 -range 15 0 -starttime 0ps -endtime 1000ps sim:/hierarquia_memoria/address 
wave create -driver expectedOutput -pattern constant -value 1 -range 15 0 -starttime 0ps -endtime 1000ps sim:/hierarquia_memoria/read_data 
wave create -driver freeze -pattern constant -value 1 -range 15 0 -starttime 0ps -endtime 1000ps sim:/hierarquia_memoria/address 
wave create -driver freeze -pattern constant -value 1 -range 15 0 -starttime 0ps -endtime 1000ps sim:/hierarquia_memoria/address 
wave create -driver expectedOutput -pattern constant -value 1 -range 15 0 -starttime 0ps -endtime 1000ps sim:/hierarquia_memoria/read_data 
wave create -driver freeze -pattern constant -value 0000000000000000 -range 15 0 -starttime 0ps -endtime 1000ps sim:/hierarquia_memoria/address 
wave create -driver freeze -pattern constant -value 1 -starttime 0ps -endtime 1000ps sim:/hierarquia_memoria/read 
wave create -driver freeze -pattern constant -value 0000000000000001 -range 15 0 -starttime 0ps -endtime 1000ps sim:/hierarquia_memoria/address 
wave create -driver freeze -pattern clock -initialvalue 0 -period 100ps -dutycycle 50 -starttime 0ps -endtime 1000ps sim:/hierarquia_memoria/clock 
wave create -driver freeze -pattern constant -value 1 -starttime 0ps -endtime 100ps sim:/hierarquia_memoria/reset 
wave create -driver freeze -pattern constant -value 000000000001 -range 15 0 -starttime 0ps -endtime 10000ps sim:/hierarquia_memoria/address 
wave create -driver freeze -pattern constant -value 0000000000000001 -range 15 0 -starttime 0ps -endtime 10000ps sim:/hierarquia_memoria/address 
WaveExpandAll -1
wave create -driver freeze -pattern constant -value 1 -starttime 0ps -endtime 10000ps sim:/hierarquia_memoria/read 
WaveCollapseAll -1
wave clipboard restore
