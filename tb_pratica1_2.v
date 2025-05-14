`timescale 1ns / 1ps

module tb_pratica1_2;

    // Entradas
    reg [17:0] SW;

    // Saídas
    wire [0:6] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
    wire [17:0] LEDR;
    wire [0:7] LEDG;

    // Instância do módulo sob teste (UUT - Unit Under Test)
    pratica1_2 uut (
        .SW(SW),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3),
        .HEX4(HEX4),
        .HEX5(HEX5),
        .HEX6(HEX6),
        .HEX7(HEX7),
        .LEDR(LEDR),
        .LEDG(LEDG)
    );

    initial begin
        // Inicialização
        SW = 18'b0;

        // Aplicar estímulos
        #10 SW = 18'b0000_0000_0000_0000_01;
        #10 SW = 18'b0000_0000_0000_0000_10;
        #10 SW = 18'b1111_1111_1111_1111_11;
        #10 SW = 18'b0000_0000_0000_0000_00;

        #100 $stop; // termina a simulação
    end

endmodule
