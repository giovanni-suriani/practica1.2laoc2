`timescale 1ps / 1ps
module tb_cache_l1;

  reg clk, reset, wren;
  reg [6:0] addr;
  reg [15:0] data;
  wire hit;
  wire [15:0] q;

  // Instancia o módulo a ser testado
  cache_l1_2way DUT (
    .clk(clk),
    .reset(reset),
    .addr(addr),
    .wren(wren),
    .data(data),
    .hit(hit),
    .q(q)
  );

  // Gera clock
  always #5 clk = ~clk;

  initial begin
    $display("===== INICIO DO TESTE =====");
    clk = 0;
    reset = 1;
    wren = 0;
    addr = 7'b0;
    data = 16'h0000;

    // Aplica reset
    #10;
    reset = 0;
    $display("[RESET] Cache zerada");

    // 1. Escreve no endereço 0b0001010 (tag=00010, index=1, offset=0)
    #10;
    addr = 7'b0000001;
    data = 16'hABCD;
    wren = 1;
    #10;
    wren = 0;
    $display("[ESCRITA] Endereco: %b, Dado escrito: %h, HIT: %h", addr, data, hit);

    // 2. Leitura no mesmo endereço (espera HIT)
    #10;
    addr = 7'b0000001;
    wren = 0;
    #10;
    $display("[LEITURA-HIT] Endereco: %b, Dado lido: %h, HIT: %b", addr, q, hit);

    // 3. Leitura de endereço diferente (espera MISS)
    #10;
    addr = 7'b0010011; // tag diferente, mesmo index
    #10;
    $display("[LEITURA-MISS] Endereco: %b, Dado lido: %h, HIT: %b", addr, q, hit);

    // 4. Sobrescreve no mesmo index (teste de substituição)
    #10;
    addr = 7'b0010010; // mesma do miss
    data = 16'hBEEF;
    wren = 1;
    #10;
    wren = 0;
    $display("[ESCRITA-2] Endereco: %b, Dado escrito: %h", addr, data);

    // 5. Lê novamente endereço original (espera miss se LRU expulsou)
    #10;
    addr = 7'b0001010;
    wren = 0;
    #10;
    $display("[LEITURA-POS-EVICT] Endereco: %b, Dado lido: %h, HIT: %b", addr, q, hit);

    $display("===== FIM DO TESTE =====");
    $finish;
  end

endmodule

/* vlog cache_l1_2way.v tb_cache_l1.v; vsim -c work.tb_cache_l1 -do "run -all; quit" 
vsim -do vlogrun.do
vsim work.tb_cache_l1
*/