# Cria um script para compilar e simular o testbench de hierarquia de memória

# Cria a biblioteca de trabalho
vlib work
vlib altera

vlog -work altera C:/altera/13.0sp1/modelsim_ase/altera/verilog/src/altera_mf.v

# Compila os arquivos Verilog necessários
vlog hierarquia_memoria.v memoram.v tb_hierarquia_memoria.v 
vsim -L altera work.tb_hierarquia_memoria 


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
add wave -label "mem_clock" sim:/tb_hierarquia_memoria/uut/mem_clock

# Executa a simulacao
run 1000ps

# Abre o waveform e ajusta exibição
radix -binary
view wave
WaveRestoreZoom 0ps 600ps


# Para rodar vsim -do linux_vlog_terminal_hierarquia.do 