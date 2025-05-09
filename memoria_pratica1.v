// Dupla: Giovanni Suriani e Thalles Vercosa

module memoria_pratica1(
    input [17:0] SW, // Chavinhas
    output [0:6] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, // Display 7 segmentos
    output [17:0] LEDR  // LEDs vermelhos
	 
);


// Atribuicao sinal de clock
assign clock = SW[0];
assign LEDR [0] = clock;

// Atribuicao dos sinais especificos da memoria

// Atribuicao leitura ou escrita
assign wren = SW[1];

// Atribuicao address
wire [4:0] address_full;           
wire [3:0] address_display;
assign address_full = SW[6:2]; //5bits
assign address_display = address_full[3:0]; //4bits

// Atribuicao data
wire [10:0] data; // 11bits
wire [15:0] data_full; // 16bits
wire [3:0] data_display;
assign data = SW[17:7]; //11bits
assign data_full = {5'b00000,data}; // concatena com 5 zeros para fechar 16bits
assign data_display = data[3:0];


reg [6:0] reg_wren;
assign HEX3 = reg_wren;



// Trocar no display o L por E no display
always @(wren)
begin
    if (wren == 1'b1) 
	 begin
        reg_wren <= 7'b0110000; // Escreve da memoria 
    end 
    if (wren == 1'b0)
    begin
        reg_wren <= 7'b1110001; // Le da memoria
    end
end 


wire [15:0] q; // leitura da memoria


// Instancia da memoria
 memoram mem (
  .address(address_full),
  .clock(clock),
  .data(data_full),
  .wren(wren),
  .q(q)
 );

Display D0(
    .result(q[3:0]),
    .HEX(HEX0)
);
Display D1(
    .result(data_display),
    .HEX(HEX1)
);
Display D2(
    .result(address_display),
    .HEX(HEX2)
);

/*
Display D3(
    .result(reg_wren),
    .HEX(HEX3)
);

Display D4(
    .result(data_full[3:0]),
    .HEX(HEX4)
);

Display D5(
    .result(data_full[7:4]),
    .HEX(HEX5)
);
Display D6(
    .result(data_full[11:8]),
    .HEX(HEX6)
);
Display D7(
    .result(data_full[15:12]),
    .HEX(HEX7)
);*/


endmodule 