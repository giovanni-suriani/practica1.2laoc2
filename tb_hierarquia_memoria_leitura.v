`timescale 1ps / 1ps

module tb_hierarquia_memoria_leitura;

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
    always begin
        #50 clock = ~clock; // Gera um clock de 10ns
    end

    // Estímulos do testbench
    initial begin
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

        // Teste 1: Leitura da L1 (sem dados) -> verifica a L2, pega do arquivo.mif
        address = 6'b0000_01;
        read = 1;
        $display("[%0t] ---- Teste 1: Leitura da L1, deve verificar L2 que falha e pegar dados do .mif ----", $time);
        $display("[%0t] Lendo da L1 sem dados: Addr = %h, read = %b", $time, address, read);
        #100;
        $display("[%0t] Read_Data = %h | hit_L1 = %b | hit_L2 = %b", $time, read_data, hit_L1, hit_L2);
        $display("[%0t] Esperado do .mif = 0001 | hit_L1 = 0 | hit_L2 = 0", $time);
        read = 0;
        $display("");

        // Teste 2: Leitura da L1 (agora com os dados),
        #100;
        address = 6'b0000_01;
        read = 1;
        $display("[%0t] ---- Teste 2: Hit na Leitura de L1 ----", $time);
        $display("[%0t] Lendo da L1 com dados: Addr = %h, read = %b", $time, address, read);
        #100;
        $display("[%0t] Read_Data = %h | hit_L1 = %b | hit_L2 = %b", $time, read_data, hit_L1, hit_L2);
        $display("[%0t] Esperado do .mif = 0001 | hit_L1 = 1 | hit_L2 = 0", $time);
        read = 0;
        $display("");

        // Teste 3: Preenchendo a L1 e L2
        $display("[%0t] ---- Teste3: LRU (em read miss), valid e tag em todas posicoes ----", $time);
        $display("[%0t] ---- A proxima sequencia busca encher a L1 com 7 posicoes (8 no total na l2)----", $time);
        preencher_L1_L2;
        situacao_L1;

        // Teste 4: LRU apos read_hit na l1 nos dois conjuntos
        // teste4;

        // Teste 5: Leitura de L1, read_miss na l1 e read_hit na l2
        #100;
        // Leitura no conjunto 1
        address = 6'b0000_01; // 1
        read = 1;
        $display("[%0t] ---- Teste 5: Leitura de L1, read_miss na l1 e read_hit na l2 nos dois conjuntos----", $time);
        $display("[%0t] Lendo da L1, Addr = %d, read = %b", $time, address, read);
        #100;
        $display("[%0t] Read_Data = %d | hit_L1 = %b | hit_L2 = %b", $time, read_data, hit_L1, hit_L2);
        $display("[%0t] Esperado do .mif = 1 | hit_L1 = 0 | hit_L2 = 1", $time);
        #100;
        address = 6'b0000_10; // 2
        read = 1;
        $display("[%0t] Lendo da L1, Addr = %d, read = %b", $time, address, read);
        #100;
        $display("[%0t] Read_Data = %d | hit_L1 = %b | hit_L2 = %b", $time, read_data, hit_L1, hit_L2);
        $display("[%0t] Esperado do .mif = 2 | hit_L1 = 0 | hit_L2 = 1", $time);
        situacao_L1;

        
    end

    task teste4 ;
      begin
         #100;
        // Leitura no conjunto 0, (via 0 a mais antiga [20])
        address = 6'b0101_00; // 22
        read = 1;
        #100;
        $display("[%0t] ---- Teste4: LRU apos read_hit na l1 nos dois conjuntos ----", $time);
        $display("[%0t] Lendo da L1, Addr = %d, read = %b", $time, address, read);
        $display("[%0t] Read_Data = %d | hit_L1 = %b | hit_L2 = %b", $time, read_data, hit_L1, hit_L2);
        $display("[%0t] Esperado do .mif = 22 | hit_L1 = 1 | hit_L2 = 0", $time);
        situacao_L1;
        // Leitura no conjunto 1, via (0 a mais antiga[19])
        address = 6'b0100_11; // 19
        read = 1;
        #100;
        $display("[%0t] Lendo da L1, Addr = %d, read = %b", $time, address, read);
        $display("[%0t] Read_Data = %d | hit_L1 = %b | hit_L2 = %b", $time, read_data, hit_L1, hit_L2);
        $display("[%0t] Esperado do .mif = 19 | hit_L1 = 1 | hit_L2 = 0", $time);
        situacao_L1;
      end
    endtask

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

    task situacao_esperada_momento1_L1;
        begin
            $display("[%0t] ---- Situacao da cache L1 ----", $time);
            $display("[%0t] Conjunto 0| Via 0 |  Tag | V  | LRU | Data  ", $time);
            $display("[%0t]                   | 10   | 1  |  1  | 20  ", $time) ;
            $display("[%0t] Conjunto 0| Via 1 |  Tag | V  | LRU | Data  ", $time);
            $display("[%0t]                   | 11  | 1  |  0  | 20  ", $time) ;
            $display("[%0t] Conjunto 1| Via 0 |  Tag | V  | LRU | Data  ", $time);
            $display("[%0t]                   | 9   | 1  |  1 | 19  ", $time) ;
            $display("[%0t] Conjunto 1| Via 1 |  Tag | V  | LRU | Data  ", $time);
            $display("[%0t]                   | 15   | 1  |  0  | 31  ", $time) ;
            $display("[%0t] ---- Fim da situacao da cache L1 ----", $time);
        end
    endtask

endmodule
