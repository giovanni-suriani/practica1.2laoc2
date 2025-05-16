# Cria um script para compilar e simular o testbench de hierarquia de memória
# Cria a biblioteca de trabalho
vlib work
vlib altera
# Compila a biblioteca altera necessária vlog -work altera /home/gi/altera/13.0sp1/modelsim_ase/altera/verilog/src/altera_mf.v


# Compila os arquivos Verilog necessários
#vlog hierarquia_memoria.v memoram.v tb_hierarquia_memoria.v 
vlog hierarquia_memoria.v tb_hierarquia_memoria_escrita.v 
vsim -L altera work.tb_hierarquia_memoria -c -do "run 1000ps; quit"

# para rodar:  vsim -c -do windows_vlog_terminal_hierarquia.do