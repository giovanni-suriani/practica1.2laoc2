`timescale 1ns / 1ps

module tb_hierarquia_memoria;

    // Sinais de entrada
    reg clock;
    reg reset;
    reg [15:0] address;
    reg [15:0] write_data;
    reg read;
    reg write;

    // Sinais de saída
`timescale 1ns / 1ps

module tb_hierarquia_memoria;

    // Sinais de entrada
    reg clock;
    reg reset;
    reg [15:0] address;
    reg [15:0] write_data;
    reg read;
    reg write;

    // Sinais de saída
    wire [15:0] read_data;
    wire hit_L1;
    wire hit_L2;

    // Clock da memória interna
    // (internamente manipulado pelo DUT)

    // Instanciando o DUT
    hierarquia_memoria dut (
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

    // Geração de clock
    always #5 clock = ~clock;

    initial begin
        // Inicializa sinais
        clock = 0;
        reset = 1;
        read = 0;
        write = 0;
        address = 0;
        write_data = 0;

        // Aplica reset
        #10 reset = 0;

        // Espera um pouco
        #10;

        // 1) Escreve na memória no endereço 10
        address = 16'd10;
        write_data = 16'h_
