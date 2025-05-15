`timescale 1ps / 1ps

module tb_hierarquia_memoria;

    // Entradas
    reg clock;
    reg reset;
    reg [15:0] address;
    reg [15:0] write_data;
    reg read;
    reg write;

    // Saídas
    wire [15:0] read_data;
    wire hit_L1;
    wire hit_L2;

    // Instancia o módulo de hierarquia de memória
    hierarquia_memoria uut ( // unit under test
        .clock(clock),
        .reset(reset),
        .address(address),
        .write_data(write_data),
        .read(read),
        .write(write),
        .read_data(read_data),
        .hit_L1(hit_L1),
        .hit_L2(hit_L2)
    );

    // Geração do clock
    always begin
        #50 clock = ~clock; // Gera um clock de 10ns
    end

    // Estímulos do testbench
    initial begin
        // Inicializa o clock e os sinais
        clock = 0;
        reset = 0;
        address = 16'd0;
        write_data = 16'b0;
        read = 0;
        write = 0;

        $display("=== INICIANDO SIMULACAO ===");

        // Resetando o sistema
        #100;
        reset = 1;
        $display("[%0t] Reset ativado", $time);
        #100;
        reset = 0;
        $display("[%0t] Reset desativado", $time);
        $display("");

        // Teste 1: Leitura da L1 (sem dados) -> verifica a L2, pega do arquivo.mif
        address = 16'b0000000000000001;
        read = 1;
        $display("[%0t] ---- Teste 1: Leitura da L1 sem dados, deve verificar L2 que falha e pegar dados do .mif ----", $time);
        $display("[%0t] Lendo da L1 sem dados: Addr = %h, read = %b", $time, address, read);
        #100;
        $display("[%0t] Read_Data = %h | hit_L1 = %b | hit_L2 = %b", $time, read_data, hit_L1, hit_L2);
        $display("[%0t] Esperado do .mif = 0001 | hit_L1 = 0 | hit_L2 = 0", $time);
        read = 0;
        $display("");

        // Teste 2: Leitura da L1 (agora com os dados),
        #100;
        address = 16'b0000000000000001;
        read = 1;
        $display("[%0t] ---- Teste 2: Leitura da L1 com dados, deve dar hit na l1 ----", $time);
        $display("[%0t] Lendo da L1 com dados: Addr = %h, read = %b", $time, address, read);
        #100;
        $display("[%0t] Read_Data = %h | hit_L1 = %b | hit_L2 = %b", $time, read_data, hit_L1, hit_L2);
        $display("[%0t] Esperado do .mif = 0001 | hit_L1 = 1 | hit_L2 = 0", $time);
        read = 0;


        // $finish;
    end

endmodule
