module cache_l1_2way (input clk,
                          input reset,
                          input [6:0] addr,     // enderecos de 7bits (5 bits)(1bit)(1bit)
                          input 	wren,        // 0 = leitura, 1 = escrita
                          input [16:0] data,    // palavra de entrada
                          output reg hit,
                          output reg [16:0] q); // bloco de palavra retornado de 16 bits

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
    reg [16:0] data_array[1:0][1:0];    // [set][way] = dados de 16 bits

    integer i, j;
    integer way;
    reg [1:0] set_has_invalid_pos;

    // Inicializacao / reset
    always @(posedge clk or posedge reset) begin
        // Reseta estrutura da cache
        if (reset) begin
            reset_cache();
        end
        else
        begin
            // Verificar se acontece escrita
            if (wren == 1'b1)begin
                set_has_invalid_pos = set_has_invalid_way();
                // Verificar se a posicao eh invalida
                if (set_has_invalid_pos[0])begin
                    write(way);
                    valid_bit[index][set_has_invalid_pos[1]] = 1'b1;
                    hit  <= 0;
                end
                else begin
                    // Atribuimos na memoria na posicao de maior lru
                    write(biggest_lru_way());
                    hit  <= 1;
                end
            end

            if (wren == 1'b0)begin
                // Verifica se algum dos dois blocos no conjunto corresponde
                if (valid_bit[index][0] && tag_array[index][0] == tag) begin
                    // Se a via 0 é válida e corresponde ao tag
                    // HIT: verifica se é leitura ou escrita
                    read_hit(0);
                    hit <= 1;
                end
                else if (valid_bit[index][1] && tag_array[index][1] == tag) begin
                    // Se a via 1 é válida e corresponde ao tag
                    read_hit(1);
                    hit <= 1;
                end
                else begin
                    // Miss: verifica se eh leitura ou escrita
                    hit <= 0;
                end
            end

        end

    end

    /*
     set_has_invalid_pos[0] = Se o conjunto possui via valida/invalida
     set_has_invalid_pos[1] = Qual via eh valida/invalida
     */

    function [1:0] set_has_invalid_way;
        input integer dummy;
        integer way;
        set_has_invalid_way = 0;
        begin
            for (way = 0; way < 2 ; way = way + 1) begin
                if (valid_bit[index][way] == 1'b0)
                    set_has_invalid_way = {1'b1, way};
            end
        end
    endfunction

    task reset_cache;
        integer i, j;
        begin
            for (i = 0; i < 2; i = i + 1) begin
                for (j = 0; j < 2; j = j + 1) begin
                    tag_array[i][j]  <= 5'b0; // reset de tag de cada via
                    valid_bit[i][j]  <= 1'b0; // reset de validade de cada via
                    LRU[i][j]        <= 1'b0; // reset de LRU de cada via
                    data_array[i][j] <= 16'b0; // reset de dados de cada via
                end
            end
            hit <= 0;
        end
    endtask

    task write;
        integer way;
        begin
            atualiza_lru(index, way);                         // Atualiza LRU
            tag_array[index][way]  <= tag;                    // Atualiza a Tag
            data_array[index][way] <= data;                   // Escreve na cache
            q                      <= data;                   // Retorna o dado escrito
        end
    endtask

    task read_hit;
        input way;
        //if (valid_bit[index][way] && tag_array[index][way] == tag)
        begin
            atualiza_lru(index, way);
            tag_array[index][way] <= tag;
            valid_bit[index][way] <= 1;
            q                     <= data_array[index][0];   // Retorna o dado lido
        end
    endtask

    task atualiza_lru;
        begin
            for (way = 0; way < 2; way = way + 1) begin
                if (way  != biggest_lru_way(index)) begin
                    if (valid_bit[index][way])
                        LRU[index][way] <= LRU[index][way] + 1;
                end
            end
        end
    endtask

    // importante para logica de quem sai
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
