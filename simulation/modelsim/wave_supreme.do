onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /hierarquia_memoria/clock
add wave -noupdate -radix unsigned /hierarquia_memoria/read
add wave -noupdate -radix unsigned -childformat {{{/hierarquia_memoria/address[15]} -radix decimal} {{/hierarquia_memoria/address[14]} -radix decimal} {{/hierarquia_memoria/address[13]} -radix decimal} {{/hierarquia_memoria/address[12]} -radix decimal} {{/hierarquia_memoria/address[11]} -radix decimal} {{/hierarquia_memoria/address[10]} -radix decimal} {{/hierarquia_memoria/address[9]} -radix decimal} {{/hierarquia_memoria/address[8]} -radix decimal} {{/hierarquia_memoria/address[7]} -radix decimal} {{/hierarquia_memoria/address[6]} -radix decimal} {{/hierarquia_memoria/address[5]} -radix decimal} {{/hierarquia_memoria/address[4]} -radix decimal} {{/hierarquia_memoria/address[3]} -radix decimal} {{/hierarquia_memoria/address[2]} -radix decimal} {{/hierarquia_memoria/address[1]} -radix decimal} {{/hierarquia_memoria/address[0]} -radix decimal}} -subitemconfig {{/hierarquia_memoria/address[15]} {-height 15 -radix decimal} {/hierarquia_memoria/address[14]} {-height 15 -radix decimal} {/hierarquia_memoria/address[13]} {-height 15 -radix decimal} {/hierarquia_memoria/address[12]} {-height 15 -radix decimal} {/hierarquia_memoria/address[11]} {-height 15 -radix decimal} {/hierarquia_memoria/address[10]} {-height 15 -radix decimal} {/hierarquia_memoria/address[9]} {-height 15 -radix decimal} {/hierarquia_memoria/address[8]} {-height 15 -radix decimal} {/hierarquia_memoria/address[7]} {-height 15 -radix decimal} {/hierarquia_memoria/address[6]} {-height 15 -radix decimal} {/hierarquia_memoria/address[5]} {-height 15 -radix decimal} {/hierarquia_memoria/address[4]} {-height 15 -radix decimal} {/hierarquia_memoria/address[3]} {-height 15 -radix decimal} {/hierarquia_memoria/address[2]} {-height 15 -radix decimal} {/hierarquia_memoria/address[1]} {-height 15 -radix decimal} {/hierarquia_memoria/address[0]} {-height 15 -radix decimal}} /hierarquia_memoria/address
add wave -noupdate -radix unsigned /hierarquia_memoria/wren
add wave -noupdate -radix unsigned -childformat {{{/hierarquia_memoria/address[15]} -radix decimal} {{/hierarquia_memoria/address[14]} -radix decimal} {{/hierarquia_memoria/address[13]} -radix decimal} {{/hierarquia_memoria/address[12]} -radix decimal} {{/hierarquia_memoria/address[11]} -radix decimal} {{/hierarquia_memoria/address[10]} -radix decimal} {{/hierarquia_memoria/address[9]} -radix decimal} {{/hierarquia_memoria/address[8]} -radix decimal} {{/hierarquia_memoria/address[7]} -radix decimal} {{/hierarquia_memoria/address[6]} -radix decimal} {{/hierarquia_memoria/address[5]} -radix decimal} {{/hierarquia_memoria/address[4]} -radix decimal} {{/hierarquia_memoria/address[3]} -radix decimal} {{/hierarquia_memoria/address[2]} -radix decimal} {{/hierarquia_memoria/address[1]} -radix decimal} {{/hierarquia_memoria/address[0]} -radix decimal}} -subitemconfig {{/hierarquia_memoria/address[15]} {-height 15 -radix decimal} {/hierarquia_memoria/address[14]} {-height 15 -radix decimal} {/hierarquia_memoria/address[13]} {-height 15 -radix decimal} {/hierarquia_memoria/address[12]} {-height 15 -radix decimal} {/hierarquia_memoria/address[11]} {-height 15 -radix decimal} {/hierarquia_memoria/address[10]} {-height 15 -radix decimal} {/hierarquia_memoria/address[9]} {-height 15 -radix decimal} {/hierarquia_memoria/address[8]} {-height 15 -radix decimal} {/hierarquia_memoria/address[7]} {-height 15 -radix decimal} {/hierarquia_memoria/address[6]} {-height 15 -radix decimal} {/hierarquia_memoria/address[5]} {-height 15 -radix decimal} {/hierarquia_memoria/address[4]} {-height 15 -radix decimal} {/hierarquia_memoria/address[3]} {-height 15 -radix decimal} {/hierarquia_memoria/address[2]} {-height 15 -radix decimal} {/hierarquia_memoria/address[1]} {-height 15 -radix decimal} {/hierarquia_memoria/address[0]} {-height 15 -radix decimal}} /hierarquia_memoria/address
add wave -noupdate -radix unsigned /hierarquia_memoria/wren
add wave -noupdate -radix unsigned /hierarquia_memoria/mem_clock
add wave -noupdate -radix unsigned /hierarquia_memoria/hit_L1
add wave -noupdate -radix unsigned /hierarquia_memoria/hit_L2
add wave -noupdate -radix unsigned -childformat {{{/hierarquia_memoria/read_data[15]} -radix decimal} {{/hierarquia_memoria/read_data[14]} -radix decimal} {{/hierarquia_memoria/read_data[13]} -radix decimal} {{/hierarquia_memoria/read_data[12]} -radix decimal} {{/hierarquia_memoria/read_data[11]} -radix decimal} {{/hierarquia_memoria/read_data[10]} -radix decimal} {{/hierarquia_memoria/read_data[9]} -radix decimal} {{/hierarquia_memoria/read_data[8]} -radix decimal} {{/hierarquia_memoria/read_data[7]} -radix decimal} {{/hierarquia_memoria/read_data[6]} -radix decimal} {{/hierarquia_memoria/read_data[5]} -radix decimal} {{/hierarquia_memoria/read_data[4]} -radix decimal} {{/hierarquia_memoria/read_data[3]} -radix decimal} {{/hierarquia_memoria/read_data[2]} -radix decimal} {{/hierarquia_memoria/read_data[1]} -radix decimal} {{/hierarquia_memoria/read_data[0]} -radix decimal}} -subitemconfig {{/hierarquia_memoria/read_data[15]} {-height 15 -radix decimal} {/hierarquia_memoria/read_data[14]} {-height 15 -radix decimal} {/hierarquia_memoria/read_data[13]} {-height 15 -radix decimal} {/hierarquia_memoria/read_data[12]} {-height 15 -radix decimal} {/hierarquia_memoria/read_data[11]} {-height 15 -radix decimal} {/hierarquia_memoria/read_data[10]} {-height 15 -radix decimal} {/hierarquia_memoria/read_data[9]} {-height 15 -radix decimal} {/hierarquia_memoria/read_data[8]} {-height 15 -radix decimal} {/hierarquia_memoria/read_data[7]} {-height 15 -radix decimal} {/hierarquia_memoria/read_data[6]} {-height 15 -radix decimal} {/hierarquia_memoria/read_data[5]} {-height 15 -radix decimal} {/hierarquia_memoria/read_data[4]} {-height 15 -radix decimal} {/hierarquia_memoria/read_data[3]} {-height 15 -radix decimal} {/hierarquia_memoria/read_data[2]} {-height 15 -radix decimal} {/hierarquia_memoria/read_data[1]} {-height 15 -radix decimal} {/hierarquia_memoria/read_data[0]} {-height 15 -radix decimal}} /hierarquia_memoria/read_data
add wave -noupdate -radix unsigned /hierarquia_memoria/wire_read_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {88 ps} 0}
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
WaveRestoreZoom {0 ps} {288 ps}
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
WaveExpandAll -1
wave modify -driver freeze -pattern constant -value 0000000000000001 -range 15 0 -starttime 0ps -endtime 10000ps Edit:/hierarquia_memoria/address 
wave modify -driver freeze -pattern constant -value 0000000000000001 -range 15 0 -starttime 0ps -endtime 10000ps Edit:/hierarquia_memoria/address 
WaveCollapseAll -1
wave clipboard restore
