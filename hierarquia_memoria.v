// ImplementaÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â§ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â£o de hierarquia de memÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â³ria com cache L1, cache L2 e memÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â³ria principal
`timescale 1ps / 1ps

module hierarquia_memoria(input clock,
                            input reset,
                            input [5:0] address,         // Endereco de memoria com 6 bits (5 tag + 1 de indice)
                            input [15:0] write_data,     // Dados para escrita
                            input read,                  // Sinal de leitura
                            input write,                 // Sinal de escrita
                            output reg [15:0] read_data, // Dados lidos
                            output reg hit_L1,           // Indica acerto na cache L1
                            output reg hit_L2);          // Indica acerto na cache L2

  // Definicoes
  // Cache L1 com 4 linhas
  // Cache L2 com 8 linhas
  // Memoria principal com 16 palavras de 16 bits

  // Estrutura da cache L1 (associativa por conjunto de 2 vias) [conjunto_index][via]
  reg [15:0] L1_data [1:0][1:0]; // Dados
  reg [4:0]  L1_tag  [1:0][1:0]; // Tags
  reg        L1_valid[1:0][1:0]; // 1 Bits de validade
  reg        L1_lru  [1:0][1:0];     // 1 Bit LRU para cada conjunto

  // Estrutura da cache L2 (totalmente associativa)
  reg [15:0] L2_data[7:0]; // Dados
  reg [4:0]  L2_tag[7:0]; // Tags
  reg [2:0]  L2_lru[7:0]; // 3 Bits LRU
  reg        L2_valid[7:0]; // Bits de validade
  reg        L2_dirty[7:0]; // Bits "Dirty"

  // Instancia da memoria principal
  reg wren;

  wire [15:0] wire_read_data;
  reg mem_clock;

  memoram main_memory (
            .address(address[5:0]), // Os 6 bits menos significativos do
            .clock(mem_clock),         // Sinal de clock
            .data(write_data),     // Dados para escrita
            .wren(wren),          // Sinal de leitura/escrita
            .q(wire_read_data)         // Dados lidos
          );

  // Divisao do endereco
  wire       index_L1 = address[0]; // Indice para a cache L1 (1 bit)
  wire [3:0] tag     = address[4:1]; // Tag do endereco (4 bits)

  // Controle de leitura/escrita
  integer i;


  // Variaveis auxiliares para L2
  integer write_made;
  integer biggest_lru_l2;
  integer dummy;

  always @(posedge clock or posedge reset)
    begin
      write_made = 0; // Variavel para verificar se foi feita escrita
      // read_data = wire_read_data;
      if (reset)
        begin
          // inicializacao da cache e memoria
          for (i = 0; i < 2; i = i + 1)
            begin
              L1_valid[i][0] <= 0;
              L1_valid[i][1] <= 0;
              L1_lru[i][0]      <= 0;
              L1_lru[i][1]      <= 0;
            end
          for (i = 0; i < 8; i = i + 1)
            begin
              L2_valid[i] <= 0;
              L2_dirty[i] <= 0;
              L2_lru[i]   <= 0;
            end
        end
      else
        begin
          // Operacao de leitura ou escrita
          hit_L1 = 0;
          hit_L2 = 0;

          // Verifica a cache L1
          if (L1_valid[index_L1][0] == 1 && L1_tag[index_L1][0] == tag)
            begin
              hit_L1 = 1;
              if (read)
                begin
                  read_data           <= L1_data[index_L1][0];
                  L1_lru[index_L1][0] <= 0; // Atualiza LRU
                  if (L1_valid[index_L1][1] == 1) // Se a via 1 esta ocupada
                    begin
                      L1_lru[index_L1][1]   <= 1; // Atualiza LRU
                    end
                end
              if (write)
                begin
                  L1_data[index_L1][0]  = write_data;
                  // Escreve na L2
                  // $display("atualiza LRU meu chapa");
                  for (i = 0; i < 8; i = i + 1)
                    begin
                      if (!write_made && (L2_tag[i] == address)) // Checa se a linha esta livre
                        begin
                          // Coloca na primeira linha livre da L2
                          L2_data[i]  <= write_data;
                          L2_tag[i]   <= address;
                          L2_valid[i] <= 1;
                          L2_dirty[i] <= 1; // Marca como dirty
                          read_data   <= write_data; // Retorna o dado escrito
                          atualiza_lru_l2(i);
                          write_made = 1; // Marca que foi feita a escrita no mesmo delta_cycle
                        end
                    end
                  // Retorna o dado escrito
                  read_data   <= write_data;
                  L1_lru[index_L1][0] <= 0; // Atualiza LRU
                  if (L1_valid[index_L1][1] == 1) // Se a via 1 esta ocupada
                    begin
                      L1_lru[index_L1][1]   <= 1; // Atualiza LRU
                    end
                end
            end
          
          else if (L1_valid[index_L1][1] == 1 && L1_tag[index_L1][1] == tag)
            begin
              hit_L1 = 1;
              if (read)
                begin
                  read_data <= L1_data[index_L1][1];
                  L1_lru[index_L1][1] <= 0; // Atualiza LRU
                  if (L1_valid[index_L1][0] == 1) // Se a via 0 esta ocupada
                    begin
                      L1_lru[index_L1][0] <= 1; // Atualiza LRU
                    end
                end
              if (write)
                begin
                  L1_data[index_L1][1]  = write_data;
                  // Escreve na L2
                  for (i = 0; i < 8; i = i + 1)
                    begin
                      if (!write_made && L2_valid[i] == 0) // Checa se a linha esta livre, NAO USE ~

                        begin
                          // Coloca na primeira linha livre da L2
                          L2_data[i]  <= write_data;
                          L2_tag[i]   <= address;
                          L2_valid[i] <= 1;
                          L2_dirty[i] <= 1; // Marca como dirty
                          read_data   <= write_data; // Retorna o dado escrito
                          atualiza_lru_l2(i);
                          write_made = 1; // Marca que foi feita a escrita no mesmo delta_cycle
                        end
                    end
                  // Retorna o dado escrito
                  read_data   <= write_data;
                  L1_lru[index_L1][1] <= 0; // Atualiza LRU
                  if (L1_valid[index_L1][0] == 1) // Se a via 0 esta ocupada
                    begin
                      L1_lru[index_L1][0] <= 1; // Atualiza LRU
                    end
                end
              // L1_lru[index_L1][1] = 0; // Atualiza LRU
            end
          // Se o bit eh invalido, verificar se foi feita escrita nas duas vias
          else if(L1_valid[index_L1][0] == 0 && write)
            begin
              // Write Miss na L1, mas a via 0 esta livre
              // escrita na via 0 da L1
              L1_data[index_L1][0]  <= write_data;
              L1_tag[index_L1][0]   <= tag;
              L1_valid[index_L1][0] <= 1;
              L1_lru[index_L1][0]   <= 0; // Atualiza LRU
              if (L1_valid[index_L1][1] == 1) // Se a via 1 esta ocupada
                begin
                  L1_lru[index_L1][1] <= 1; // Atualiza LRU
                end
              // escrita na L2 Implementar WB ainda
              for (i = 0; i < 8; i = i + 1)
                begin
                  // $display("entrei em L1_valid[index_L1][0] == 0 && write");
                  // $display("write_made = %d, L2_valid[%0d] = %d",write_made, i, L2_valid[i]);
                  if (!write_made && L2_valid[i] == 0)  // Checa se a linha esta livre
                    begin
                      $display("entrei no loop");
                      // Coloca na primeira linha livre da L2
                      L2_data[i]  <= write_data;
                      L2_tag[i]   <= address;
                      L2_valid[i] <= 1;
                      L2_dirty[i] <= 1; // Marca como dirty
                      read_data   <= write_data; // Retorna o dado escrito
                      atualiza_lru_l2(i);
                      write_made = 1; // Marca que foi feita a escrita no mesmo delta_cycle
                    end
                end
              // Retorna o dado escrito
              read_data   <= write_data;
            end
          // Se o bit eh invalido, verificar se foi feita escrita nas duas vias e se ja foi escrito
          else if(L1_valid[index_L1][1] == 0 && write)
            begin
              // Write Miss na L1, mas a via 1 esta livre
              // escrita na via 1 da L1
              L1_data[index_L1][1]  <= write_data;
              L1_tag[index_L1][1]   <= tag;
              L1_valid[index_L1][1] <= 1;
              L1_lru[index_L1][1]   <= 0; // Atualiza LRU
              if (L1_valid[index_L1][0] == 1) // Se a via 0 esta ocupada
                begin
                  L1_lru[index_L1][0] <= 1; // Atualiza LRU
                end
              // escrita na L2 Implementar WB ainda
              for (i = 0; i < 8; i = i + 1)
                begin
                  if (!write_made && L2_valid[i] == 0) // Checa se a linha esta livre
                    begin
                      // Coloca na primeira linha livre da L2
                      L2_data[i]  <= write_data;
                      L2_tag[i]   <= address;
                      L2_valid[i] <= 1;
                      L2_dirty[i] <= 1; // Marca como dirty
                      read_data   <= write_data; // Retorna o dado escrito
                      atualiza_lru_l2(i);
                      write_made = 1; // Marca que foi feita a escrita no mesmo delta_cycle
                    end
                end
              // Retorna o dado escrito
              read_data   <= write_data;
            end

          else
            begin
              // Falha na cache L1, verifica a cache L2
              for (i = 0; i < 8; i = i + 1)
                begin
                  if (L2_valid[i] && L2_tag[i] == address)
                    begin
                      hit_L2 = 1;
                      if (read)
                        begin
                          // Read Hit na L2
                          read_data <= L2_data[i];
                          if (L1_valid[index_L1][0] == 0 || L1_lru[index_L1][0] == 1) // Checa se a via 0 esta livre e a LRU
                            begin
                              // Coloca na via 0 da L1
                              L1_data[index_L1][0]     <= L2_data[i];
                              L1_tag[index_L1][0]      <= tag;
                              L1_valid[index_L1][0]    <= 1;
                              if (L1_valid[index_L1][1] == 1) // Se a via 1 esta valida
                                begin
                                  L1_lru[index_L1][1]      <= 1; // Atualiza LRU
                                end
                              L1_lru[index_L1][0]      <= 0; // Atualiza LRU
                            end
                          else if (L1_valid[index_L1][1] == 0 || L1_lru[index_L1][1] == 1) // Checa se a via 1 esta livre ou se e a LRU
                            begin
                              // Coloca na via 1 da L1
                              L1_data[index_L1][1]     <= L2_data[i];
                              L1_tag[index_L1][1]      <= tag;
                              L1_valid[index_L1][1]    <= 1;
                              if (L1_valid[index_L1][0] == 1) // Se a via 0 esta ocupada
                                begin
                                  L1_lru[index_L1][0]      <= 1; // Atualiza LRU
                                end
                              L1_lru[index_L1][1]      <= 0; // Atualiza LRU
                            end
                        end
                      if (write)
                        begin
                          $display("Caso Impossivel na pratica Nao tem na L1 entao nao tem na L2");
                        end
                      // break;
                    end
                end

              if (!hit_L2)
                begin
                // $display("devo");
                  // Falha na cache L2, acessa a memoria principal
                  if (read)
                    begin
                      wren = 1'b0; // ler da memoria mem_clock = 1'b1; // Ativa o clock da memoria
                      // dois ciclos para ler
                      mem_clock      = 1'b0; // Desativa o clock da memoria
                      #12 mem_clock  = 1'b1; // Ativa o clock da memoria
                      #12 mem_clock  = 1'b0; // Desativa o clock da memoria
                      #12 mem_clock  = 1'b1; // Ativa o clock da memoria
                      //#1 mem_clock = 1'b1; // Ativa o clock da memoria
                      #1 read_data <= wire_read_data;
                      // Coloca os dados na L1 e na L2
                      // Colocando na L1
                      if (L1_valid[index_L1][0] == 0 || L1_lru[index_L1][0] == 1) // Checa se a via 0 esta livre e a LRU
                        begin
                          // $display("via 0 da L1 esta livre");
                          // Coloca na via 0 da L1
                          L1_data[index_L1][0]     <= wire_read_data;
                          L1_tag[index_L1][0]      <= tag;
                          L1_valid[index_L1][0]    <= 1;
                          if (L1_valid[index_L1][1] == 1) // Se a via 1 esta valida
                            begin
                              L1_lru[index_L1][1]      <= 1; // Atualiza LRU
                            end
                          L1_lru[index_L1][0]      <= 0; // Atualiza LRU
                        end
                      else if (L1_valid[index_L1][1] == 0 || L1_lru[index_L1][1] == 1) // Checa se a via 1 esta livre ou se e a LRU
                        begin
                          // Coloca na via 1 da L1
                          L1_data[index_L1][1]     <= wire_read_data;
                          L1_tag[index_L1][1]      <= tag;
                          L1_valid[index_L1][1]    <= 1;
                          if (L1_valid[index_L1][0] == 1) // Se a via 0 esta ocupada
                            begin
                              L1_lru[index_L1][0]      <= 1; // Atualiza LRU
                            end
                          L1_lru[index_L1][1]      <= 0; // Atualiza LRU
                        end

                      // Colocando na L2
                      for (i = 0; i < 8; i = i + 1)
                        begin
                          if (L2_valid[i] == 0 || L2_lru[i] == 7) // Checa se a linha esta livre ou se e a LRU remove
                            begin
                              // Coloca na primeira linha livre da L2
                              L2_data[i]  <= wire_read_data;
                              L2_tag[i]   <= address;
                              L2_valid[i] <= 1;
                              L2_dirty[i] <= 0; // Marca como nao dirty
                              atualiza_lru_l2(i);
                            end
                        end
                      // Se nao encontrou linha livre na L2, substitui a primeira
                    end
                  if (write && write_made == 0)
                    begin
                      // Fazer WB
                      $display("entrei em !hit_L2");
                      wren = 1'b1; // Escreve na memoria
                      // dois ciclos para escrever
                      mem_clock = 1'b0; // Desativa o clock da memoria
                      mem_clock = 1'b1; // Ativa o clock da memoria
                      read_data <= wire_read_data;
                    end
                end
            end
        end
    end

  task atualiza_lru_l2;
    //  Atualiza a lru do conjunto
    input least_recent_way;
    integer i_way;
    begin
      for (i_way = 0; i_way < 8 ; i_way = i_way + 1)
        begin
          if (least_recent_way == i_way)
            begin
              L2_lru[0] <= 0;
            end
          else
            begin
              if (L2_valid[i] == 1)
                begin
                  L2_lru[i] <= L2_lru[i] + 1;
                end
            end
        end
    end
  endtask

  function integer biggest_lru_l2_index;
    input integer dummy_input;
    integer i_way;
    begin
      biggest_lru_l2_index = 0;
      for (i_way = 0; i_way < 8; i_way = i_way + 1)
        begin
          if (L2_lru[i_way] > L2_lru[biggest_lru_l2_index])
            biggest_lru_l2_index = i_way;
        end
    end
  endfunction

endmodule

/*
 vlib work
 vlib altera
 
 vlog -work altera /home/gi/altera/13.0sp1/modelsim_ase/altera/verilog/src/altera_mf.v
 
 vlog hierarquia_memoria.v memoram.v tb_hierarquia_memoria.v
 
 vsim -L altera tb_hierarquia_memoria
 */
