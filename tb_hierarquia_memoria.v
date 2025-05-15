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
        #50 clock = ~clock; // Gera um clock de 100 ps
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


        // Teste 1: Leitura da L1
        address = 16'b1;
        read = 1;
        $display("[%0t] Lendo da L1: Addr = %h", $time, address);
        #50;
        $display("[%0t] Read = %h | hit_L1 = %b | hit_L2 = %b", $time, read_data, hit_L1, hit_L2);
        read = 0;

        // $finish;
    end

endmodule
