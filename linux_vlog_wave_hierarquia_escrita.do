# Cria um script para compilar e simular o testbench de hierarquia de memória

# Cria a biblioteca de trabalho
#vlib work
#vlib altera
#vlog -work altera /home/gi/altera/13.0sp1/modelsim_ase/altera/verilog/src/altera_mf.v


# Compila os arquivos Verilog necessários vlog hierarquia_memoria.v memoram.v tb_hierarquia_memoria_escrita.v 
vlog hierarquia_memoria.v tb_hierarquia_memoria_escrita.v 
vsim -L altera work.tb_hierarquia_memoria_escrita 


# Adiciona os sinais do testbench ao waveform

add wave -label "clock" clock
add wave -label "reset" reset
add wave -label "address" address
add wave -label "write_data" write_data
add wave -label "read" read
add wave -label "write" write

add wave -label "read_data" read_data
add wave -label "hit_L1" hit_L1
add wave -label "hit_L2" hit_L2

# Sinal interno do módulo hierarquia_memoria
add wave -label "mem_clock" sim:/tb_hierarquia_memoria_escrita/uut/mem_clock

#L1
add wave -label "L1_data" sim:/tb_hierarquia_memoria_escrita/uut/L1_data
add wave -label "L1_tag" sim:/tb_hierarquia_memoria_escrita/uut/L1_tag
add wave -label "L1_valid" sim:/tb_hierarquia_memoria_escrita/uut/L1_valid  
add wave -label "L1_lru" sim:/tb_hierarquia_memoria_escrita/uut/L1_lru
add wave -label "index_L1" sim:/tb_hierarquia_memoria_escrita/uut/index_L1

# L2
add wave -label "L2_data" sim:/tb_hierarquia_memoria_escrita/uut/L2_data
add wave -label "L2_tag" sim:/tb_hierarquia_memoria_escrita/uut/L2_tag
add wave -label "L2_valid" sim:/tb_hierarquia_memoria_escrita/uut/L2_valid
add wave -label "L2_lru" sim:/tb_hierarquia_memoria_escrita/uut/L2_lru
add wave -label "L2_dirty" sim:/tb_hierarquia_memoria_escrita/uut/L2_dirty

# Executa a simulacao
run 10000ps

# Abre o waveform e ajusta exibição
radix -unsigned
view wave
WaveRestoreZoom 0ps 600ps
configure wave -timelineunits ps



# Para rodar killmodelsim;vsim -do linux_vlog_wave_hierarquia_escrita.do 