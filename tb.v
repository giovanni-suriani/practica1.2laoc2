`timescale 1ns / 1ps

module tb;

    reg clk;
    reg [5:0] address;
    reg [15:0] data;
    reg wren;
    wire [15:0] q;

    // Instância da memória
    memoram dut (
        .address(address),
        .clock(clk),
        .data(data),
        .wren(wren),
        .q(q)
    );

    // Geracao de clock (100 MHz → 10ns período)
    always #1 clk = ~clk;

    initial begin
        $display("----- Iniciando simulação -----");

        // Inicializa sinais
        clk = 0;
        address = 0;
        data = 0;
        wren = 0;

        // Espera estabilizar
        #5;
		  
		  // Leitura endereco inicial 1
		  address = 5'b00001;
		  
		  #4;

        // Escrita 1: endereco 10 
        address = 6'd10;
        data = 16'd8;
        wren = 1;
        #4;

        // Escrita 2: endereco 20 
        address = 6'd20;
        data = 16'd14;
        wren = 1;
        #4;

        // Desabilita escrita
        wren = 0;
        data = 16'h0000;

        // Leitura 1: endereco 10
        address = 6'd10;
        #4;
        $display("Leitura endereco 10: %d (esperado: AAAA)", q);

        // Leitura 2: endereco 20
        address = 6'd20;
        #4;
        $display("Leitura endereco 20: %d (esperado: 5555)", q);

        $display("----- Simulação finalizada -----");
        $stop;
    end

endmodule
