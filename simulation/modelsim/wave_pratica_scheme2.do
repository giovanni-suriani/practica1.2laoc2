onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix decimal /hierarquia_memoria/clock
add wave -noupdate -radix decimal /hierarquia_memoria/wren
add wave -noupdate -radix decimal /hierarquia_memoria/read
add wave -noupdate -radix decimal /hierarquia_memoria/clock
add wave -noupdate -radix decimal /hierarquia_memoria/mem_clock
add wave -noupdate -radix decimal /hierarquia_memoria/read
add wave -noupdate -radix decimal /hierarquia_memoria/address
add wave -noupdate -radix decimal /hierarquia_memoria/hit_L1
add wave -noupdate -radix decimal /hierarquia_memoria/hit_L2
add wave -noupdate -radix decimal /hierarquia_memoria/read_data
add wave -noupdate -radix decimal /hierarquia_memoria/wren
add wave -noupdate -radix decimal /hierarquia_memoria/L1_data
add wave -noupdate -radix decimal /hierarquia_memoria/L1_dirty
add wave -noupdate -radix decimal /hierarquia_memoria/L1_lru
add wave -noupdate -radix decimal /hierarquia_memoria/L1_tag
add wave -noupdate -radix decimal /hierarquia_memoria/L1_valid
add wave -noupdate -radix decimal /hierarquia_memoria/L2_data
add wave -noupdate -radix decimal /hierarquia_memoria/L2_dirty
add wave -noupdate -radix decimal /hierarquia_memoria/L2_tag
add wave -noupdate -radix decimal /hierarquia_memoria/L2_valid
add wave -noupdate -radix decimal /hierarquia_memoria/wire_read_data
add wave -noupdate -radix decimal /hierarquia_memoria/tag
add wave -noupdate -radix decimal /hierarquia_memoria/address
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {54 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 280
configure wave -valuecolwidth 227
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
configure wave -timelineunits ps
update
WaveRestoreZoom {45 ps} {61 ps}
view wave 
wave clipboard store
wave create -driver freeze -pattern clock -initialvalue 0 -period 10000ps -dutycycle 50 -starttime 0ps -endtime 1000ps sim:/memoram/clock 
wave create -driver freeze -pattern clock -initialvalue 0 -period 100ps -dutycycle 50 -starttime 0ps -endtime 100000ps sim:/hierarquia_memoria/clock 
wave create -pattern clock -initialvalue 1 -period 100ps -dutycycle 50 -starttime 0ps -endtime 1000ps sim:/hierarquia_memoria/mem_clock 
wave create -pattern constant -value 1 -starttime 0ps -endtime 10000ps sim:/hierarquia_memoria/wren 
wave create -driver freeze -pattern constant -value 1 -starttime 0ps -endtime 1000ps sim:/hierarquia_memoria/read 
wave create -driver freeze -pattern constant -value 0 -range 15 0 -starttime 0ps -endtime 10000ps sim:/hierarquia_memoria/address 
wave create -driver freeze -pattern clock -initialvalue 0 -period 10000ps -dutycycle 50 -starttime 0ps -endtime 1000ps sim:/memoram/clock 
wave create -driver freeze -pattern clock -initialvalue 0 -period 100ps -dutycycle 50 -starttime 0ps -endtime 100000ps sim:/hierarquia_memoria/clock 
wave create -pattern clock -initialvalue 1 -period 100ps -dutycycle 50 -starttime 0ps -endtime 1000ps sim:/hierarquia_memoria/mem_clock 
wave create -pattern constant -value 1 -starttime 0ps -endtime 10000ps sim:/hierarquia_memoria/wren 
wave create -driver freeze -pattern constant -value 1 -starttime 0ps -endtime 1000ps sim:/hierarquia_memoria/read 
wave create -driver freeze -pattern constant -value 0 -range 15 0 -starttime 0ps -endtime 10000ps sim:/hierarquia_memoria/address 
wave modify -driver freeze -pattern constant -value 0000000000000001 -range 15 0 -starttime 0ps -endtime 10000ps Edit:/hierarquia_memoria/address 
wave create -driver freeze -pattern clock -initialvalue 0 -period 10000ps -dutycycle 50 -starttime 0ps -endtime 1000ps sim:/memoram/clock 
wave create -driver freeze -pattern clock -initialvalue 0 -period 100ps -dutycycle 50 -starttime 0ps -endtime 100000ps sim:/hierarquia_memoria/clock 
wave create -pattern clock -initialvalue 1 -period 100ps -dutycycle 50 -starttime 0ps -endtime 1000ps sim:/hierarquia_memoria/mem_clock 
wave create -pattern constant -value 1 -starttime 0ps -endtime 10000ps sim:/hierarquia_memoria/wren 
wave create -driver freeze -pattern constant -value 1 -starttime 0ps -endtime 1000ps sim:/hierarquia_memoria/read 
wave create -driver freeze -pattern constant -value 0 -range 15 0 -starttime 0ps -endtime 10000ps sim:/hierarquia_memoria/address 
WaveExpandAll -1
wave modify -driver freeze -pattern constant -value 0000000000000001 -range 15 0 -starttime 0ps -endtime 10000ps Edit:/hierarquia_memoria/address 
WaveCollapseAll -1
wave clipboard restore
