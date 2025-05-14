module cache_l1_2way (input clk,
                        input reset,
                        input [6:0] addr,     // enderecos de 7bits (5 bits)(1bit)(1bit)
                        input 	wren,        // 0 = leitura, 1 = escrita
                        input [15:0] data,    // palavra de entrada
                        output reg hit,
                        output reg [15:0] q); // bloco de palavra retornado de 16 bits

  // L1 : 4 blocos, blocos por conjunto, write_through
  // L2 : 8 blocos, totalmente associativa
  // principal:
 

  // Extracao de partes do endereco
  wire [4:0]  tag    = addr[6:2];   // 5 bits de tag
  wire        index  = addr[1];   // 1 bit de i­ndice (2 conjuntos)
  wire        offset = addr[0];  // 1 bit de offset (2 bytes por bloco)

  // Estrutura da cache: 2 conjuntos, 2 vias
  reg [4:0]  tag_array[1:0][1:0];     // [set][way] = tag de 5 bits da via
  reg        valid_bit[1:0][1:0];     // [set][way] = valido
  reg        LRU[1:0][1:0];           // [set][way] = Least Recently Used
  reg [15:0] data_array[1:0][1:0];    // [set][way] = dados de 16 bits

  integer achou; // se achou no conjunto (alternativa no lugar de break)
  integer i, j, dummy;
  integer way;
  reg [1:0] set_has_invalid_pos;

  // Inicializacao / reset
  always @(posedge clk or posedge reset)
    begin
      // Reseta estrutura da cache
      if (reset)
        begin
          reset_cache();
        end
      else
        begin
          // Verifica se algum dos blocos no conjunto corresponde esta valido e possui tag correta
          achou = 0;
          for (way = 0; way < 2; way = way + 1)
            begin
              // Verificar se acontece escrita
              if (wren == 1'b1)
                begin
                  // Tag no conjunto
                  if (!achou && tag_array[index][way] == tag)
                    begin
                      // Tag valida
                      if (valid_bit[index][way] == 1'b1)
                        begin
                          begin
                            atualiza_lru(way);                         				// Atualiza LRU
                            tag_array[index][way]  <= tag;                    // Atualiza a Tag
                            data_array[index][way] <= data;                   // Escreve na cache
                            q                      <= data;
                            hit                    <= 1;                // Retorna o dado escrito
                          end
                        end
                      // Tag invalida
                      if (valid_bit[index][way] == 1'b0)
                        begin
                          begin
                            atualiza_lru(way);                         				// Atualiza LRU
                            valid_bit[index][way]    <= 1;
                            tag_array[index][way]    <= tag;                    // Atualiza a Tag
                            data_array[index][way]   <= data;                   // Escreve na cache
                            q                        <= data;                   // Retorna o dado escrito
                            hit                      <= 0;
                          end
                        end
                      achou = 1;
                    end
                end
              if (wren == 1'b0)
                // Leitura
                begin
                  if (!achou && tag_array[index][way] == tag)
                    begin
                      // Tag valida
                      if (valid_bit[index][way] == 1'b1)
                        begin
                          begin
                            atualiza_lru(way);                         				// Atualiza LRU
                            valid_bit[index][way]  <= 1;
                            tag_array[index][way]  <= tag;                    // Atualiza a Tag
                            q                      <= data_array[index][way];
                            hit                    <= 1;                // Retorna o dado escrito
                          end
                        end
                      // Tag invalida
                      if (valid_bit[index][way] == 1'b0)
                        begin
                          begin
                            atualiza_lru(way);                         				// Atualiza LRU
                            tag_array[index][way]    <= tag;                    // Atualiza a Tag
                            data_array[index][way]   <= data;                   // Escreve na cache
                            q                        <= data;                   // Retorna o dado escrito
                            hit                      <= 0;
                          end
                        end
                      achou = 1;
                    end
                end
            end
        end

    end

  /*
   set_has_invalid_pos[0] = Se o conjunto possui via valida/invalida
   set_has_invalid_pos[1] = Qual via eh valida/invalida
   */


  task reset_cache;
    integer i, j;
    begin
      for (i = 0; i < 2; i = i + 1)
        begin
          for (j = 0; j < 2; j = j + 1)
            begin
              tag_array[i][j]  <= 5'b0; // reset de tag de cada via
              valid_bit[i][j]  <= 1'b0; // reset de validade de cada via
              LRU[i][j]        <= 1'b0; // reset de LRU de cada via
              data_array[i][j] <= 16'b0; // reset de dados de cada via
            end
        end
      hit <= 0;
    end
  endtask

  task atualiza_lru;
    //  Atualiza a lru do conjunto
    input least_recent_way;
    integer i_way;
    begin
      for (i_way = 0; i_way < 2 ; i_way = i_way + 1)
        begin
          if (least_recent_way == i_way)
            begin
              LRU[index][least_recent_way] = 0;
            end
          else
            begin
              LRU[index][i_way] = 0;
            end
        end
    end
  endtask

  function [1:0]
    set_has_invalid_way;
    input dummy;
    integer way;
    begin
      set_has_invalid_way = 0;
      for (way = 0; way < 2 ; way = way + 1)
        begin
          if (valid_bit[index][way] == 1'b0)
            set_has_invalid_way = {1'b1, way};
        end
    end
  endfunction


  // importante para logica de quem sai
  function integer biggest_lru_way;
    input integer dummy;
    integer i_way;
    begin
      biggest_lru_way = 0;
      for (i_way = 0; i_way < 2; i_way = i_way + 1)
        begin
          if (LRU[index][i_way] > LRU[index][biggest_lru_way])
            biggest_lru_way = i_way;
        end
    end
  endfunction


endmodule
