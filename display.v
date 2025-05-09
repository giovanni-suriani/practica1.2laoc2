module Display(
    input [3:0] result, // Entrada de 4 bits representando o valor a ser exibido
    output reg [6:0] HEX // SaÃ­da de 7 bits para controlar os segmentos do display
);
    
    // Bloco sempre sensÃ­vel a qualquer mudanÃ§a na entrada 'result'
   always @(*) begin
    case (result)
		  4'b0000: HEX = 7'b0000001; // 0
        4'b0001: HEX = 7'b1001111; // 1
        4'b0010: HEX = 7'b0010010; // 2
        4'b0011: HEX = 7'b0000110; // 3
        4'b0100: HEX = 7'b1001100; // 4
        4'b0101: HEX = 7'b0100100; // 5
        4'b0110: HEX = 7'b0100000; // 6
        4'b0111: HEX = 7'b0001101; // 7
        4'b1000: HEX = 7'b0000000; // 8
        4'b1001: HEX = 7'b0000100; // 9
        4'b1010: HEX = 7'b0001000; // A
        4'b1011: HEX = 7'b1100000; // b
        4'b1100: HEX = 7'b0110001; // C
        4'b1101: HEX = 7'b1000010; // d
        4'b1110: HEX = 7'b0110000; // E
        4'b1111: HEX = 7'b0111000; // F
    endcase
end
endmodule
