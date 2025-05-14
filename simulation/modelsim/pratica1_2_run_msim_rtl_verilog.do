transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/talco/Desktop/LAOC2-REPO/pratica1.2_Giovanni_Thalles {C:/Users/talco/Desktop/LAOC2-REPO/pratica1.2_Giovanni_Thalles/hierarquia_memoria.v}
vlog -vlog01compat -work work +incdir+C:/Users/talco/Desktop/LAOC2-REPO/pratica1.2_Giovanni_Thalles {C:/Users/talco/Desktop/LAOC2-REPO/pratica1.2_Giovanni_Thalles/memoram.v}
vlog -vlog01compat -work work +incdir+C:/Users/talco/Desktop/LAOC2-REPO/pratica1.2_Giovanni_Thalles {C:/Users/talco/Desktop/LAOC2-REPO/pratica1.2_Giovanni_Thalles/display.v}
vlog -vlog01compat -work work +incdir+C:/Users/talco/Desktop/LAOC2-REPO/pratica1.2_Giovanni_Thalles {C:/Users/talco/Desktop/LAOC2-REPO/pratica1.2_Giovanni_Thalles/pratica1_2.v}

vlog -vlog01compat -work work +incdir+C:/Users/talco/Desktop/LAOC2-REPO/pratica1.2_Giovanni_Thalles {C:/Users/talco/Desktop/LAOC2-REPO/pratica1.2_Giovanni_Thalles/tb_hierarquia_memoria.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneii_ver -L rtl_work -L work -voptargs="+acc"  tb_hierarquia_memoria

add wave *
view structure
view signals
run -all
