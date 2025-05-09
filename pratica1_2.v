module pratica1_2(
    input [17:0] SW, // Chavinhas
    output [0:6] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, // Display 7 segmentos
    output [17:0] LEDR  // LEDs vermelhos 
);

wire [3:0] data;
assign data = SW[4:0]; // concatena com 5 zeros para fechar 16bits

// L1 : 4 blocos, 2 blocos por conjunto ()
// L2 : 8 blocos, totalmente associativa
// principal: 64 blocos (6bits de tag)
// palavra: 16bits (1bit offset)
// 


Display D4(
    .result(data[3:0]),
    .HEX(HEX0)
);

endmodule 