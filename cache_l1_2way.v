module cache_l1_2way (
    input clk,
    input reset,
    input [6:0] addr, // enderecos de 7bits (5 bits)(1bit)(1bit)
	 input 		 wren, // 0 = leitura, 1 = escrita
	 input [16:0] data, // palavra de entrada
    output reg hit,
	 output reg [16:0] q // bloco de palavra retornado de 16 bits
);

	// L1 : 4 blocos, blocos por conjunto, write_through
	// L2 : 8 blocos, totalmente associativa
	// principal:


    // Extracao de partes do endereco
    wire [4:0]  tag = addr[6:2];   // 5 bits de tag
    wire        index = addr[1];   // 1 bit de Ã­ndice (2 conjuntos)
    wire        offset = addr[0];  // 1 bit de offset (2 bytes por bloco)

    // Estrutura da cache: 2 conjuntos, 2 vias
    reg [4:0]  tag_array[1:0][1:0];     // [set][way] = tag de 5 bits da via
    reg        valid_bit[1:0][1:0];     // [set][way] = valido
	reg        LRU[1:0][1:0];           // [set][way] = Least Recently Used
    reg [16:0] data_array[1:0][1:0];    // [set][way] = dados de 16 bits

    integer i, j;
    integer way;

    // Inicializacao / reset
    always @(posedge clk or posedge reset) begin
	 // Reseta estrutura da cache
        if (reset) begin
            reset_cache();
        end
        else 
        begin
        // Verifica se algum dos dois blocos no conjunto corresponde
            for (way = 0; way < 2; way = way + 1) 
            begin
                if (valid_bit[index][way] && tag_array[index][way] == tag) 
                begin
                    if (wren == 1'b1)
                        write_hit(way);
                    else
                    hit <= 1;
                end
            end
            
            
            if (valid_bit[index][0] && tag_array[index][0] == tag) 
            begin
                // Se a via 0 é válida e corresponde ao tag
                // HIT: verifica se é leitura ou escrita
                if (wren == 1'b1) 
                begin
                    // Se é Escrita
                    tag_array[index][0]  <= tag;
                    LRU[index][0]        <= 0;                      // Atualiza LRU
                    data_array[index][0] <= data;                   // Escreve na cache
                    q                    <= data_array[index][0];   // Retorna o dado escrito
                end 
                else
                begin
                    // Se é Leitura
                    tag_array[index][0]  <= tag;
                    valid_bit[index][0]  <= 1;
                    LRU[index][0]        <= 1;                      // Atualiza LRU
                    data_array[index][0] <= data_array[index][0];   // Retorna o dado lido
                    q                    <= data_array[index][0];   // Retorna o dado lido
                end
                // end
                hit <= 1;
            end
            else 
                if (valid_bit[index][1] && tag_array[index][1] == tag) 
                begin
                    hit <= 1;
                end 
            else 
            begin
                // MISS: carregamos o novo bloco em uma via livre ou sobrescrevemos a via 0
                hit <= 0;
                if (!valid_bit[index][0]) 
                begin
                    tag_array[index][0] <= tag;
                    valid_bit[index][0] <= 1;
                end 
                else if (!valid_bit[index][1]) 
                begin
                    tag_array[index][1] <= tag;
                    valid_bit[index][1] <= 1;
                end
                else 
                begin
                    // Substituicao simples: sobrescreve via 0 (sem LRU)
                    tag_array[index][0] <= tag;
                    valid_bit[index][0] <= 1;
                end
            end
        end
    end

    task reset_cache;
        integer i, j;
        begin
            for (i = 0; i < 2; i = i + 1) begin
                for (j = 0; j < 2; j = j + 1) begin
                    tag_array[i][j]  <= 14'b0; // reset de tag de cada via
                    valid_bit[i][j]  <= 1'b0; // reset de validde de cada via
                          LRU[i][j]  <= 1'b0; // reset de LRU de cada via
                    data_array[i][j] <= 16'b0; // reset de dados de cada via
                end
            end
            hit <= 0;
        end
    endtask

    task write_hit_valid;
        input way;
        //if (valid_bit[index][way] && tag_array[index][way] == tag)
        begin
            atualiza_lru(index, way);
            tag_array[index][way]  <= tag;
            data_array[index][way] <= data;                   // Escreve na cache
            q                      <= data_array[index][0];   // Retorna o dado escrito
        end
    endtask

    task read_hit;
        input way;
        //if (valid_bit[index][way] && tag_array[index][way] == tag)
        begin
            atualiza_lru(index, way);
            tag_array[index][way]  <= tag;
            valid_bit[index][way]  <= 1;
            q                      <= data_array[index][0];   // Retorna o dado lido
        end
    endtask

    task atualiza_lru;
        input integer index;
        input integer way;
        begin
            for (way = 0; way < 2; way = way + 1) begin
                if (way != biggest_lru_way(index)) begin
                    LRU[index][way] <= LRU[index][way] + 1;
                end
            end
        end
    endtask

    function integer biggest_lru_way;
        input integer index;
        integer way;
        begin
            biggest_lru_way = 0;
            for (way = 0; way < 2; way = way + 1) begin
                if (LRU[index][way] > LRU[index][biggest_lru_way])
                    biggest_lru_way = way;
            end
        end
    endfunction


endmodule
