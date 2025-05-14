// ImplementaÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â§ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â£o de hierarquia de memÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â³ria com cache L1, cache L2 e memÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â³ria principal
`timescale 1ns / 1ps

module hierarquia_memoria(
    input clock,
    input reset,
    input [15:0] address, // EndereÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â§o de 16 bits
    input [15:0] write_data, // Dados para escrita
    input read, // Sinal de leitura
    input write, // Sinal de escrita
    output reg [15:0] read_data, // Dados lidos
    output reg hit_L1, // Indica acerto na cache L1
    output reg hit_L2 // Indica acerto na cache L2
);

    // ParÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢metros para configuraÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â§ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â£o das memÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â³rias
    // Cache L1 com 4 linhas
    // Cache L2 com 8 linhas
    // MemÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â³ria principal com 64 palavras de 16 bits

    // Estrutura da cache L1 (associativa por conjunto de 2 vias)
    reg [15:0] L1_data[3:0][1:0]; // Dados
    reg [15:0] L1_tag[3:0][1:0]; // Tags
    reg L1_valid[3:0][1:0]; // Bits de validade
    reg L1_dirty[3:0][1:0]; // Bits "Dirty"
    reg L1_lru[3:0]; // Bit LRU para cada conjunto

    // Estrutura da cache L2 (totalmente associativa)
    reg [15:0] L2_data[7:0]; // Dados
    reg [15:0] L2_tag[7:0]; // Tags
    reg L2_valid[7:0]; // Bits de validade
    reg L2_dirty[7:0]; // Bits "Dirty"

    // Estrutura da memÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â³ria principal
    // reg [15:0] main_memory[63:0];
    // Instancia da memoria
	 reg wren;
	 /*
	 always @(write || read)
	 begin
    if (write) 
     begin
        wren = 1'b1; // Escreve na memoria 
		end 
    if (read)
		begin
        wren = 1'b0; // Le da memoria
		end
	end*/
	 
	 wire [15:0] wire_read_data;
	 reg mem_clock;

	 memoram main_memory (
    .address(address[5:0]), // Os 6 bits menos significativos do endereÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â§o
    .clock(mem_clock),         // Sinal de clock
    .data(write_data),     // Dados para escrita
    .wren(wren),          // Sinal de leitura/escrita
    .q(wire_read_data)         // Dados lidos
    );
	 
	 
	 

    // Divisao do endereco
    wire [3:0] index_L1 = address[5:2]; // Indice para a cache L1
    wire [11:0] tag = address[15:4]; // Tag do endereco

    // Controle de leitura/escrita
    integer i;

    always @(posedge clock or posedge reset) begin
      // read_data = wire_read_data;
        if (reset) begin
            // InicializaÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â§ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â£o das memÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â³rias
            for (i = 0; i < 4; i = i + 1) begin
                L1_valid[i][0] <= 0;
                L1_valid[i][1] <= 0;
                L1_dirty[i][0] <= 0;
                L1_dirty[i][1] <= 0;
                L1_lru[i] <= 0;
            end
            for (i = 0; i < 8; i = i + 1) begin
                L2_valid[i] <= 0;
                L2_dirty[i] <= 0;
            end
        end else begin
            // OperaÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â§ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â£o de leitura/escrita
            hit_L1 = 0;
            hit_L2 = 0;

            // Verifica a cache L1
            if (L1_valid[index_L1][0] && L1_tag[index_L1][0] == tag) begin
                hit_L1 = 1;
                if (read) begin
                    read_data <= L1_data[index_L1][0];
                end
                if (write) begin
                    L1_data[index_L1][0] = write_data;
                    L1_dirty[index_L1][0] = 1;
                end
                L1_lru[index_L1] = 1; // Atualiza LRU
            end else if (L1_valid[index_L1][1] && L1_tag[index_L1][1] == tag) begin
                hit_L1 = 1;
                if (read) begin
                    read_data <= L1_data[index_L1][1];
                end
                if (write) begin
                    L1_data[index_L1][1] = write_data;
                    L1_dirty[index_L1][1] = 1;
                end
                L1_lru[index_L1] = 0; // Atualiza LRU
            end else begin
                // Falha na cache L1, verifica a cache L2
                for (i = 0; i < 8; i = i + 1) begin
                    if (L2_valid[i] && L2_tag[i] == tag) begin
                        hit_L2 = 1;
                        if (read) begin
                            read_data <= L2_data[i];
                        end
                        if (write) begin
                            L2_data[i] = write_data;
                            L2_dirty[i] = 1;
                        end
                       // break;
                    end
                end

                if (!hit_L2) begin
                    // Falha na cache L2, acessa a memÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â³ria principal
                    if (read) begin
                      wren = 1'b0; // ler da memoria                      mem_clock = 1'b1; // Ativa o clock da memoria
                      // dois ciclos para ler
                      mem_clock = 1'b0; // Desativa o clock da memoria
                     #12 mem_clock = 1'b1; // Ativa o clock da memoria
                     #12 mem_clock = 1'b0; // Desativa o clock da memoria
                     #12 mem_clock = 1'b1; // Ativa o clock da memoria 
                      //#1 mem_clock = 1'b1; // Ativa o clock da memoria
                     
                      #1 read_data <= wire_read_data;
                    end
                    if (write) begin
                      // Fazer WB
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
endmodule