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
  integer new_bit_valid;
  integer write_miss;
  integer write_made;
  integer biggest_lru_l2_idx;
  integer dummy;

  always @(posedge clock or posedge reset)
    begin
      new_bit_valid = 0; // Variavel para verificar se foi feita escrita em posicao previamente invalida
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

          // Depuracao
          if (write == 1'b1 && read == 1'b1) 
            begin
              $display("%1t ERRO: Sinais de leitura e escrita ativos ao mesmo tempo", $time);
            end


          // Verifica a cache L1, HITS
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
                  L1_data[index_L1][0]  <= write_data;
                  // Escreve na L2
                  // $display("atualiza LRU meu chapa");
                  for (i = 0; i < 8; i = i + 1)
                    begin
                      if (!write_made && (L2_tag[i] == address)) // Checa se a linha esta livre
                        begin
                          // Coloca na primeira linha livre da L2
                          L2_data[i]  <= write_data;
                          L2_tag[i]   <= address;
                          L2_valid[i] = 1;
                          L2_dirty[i] <= 1; // Marca como dirty
                          read_data   <= write_data; // Retorna o dado escrito
                          $display("//////////linha 114 vou atualizar LRU da L2 seu cachorro, i = %0d////////////", i);
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
                  $display("linha 145 Write Hit na L1");
                  L1_data[index_L1][1]  = write_data;
                  // Escreve na L2
                  for (i = 0; i < 8; i = i + 1)
                    begin
                      if (!write_made && L2_tag[i] == address) // Checa se a linha esta livre, NAO USE ~
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

          // Cache L1 Write Misses
          // Bits invalidos
          // Se o bit eh invalido, verificar se foi feita escrita nas duas vias
          else if(L1_valid[index_L1][0] == 0 && write && !write_made)
            begin
              // Write Miss na L1, mas a via 0 esta livre
              // escrita na via 0 da L1
              $display(" linha 177 Write miss na L1 entrei em L1_valid[index_L1][0] == 0 && write");
              L1_data[index_L1][0]  <= write_data;
              L1_tag[index_L1][0]   <= tag;
              L1_valid[index_L1][0] <= 1;
              L1_lru[index_L1][0]   <= 0; // Atualiza LRU
              if (L1_valid[index_L1][1] == 1) // Se a via 1 esta ocupada
                begin
                  L1_lru[index_L1][1] <= 1; // Atualiza LRU
                end
              // escrita na L2 Implementar WB ainda
              new_bit_valid = 1; // Marca que foi feita a escrita em posicao invalida
              for (i = 0; i < 8; i = i + 1)
                begin
                  // $display("entrei em L1_valid[index_L1][0] == 0 && write");
                  // $display("write_made = %d, L2_valid[%0d] = %d",write_made, i, L2_valid[i]);
                  if (!write_made && L2_valid[i] == 0)  // Checa se a linha esta livre
                    begin
                      // Coloca na primeira linha livre da L2
                      L2_data[i]  <= write_data;
                      L2_tag[i]   <= address;
                      L2_valid[i] <= 1;
                      L2_dirty[i] <= 1; // Marca como dirty
                      $display("//////////vou atualizar LRU da L2 seu cachorro, i = %0d////////////", i);
                      read_data   <= write_data; // Retorna o dado escrito
                      atualiza_lru_l2(i);
                      write_made = 1; // Marca que foi feita a escrita no mesmo delta_cycle
                    end
                end
              // Retorna o dado escrito
              read_data   <= write_data;
            end
          // Se o bit eh invalido, verificar se foi feita escrita nas duas vias e se ja foi escrito
          else if(L1_valid[index_L1][1] == 0 && write && !write_made)
            begin
              $display(" linha 211 entrei em L1_valid[index_L1][1] == 0 && write");
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
              new_bit_valid = 1; // Marca que foi feita a escrita em posicao invalida
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
                      $display("//////////linha 228vou atualizar LRU da L2 seu cachorro, i = %0d////////////", i);
                      atualiza_lru_l2(i);
                      write_made = 1; // Marca que foi feita a escrita no mesmo delta_cycle
                    end
                end
              // Retorna o dado escrito
              read_data   <= write_data;
            end

          else if (write && write_made == 0)
            begin
              if (L1_lru[index_L1][0] == 1) // Se a via 0 eh a LRU (mais velha)
                begin
                  L1_data[index_L1][0]  <= write_data;
                  L1_tag[index_L1][0]   <= tag;
                  L1_valid[index_L1][0] <= 1;
                  L1_lru[index_L1][0]   <= 0; // Atualiza LRU
                  if (L1_valid[index_L1][1] == 1) // Checagem opcional pois eh condicao impossivel
                    begin
                      L1_lru[index_L1][1] <= 1; // Atualiza LRU
                    end
                  // escrevendo na L2
                  // Checa se ainda existe posicao invalida na L2
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
                          new_bit_valid = 1; // Marca que foi feita a escrita em posicao invalida
                          atualiza_lru_l2(i);
                          write_made = 1; // Marca que foi feita a escrita no mesmo delta_cycle
                        end
                    end
                  // Checa se eh Write Back (cache cheia)
                  biggest_lru_l2_idx = biggest_lru_l2_index(0); // Pega o maior LRU da L2
                  if (L2_lru[biggest_lru_l2_idx] == 7 && L2_dirty[biggest_lru_l2_idx] == 0) // Se o maior LRU for 7, condicao nao necessaria, significa que L2 esta cheia
                    begin
                      L2_data[biggest_lru_l2_idx]  <= write_data;
                      L2_tag[biggest_lru_l2_idx]   <= address;
                      L2_valid[biggest_lru_l2_idx] <= 1;
                      L2_dirty[biggest_lru_l2_idx] <= 1; // Marca como dirty
                      read_data   <= write_data; // Retorna o dado escrito
                      atualiza_lru_l2(biggest_lru_l2_idx);
                      write_made = 1; // Marca que foi feita a escrita no mesmo delta_cycle
                      // Write Back
                    end 
                  else if (L2_lru[biggest_lru_l2_idx] == 7 && L2_dirty[biggest_lru_l2_idx] == 1)
                    begin
                      $display("HORA DE WRITE BACK CARA");
                      // Se nao esta cheia, coloca na posicao mais antiga
                      L2_data[biggest_lru_l2_idx]  <= write_data;
                      L2_tag[biggest_lru_l2_idx]   <= address;
                      L2_valid[biggest_lru_l2_idx] <= 1;
                      L2_dirty[biggest_lru_l2_idx] <= 0; // Marca como dirty
                      // Escrevendo na memoria principal
                      wren = 1'b1; // escrever da memoria mem_clock = 1'b1; // Ativa o clock da memoria
                      // dois ciclos para ler
                      mem_clock      = 1'b0; // Desativa o clock da memoria
                      #12 mem_clock  = 1'b1; // Ativa o clock da memoria
                      #12 mem_clock  = 1'b0; // Desativa o clock da memoria
                      #12 mem_clock  = 1'b1; // Ativa o clock da memoria
                      //#1 mem_clock = 1'b1; // Ativa o clock da memoria
                      #1 read_data <= wire_read_data;
                      // read_data   <= write_data; // Retorna o dado escrito
                      atualiza_lru_l2(biggest_lru_l2_idx);
                      write_made = 1; // Marca que foi feita a escrita no mesmo delta_cycle
                    end
                
                end
              else if (L1_lru[index_L1][1] == 1)
                begin
                  L1_data[index_L1][1]  <= write_data;
                  L1_tag[index_L1][1]   <= tag;
                  L1_valid[index_L1][1] <= 1;
                  L1_lru[index_L1][1]   <= 0; // Atualiza LRU
                  if (L1_valid[index_L1][0] == 1) // Checagem opcional pois eh condicao impossivel
                    begin
                      L1_lru[index_L1][0] <= 1; // Atualiza LRU
                    end
                  // escrevendo na L2
                  // Checa se ainda existe posicao invalida na L2
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
                          new_bit_valid = 1; // Marca que foi feita a escrita em posicao invalida
                          atualiza_lru_l2(i);
                          write_made = 1; // Marca que foi feita a escrita no mesmo delta_cycle
                        end
                    end
                  // Checa se eh Write Back (cache cheia)
                  // Checa se eh Write Back (cache cheia)
                  biggest_lru_l2_idx = biggest_lru_l2_index(0); // Pega o maior LRU da L2
                  if (L2_lru[biggest_lru_l2_idx] == 7 && L2_dirty[biggest_lru_l2_idx] == 0) // Se o maior LRU for 7, condicao nao necessaria, significa que L2 esta cheia
                    begin
                      L2_data[biggest_lru_l2_idx]  <= write_data;
                      L2_tag[biggest_lru_l2_idx]   <= address;
                      L2_valid[biggest_lru_l2_idx] <= 1;
                      L2_dirty[biggest_lru_l2_idx] <= 1; // Marca como dirty
                      read_data   <= write_data; // Retorna o dado escrito
                      atualiza_lru_l2(biggest_lru_l2_idx);
                      write_made = 1; // Marca que foi feita a escrita no mesmo delta_cycle
                      // Write Back
                    end 
                  else if (L2_lru[biggest_lru_l2_idx] == 7 && L2_dirty[biggest_lru_l2_idx] == 1)
                    begin
                      $display("HORA DE WRITE BACK CARA");
                      // Se nao esta cheia, coloca na posicao mais antiga
                      L2_data[biggest_lru_l2_idx]  <= write_data;
                      L2_tag[biggest_lru_l2_idx]   <= address;
                      L2_valid[biggest_lru_l2_idx] <= 1;
                      L2_dirty[biggest_lru_l2_idx] <= 0; // Marca como dirty
                      // Escrevendo na memoria principal
                      wren = 1'b1; // escrever da memoria mem_clock = 1'b1; // Ativa o clock da memoria
                      // dois ciclos para ler
                      mem_clock      = 1'b0; // Desativa o clock da memoria
                      #12 mem_clock  = 1'b1; // Ativa o clock da memoria
                      #12 mem_clock  = 1'b0; // Desativa o clock da memoria
                      #12 mem_clock  = 1'b1; // Ativa o clock da memoria
                      //#1 mem_clock = 1'b1; // Ativa o clock da memoria
                      #1 read_data <= wire_read_data;
                      // read_data   <= write_data; // Retorna o dado escrito
                      atualiza_lru_l2(biggest_lru_l2_idx);
                      write_made = 1; // Marca que foi feita a escrita no mesmo delta_cycle
                    end
                end
            end
         
          // Bits validos deprecated
         /*  else if (L1_valid[index_L1][0] == 1 && write && !write_made)
            begin
              $display("linha 298 Write Miss na L1, bit valido na via 0");
              if (L1_lru[index_L1][0] == 1) // Se a via 0 eh a LRU
              L1_data[index_L1][0]  <= write_data;
              L1_tag[index_L1][0]   <= tag;
              L1_valid[index_L1][0] <= 1;
              L1_lru[index_L1][0]   <= 0; // Atualiza LRU
              if (L1_valid[index_L1][1] == 1) // Checagem opcional
                begin
                  L1_lru[index_L1][1] <= 1; // Atualiza LRU
                end
              // escrevendo na L2
              // Checa se ainda existe posicao invalida na L2
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
                      new_bit_valid = 1; // Marca que foi feita a escrita em posicao invalida
                      atualiza_lru_l2(i);
                      write_made = 1; // Marca que foi feita a escrita no mesmo delta_cycle
                    end
                end
              if (!write_made)
                begin
                  $display("linha 328 to aqui,write_made, atualizando L2[big_lru]",);
                  // Se nao esta cheia, coloca na posicao mais antiga
                  L2_data[biggest_lru_l2_idx]  <= write_data;
                  L2_tag[biggest_lru_l2_idx]   <= address;
                  L2_valid[biggest_lru_l2_idx] <= 1;
                  L2_dirty[biggest_lru_l2_idx] <= 1; // Marca como dirty
                  read_data   <= write_data; // Retorna o dado escrito
                  atualiza_lru_l2(biggest_lru_l2_idx);
                  write_made = 1; // Marca que foi feita a escrita no mesmo delta_cycle
                end
              // Checa se eh Write Back (cache cheia)
              // biggest_lru_l2_idx = biggest_lru_l2_index(0); // Pega o maior LRU da L2
              // if (L2_lru[biggest_lru_l2_idx] == 7 && !write_made) // Se o maior LRU for 7, significa que L2 esta cheia
              //   begin
              //     // Write Back
              //   end
            end
 */
         /*  else if (L1_valid[index_L1][1] == 1 && write && !write_made)
            begin
              $display("linha 346 Write Miss na L1, bit valido na via 1");
              L1_data[index_L1][1]  <= write_data;
              L1_tag[index_L1][1]   <= tag;
              L1_valid[index_L1][1] <= 1;
              L1_lru[index_L1][1]   <= 0; // Atualiza LRU
              if (L1_valid[index_L1][0] == 1) // Checagem opcional
                begin
                  L1_lru[index_L1][0] <= 1; // Atualiza LRU
                end
              // escrevendo na L2
              // Checa se ainda existe posicao invalida na L2
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
                      new_bit_valid = 1; // ATRIBUA ANTES DE ATUALIZA_LRU Marca que foi feita a escrita em posicao invalida
                      atualiza_lru_l2(i);
                      write_made = 1; // Marca que foi feita a escrita no mesmo delta_cycle
                    end
                end
              // Checa se eh Write Back (cache cheia)
              biggest_lru_l2_idx = biggest_lru_l2_index(0); // Pega o maior LRU da L2
              if (L2_lru[biggest_lru_l2_idx] == 7) // Se o maior LRU for 7, significa que L2 esta cheia
                begin
                  // Write Back
                end
              else
                begin
                  $display("Se bit valid = 1 e via 1, escrita sem wb",write_made, i, L2_valid[i]);
                  // Se nao esta cheia, coloca na posicao mais antiga
                  L2_data[biggest_lru_l2_idx]  <= write_data;
                  L2_tag[biggest_lru_l2_idx]   <= address;
                  L2_valid[biggest_lru_l2_idx] <= 1;
                  L2_dirty[biggest_lru_l2_idx] <= 1; // Marca como dirty
                  read_data <= write_data;
                  atualiza_lru_l2(biggest_lru_l2_idx);
                  write_made = 1; // Marca que foi feita a escrita no mesmo delta_cycle
                end
            end
 */

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
                          if (L2_valid[i] == 0) // Checa se a linha esta livre ou se e a LRU remove
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
                      $display("entrei em !hit_L2 que nao deve ser possivel");
                      // wren = 1'b1; // Escreve na memoria
                      // // dois ciclos para escrever
                      // mem_clock = 1'b0; // Desativa o clock da memoria
                      // mem_clock = 1'b1; // Ativa o clock da memoria
                      // read_data <= wire_read_data;
                    end
                end
            end
        end
    end


  // lixo talvez util
  function integer valids_on_l2;
    input dummy_input;
    integer i_index, current_valids;
    begin
      current_valids = 0; // Inicializa a variavel
      for (i_index = 0; i_index < 8; i_index = i_index + 1)
        begin
          if (L2_valid[i_index] == 1)
            begin
              current_valids = current_valids + 1;
            end
          // $display("valids_on_l2 = %d", valids_on_l2);
        end
      if (new_bit_valid)
        begin
          valids_on_l2 = current_valids; // Se foi feita escrita em posicao invalida, incrementa o numero de valids
        end
      else
        begin
          valids_on_l2 = current_valids - 1; // Retorna o numero de valids na L2
        end
      // valids_on_l2 = current_valids; // Se foi feita escrita em posicao invalida, incrementa o numero de valids
    end
  endfunction



  function integer needs_to_update_l2;
    //  Verifica se precisa atualizar a LRU da L2, olhando se apareceu bit valido novo
    input dummy_input;
    integer i_index, valid_bits_on_l2;
    begin
      if (new_bit_valid)
        begin
          needs_to_update_l2 = 1; // Se foi feita escrita em posicao invalida, precisa atualizar a LRU
        end
      else
        begin
          needs_to_update_l2 = 0; // Se nao foi feita escrita em posicao invalida, nao precisa atualizar a LRU
        end
      /* valid_bits_on_l2 = valids_on_l2(0);
      needs_to_update_l2 = 1; // Inicializa a variavel
      for (i_index = 0; i_index < 8; i_index = i_index + 1)
        begin
          if (L2_lru[i_index]== valid_bits_on_l2)
            begin
              // $display("%0t L2_lru[%0d] = %1d, valid_bits_on_l2 = %1d", $time,i_index, L2_lru[i_index], valid_bits_on_l2);
              needs_to_update_l2 = 0;
            end
        end
        $display("%0t valid_bits_on_l2 = %1d", $time, valid_bits_on_l2);
        $display("%0t needs_to_update_l2 = %1d", $time, needs_to_update_l2); */
    end
  endfunction

  /* task atualiza_lru_l2_valid_bit;
    //  Atualiza a lru do conjunto
    input integer most_recent_index;
    integer i_index, need_update, biggest_lru_l2_idx, valid_bits_on_l2;
    begin
      valid_bits_on_l2 = valids_on_l2(0);
      biggest_lru_l2_idx = biggest_lru_l2_index(0); // Pega o maior LRU da L2
          for (i_index = 0; i_index < valid_bits_on_l2 ; i_index = i_index + 1)
            begin
              if (most_recent_index == i_index)
                begin
                  // $display("%1t Posicao resetada LRU da L2, most_recent_index = %1d i = %1d, L2_lru[i] = %d, L2_valid[i] = %d",$time,most_recent_index, i_index, L2_lru[i_index], L2_valid[i_index]);
                  L2_lru[i_index] <= 0;
                end
              else
                begin
                  if (L2_valid[i_index] == 1)
                    begin
                      // $display("%1t Posicao incrementada LRU da L2, most_recent_index = %1d i = %1d, L2_lru[i] = %d, L2_valid[i] = %d",$time, most_recent_index, i_index, L2_lru[i_index], L2_valid[i_index]);
                      L2_lru[i_index] <= L2_lru[i_index] + 1;
                    end
                end
            end
    end
  endtask
  */
  task atualiza_lru_l2;
    //  Atualiza a lru do conjunto
    input integer most_recent_index;
    integer i_index;
    integer need_update_new_bit; // Variavel para verificar se foi feita escrita em posicao invalida
    integer biggest_lru_l2_idx;
    integer valid_bits_on_l2;
    integer lru_temp [0:7];
    begin
      biggest_lru_l2_idx = biggest_lru_l2_index(0); // Pega o maior LRU da L2
      need_update_new_bit = needs_to_update_l2(0);
      valid_bits_on_l2 = valids_on_l2(0);
      // Verifica se todos os bits validos foram preenchidos
      $display("valid_bits_on_l2 = %d", valid_bits_on_l2);
      if (need_update_new_bit) //|| L2_lru[biggest_lru_l2_idx] == 7)
        begin
          for (i_index = 0; i_index < valid_bits_on_l2 ; i_index = i_index + 1)
            begin
              if (most_recent_index == i_index)
                begin
                  // $display("%1t Posicao resetada LRU da L2, most_recent_index = %1d i = %1d, L2_lru[i] = %d, L2_valid[i] = %d",$time,most_recent_index, i_index, L2_lru[i_index], L2_valid[i_index]);
                  L2_lru[i_index] <= 0;
                end
              else
                begin
                  if (L2_valid[i_index] == 1 && L2_lru[i_index] < valid_bits_on_l2)
                    begin
                      // $display("%1t Posicao incrementada LRU da L2, most_recent_index = %1d i = %1d, L2_lru[i] = %d, L2_valid[i] = %d",$time, most_recent_index, i_index, L2_lru[i_index], L2_valid[i_index]);
                      L2_lru[i_index] <= L2_lru[i_index] + 1;
                    end
                end
            end
        end
      // Com todos os bits validos preenchidos
      else if(valid_bits_on_l2 == 7)
        begin
          $display("linha 718 mudar LRU por aqui, valid_bits_on_l2 = %1d, most_recent_used %1d", valid_bits_on_l2, most_recent_index);
          // Atualiza com base no MRU
          // Copia os valores atuais
          for (i_index = 0; i_index < 8; i_index = i_index + 1)
              lru_temp[i_index] = L2_lru[i_index];

          for (i_index = 0; i_index < 8; i_index = i_index + 1)
            begin
              if (L2_valid[i_index])
                begin
                  if (i_index == most_recent_index)
                    begin
                      L2_lru[i_index] <= 0; // so no final do ciclo da update
                    end
                  else if (lru_temp[i_index] < lru_temp[most_recent_index])
                    begin
                      // Elementos menos recentemente usados incrementam
                      L2_lru[i_index] <= lru_temp[i_index] + 1;
                    end
                  else
                    begin
                      // Quem era mais novo que o atual MRU mantém seu valor
                      L2_lru[i_index] <= lru_temp[i_index];
                    end
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
