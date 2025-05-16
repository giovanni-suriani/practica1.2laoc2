`timescale 1ps / 1ps

module tb_hierarquia_memoria_escrita;

  // Entradas
  reg clock;
  reg reset;
  reg [5:0] address;
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
  always
    begin
      #50 clock = ~clock; // Gera um clock de 10ns
    end

  // Estímulos do testbench
  initial
    begin
      // Inicializa o clock e os sinais
      clock = 0;
      reset = 0;
      address = 5'd0;
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

      $display("disclaimer: so no conjunto 0 ainda");
      #100;

      // Teste 1: Escrita da L1 no endereco 1  -> verifica a L2, pega do arquivo.mif
      situacao_L2;
      address = 6'b0000_01;
      write = 1;
      write_data = 16'b0000_0000_0000_0010;
      // Escreve 2 no endereco 1 da L1 e L2
      $display("[%0t] ---- Teste 1: Escrita da L1, write_miss no endereco 1, deve escrever na L2 e nao escrever na principal ----", $time);
      $display("[%0t] Escrevendo na L1: Addr = %d, write = %b", $time, address, write);
      #100;
      $display("[%0t] Read_Data = %d | hit_L1 = %b | hit_L2 = %b", $time, read_data, hit_L1, hit_L2);
      $display("[%0t] Esperado do .mif = 2 | hit_L1 = 0 | hit_L2 = 0", $time);
      $display("");


      // Teste 2: Escrita da L1 no endereco 1  -> verifica a L2, pega do arquivo.mif
      #100;
      address = 6'b0000_01;
      write = 1;
      write_data = 16'b0000_0000_0000_010;
      // Escreve 1 no endereco 2 da L1 e L2
      $display("[%0t] ---- Teste 2: Escrita da L1, write_hit no endereco 1, deve dar write_hit ----", $time);
      $display("[%0t] Escrevendo na L1: Addr = %d, write = %b", $time, address, write);
      #100;
      $display("[%0t] Read_Data = %d | hit_L1 = %b | hit_L2 = %b", $time, read_data, hit_L1, hit_L2);
      $display("[%0t] Esperado do .mif = 2 | hit_L1 = 1| hit_L2 = 0", $time);
      $display("");
      write = 0;
      situacao_L2;

      // Teste 3: Escrita da L1 no endereco 3  -> verifica a L2, pega do arquivo.mif
      #100;
      address = 6'b0000_11;
      write = 1;
      write_data = 16'b0000_0000_0000_0100;
      // Escreve 4 no endereco 3 da L1 e L2
      $display("[%0t] ---- Teste 3: Escrita da L1, write_miss no endereco 3, deve escrever na L2 e nao escrever na principal ----", $time);
      $display("[%0t] Escrevendo na L1: Addr = %d, write = %b", $time, address, write);
      #100;
      $display("[%0t] Read_Data = %d | hit_L1 = %b | hit_L2 = %b", $time, read_data, hit_L1, hit_L2);
      $display("[%0t] Esperado do .mif = 4 | hit_L1 = 0 | hit_L2 = 0", $time);
      // situacao_L1;
      write = 0;
      situacao_L2;

      // Teste 4: Preenchendo a cache L1 e L2 com escritas  -> verifica a L2, pega do arquivo.mif
      teste4;

      // Teste 5: Write Back
      teste5;


      // Teste 6: Aproveitando para fazer read

      $finish; // Finaliza a simulação






      // Teste 2: Leitura da L1 (agora com os dados),
    end

  task preencher_L1_L2;
    begin
      #100;
      address = 6'b0000_10;
      read = 1;
      $display("**[%0t] Lendo da L1, Addr = %h, read = %b", $time, address, read);
      #100;
      $display("**[%0t] Read_Data = %h | hit_L1 = %b | hit_L2 = %b", $time, read_data, hit_L1, hit_L2);
      // $display("**[%0t] Esperado do .mif = 0002 | hit_L1 = 0 | hit_L2 = 0", $time);
      $display("**[%0t] Tag = %b = %d, indice = %b", $time, address[5:1], address[5:1], address[0]);

      #100;
      address = 6'b0000_11;
      read = 1;
      $display("**[%0t] Lendo da L1, Addr = %h, read = %b", $time, address, read);
      #100;
      $display("**[%0t] Read_Data = %h | hit_L1 = %b | hit_L2 = %b", $time, read_data, hit_L1, hit_L2);
      $display("**[%0t] Esperado do .mif = 0003 | hit_L1 = 0 | hit_L2 = 0", $time);
      // $display("**[%0t] Tag = %b = %d, indice = %b", $time, address[5:1], address[5:1], address[0]);

      #100;
      address = 6'b0001_00;
      read = 1;
      $display("**[%0t] Lendo da L1, Addr = %h, read = %b", $time, address, read);
      #100;
      $display("**[%0t] Read_Data = %d | hit_L1 = %b | hit_L2 = %b", $time, read_data, hit_L1, hit_L2);
      $display("**[%0t] Esperado do .mif = 0004 | hit_L1 = 0 | hit_L2 = 0", $time);
      $display("**[%0t] Tag = %b = %d, indice = %b", $time, address[5:1], address[5:1], address[0]);


      #100;
      address = 6'b0101_00; // 20
      read = 1;

      // L1[0][0]
      $display("**[%0t] Lendo da L1, Addr = %h, read = %b", $time, address, read);
      #100;
      $display("**[%0t] Read_Data = %d | hit_L1 = %b | hit_L2 = %b", $time, read_data, hit_L1, hit_L2);
      $display("**[%0t] Esperado do .mif = 21 | hit_L1 = 0 | hit_L2 = 0", $time);
      $display("**[%0t] Tag = %b = %d, indice = %b", $time, address[5:1], address[5:1], address[0]);
      $display("");

      #100;
      address = 6'b0100_11; // 19
      read = 1;
      // L1[1][0]
      $display("**[%0t] Lendo da L1, Addr = %h, read = %b", $time, address, read);
      #100;
      $display("**[%0t] Read_Data = %d| hit_L1 = %b | hit_L2 = %b", $time, read_data, hit_L1, hit_L2);
      $display("**[%0t] Esperado do .mif = 19 | hit_L1 = 0 | hit_L2 = 0", $time);
      $display("**[%0t] Tag = %b = %d, indice = %b", $time, address[5:1], address[5:1], address[0]);
      $display("");

      #100;
      address = 6'b0101_10; // 22
      read = 1;
      // L1[0][1]
      $display("**[%0t] Lendo da L1, Addr = %h, read = %b", $time, address, read);
      #100;
      $display("**[%0t] Read_Data = %d | hit_L1 = %b | hit_L2 = %b", $time, read_data, hit_L1, hit_L2);
      $display("**[%0t] Esperado do .mif = 22 | hit_L1 = 0 | hit_L2 = 0", $time);
      $display("**[%0t] Tag = %b = %d, indice = %b", $time, address[5:1], address[5:1], address[0]);
      $display("");

      #100;
      address = 6'b0111_11; // 31
      read = 1;
      // L1[1][1]
      $display("**[%0t] Lendo da L1, Addr = %h, read = %b", $time, address, read);
      #100;
      $display("**[%0t] Read_Data = %h | hit_L1 = %b | hit_L2 = %b", $time, read_data, hit_L1, hit_L2);
      $display("**[%0t] Esperado do .mif = 31 | hit_L1 = 0 | hit_L2 = 0", $time);
      $display("**[%0t] Tag = %b = %d, indice = %b", $time, address[5:1], address[5:1], address[0]);
      $display("");
    end
  endtask

  task teste5;
    begin
      #100;
      address = 6'b0010_11; // 11
      write = 1;
      write_data = 16'b0000_0000_0000_1100; // Escreve 12 no endereco 11 da L1 e L2
      $display("[%0t] ---- Teste 5: Escrita da L1, write_miss no endereco 11, deve escrever na L2 e nao escrever na principal ----", $time);
      $display("[%0t] Escrevendo na L1: Addr = %d, write = %b", $time, address, write);
      #100;
      $display("[%0t] Read_Data = %d | hit_L1 = %b | hit_L2 = %b", $time, read_data, hit_L1, hit_L2);
      $display("[%0t] Esperado do .mif = 12 | hit_L1 = 0 | hit_L2 = 0", $time);
      situacao_L1;
      situacao_L2;
    end
  endtask

  task teste4 ;
    begin
      // Escreve 19 no endereco 18 da L1 e L2
      //  L1[0][0]
      #300;
      address = 6'b0100_10; // 18
      write = 1;
      write_data = 16'b0000_0000_0001_0011;
      $display("[%0t] ---- Teste 4: Preenchendo L1, write_miss no endereco 18, deve escrever na L2  ----", $time);
      $display("[%0t] Escrevendo na L1: Addr = %d, write = %b", $time, address, write);
      #100;
      $display("[%0t] Read_Data = %d | hit_L1 = %b | hit_L2 = %b", $time, read_data, hit_L1, hit_L2);
      $display("[%0t] Esperado do .mif = 19 | hit_L1 = 0 | hit_L2 = 0", $time);
      situacao_L1;
      // situacao_L2;

      // situacao_L2;
      // Escreve 27 no endereco 26 da L1 e L2
      //  L1[0][1]
      #100;
      address = 6'b0110_10; // 26
      write_data = 16'b0000_0000_0001_1011;
      $display("[%0t] Escrevendo na L1: Addr = %d, write = %b", $time, address, write);
      #100;
      $display("[%0t] Read_Data = %d | hit_L1 = %b | hit_L2 = %b", $time, read_data, hit_L1, hit_L2);
      $display("[%0t] Esperado do .mif = 27 | hit_L1 = 0 | hit_L2 = 0", $time);
      situacao_L1;
      // situacao_L2;


      // Escreve 28 no endereco 27
      // Nao sei ainda L1[0][1]
      #100;
      address = 6'b0001_11; // 3
      write_data = 16'b0000_0000_0000_1000;
      // situacao_L2;
      // Escreve 8 no endereco 7 da L1 e L2
      $display("[%0t] Escrevendo na L1: Addr = %d, write = %b", $time, address, write);
      #100;
      $display("[%0t] Read_Data = %d | hit_L1 = %b | hit_L2 = %b", $time, read_data, hit_L1, hit_L2);
      $display("[%0t] Esperado do .mif = 3 | hit_L1 = 0 | hit_L2 = 0", $time);
      situacao_L1;
      // situacao_L2;

      // Escreve 10 no endereco 9 da L1 e L2
      #100;
      address = 6'b0010_01; // 9
      write_data = 16'b0000_0000_0000_1010;
      $display("[%0t] Escrevendo na L1: Addr = %d, write = %b", $time, address, write);
      #100;
      $display("[%0t] Read_Data = %d | hit_L1 = %b | hit_L2 = %b", $time, read_data, hit_L1, hit_L2);
      $display("[%0t] Esperado do .mif = 10 | hit_L1 = 0 | hit_L2 = 0", $time);

      #100;
      address = 6'b0110_11; // 27
      write_data = 16'b0000_0000_0001_1100;
      // situacao_L2;
      // Escreve 27 no endereco 26 da L1 e L2
      $display("[%0t] Escrevendo na L1: Addr = %d, write = %b", $time, address, write);
      #100;
      $display("[%0t] Read_Data = %d | hit_L1 = %b | hit_L2 = %b", $time, read_data, hit_L1, hit_L2);
      $display("[%0t] Esperado do .mif = 27 | hit_L1 = 0 | hit_L2 = 0", $time);
      situacao_L1;
      // situacao_L2;

      // Escreve 22 no endereco 31 da L1 e L2
      #100;
      address = 6'b0111_11; // 31
      write_data = 16'b0000_0000_0010_0000;
      $display("[%0t] Escrevendo na L1: Addr = %d, write = %b", $time, address, write);
      #100;
      $display("[%0t] Read_Data = %d | hit_L1 = %b | hit_L2 = %b", $time, read_data, hit_L1, hit_L2);
      $display("[%0t] Esperado do .mif = 32 | hit_L1 = 0 | hit_L2 = 0", $time);
      write = 0;


      situacao_L1;
      situacao_L2;
      $display("[%0t] ---- Fim do Teste 4 ----", $time);
    end
  endtask

  task situacao_L1 ;
    begin
      $display("[%0t] ---- Situacao da cache L1 ----", $time);
      $display("[%0t] Conjunto 0| Via 0 |  Tag | V  | LRU | Data  ", $time);
      $display("[%0t]                   | %d   | %d  |  %d  |%d  ", $time, uut.L1_tag[0][0], uut.L1_valid[0][0], uut.L1_lru[0][0] ,uut.L1_data[0][0]);
      $display("[%0t] Conjunto 0| Via 1 |  Tag | V  | LRU | Data  ", $time);
      $display("[%0t]                   | %d   | %d  |  %d  |%d  ", $time, uut.L1_tag[0][1], uut.L1_valid[0][1], uut.L1_lru[0][1] ,uut.L1_data[0][1]);
      $display("[%0t] Conjunto 1| Via 0 |  Tag | V  | LRU | Data  ", $time);
      $display("[%0t]                   | %d   | %d  |  %d  |%d  ", $time, uut.L1_tag[1][0], uut.L1_valid[1][0], uut.L1_lru[1][0] ,uut.L1_data[1][0]);
      $display("[%0t] Conjunto 1| Via 1 |  Tag | V  | LRU | Data  ", $time);
      $display("[%0t]                   | %d   | %d  |  %d  |%d  ", $time, uut.L1_tag[1][1], uut.L1_valid[1][1], uut.L1_lru[1][1] ,uut.L1_data[1][1]);
      $display("[%0t] ---- Fim da situacao da cache L1 ----", $time);
      $display("");
    end
  endtask

  task situacao_L2 ;
    integer i;
    begin
      $display("[%0t] ---- Situacao da cache L2 ----", $time);
      $display("[%0t]           Endereco | Tag  | Dirty | V  | LRU |  Data  ", $time);
      // $display("[%0t] 0        | %d   | %d  |  %d  |%d  ", $time, uut.L2_tag[0], uut.L2_valid[0], uut.L2_lru[0] ,uut.L2_data[0]);
      for (i = 0; i < 8; i = i + 1) // declare antes o i
        begin
          $display("[%0t]       %d  | %d   |    %d  | %d  | %d   | %d  ", $time, i, uut.L2_tag[i], uut.L2_dirty[i] ,uut.L2_valid[i],
                   uut.L2_lru[i] ,uut.L2_data[i]);
        end

    end
  endtask



endmodule
