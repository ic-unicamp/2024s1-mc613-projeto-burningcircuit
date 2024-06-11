module conversao(
    input reset,
    input [9:0] score1,
    input [9:0] score2,
    input [3:0] dig0_dec, 
    input [3:0] dig1_dec,
    input [3:0] dig2_dec,
    input [3:0] dig3_dec,
    input [3:0] dig4_dec,
    input [3:0] dig5_dec,
    output [6:0] digito0, // digito da direita
    output [6:0] digito1,
    output [6:0] digito2,
    output [6:0] digito3,
    output [6:0] digito4,
    output [6:0] digito5 // digito da esquerda
  );

    reg [6:0] digito0_tmp, digito1_tmp, digito2_tmp, digito3_tmp, digito4_tmp, digito5_tmp;
    
    //Conversão de decimal para 7 segmentos

    always @(*) begin
      if (reset) begin
        digito0_tmp = 7'b1111111;
        digito1_tmp = 7'b1111111;
        digito2_tmp = 7'b1111111;
        digito3_tmp = 7'b1111111;
        digito4_tmp = 7'b1111111;
        digito5_tmp = 7'b1111111;
      end else begin
        case (dig0_dec)
          4'b0000: digito0_tmp = 7'b1000000;
          4'b0001: digito0_tmp = 7'b1111001;
          4'b0010: digito0_tmp = 7'b0100100;
          4'b0011: digito0_tmp = 7'b0110000;
          4'b0100: digito0_tmp = 7'b0011001;
          4'b0101: digito0_tmp = 7'b0010010;
          4'b0110: digito0_tmp = 7'b0000011;
          4'b0111: digito0_tmp = 7'b1111000;
          4'b1000: digito0_tmp = 7'b0000000;
          4'b1001: digito0_tmp = 7'b0011000;
          default: digito0_tmp = 7'b1111111;
        endcase

        if(score2 < 10)begin
          digito1_tmp = 7'b1111111;
        end
        else begin
          case (dig1_dec)
            4'b0000: digito1_tmp = 7'b1000000;
            4'b0001: digito1_tmp = 7'b1111001;
            4'b0010: digito1_tmp = 7'b0100100;
            4'b0011: digito1_tmp = 7'b0110000;
            4'b0100: digito1_tmp = 7'b0011001;
            4'b0101: digito1_tmp = 7'b0010010;
            4'b0110: digito1_tmp = 7'b0000011;
            4'b0111: digito1_tmp = 7'b1111000;
            4'b1000: digito1_tmp = 7'b0000000;
            4'b1001: digito1_tmp = 7'b0011000;
            default: digito1_tmp = 7'b1111111;
          endcase
        end

        if(score2 < 100)begin
          digito2_tmp = 7'b1111111;
        end
        else begin
          case (dig2_dec)
            4'b0000: digito2_tmp = 7'b1000000;
            4'b0001: digito2_tmp = 7'b1111001;
            4'b0010: digito2_tmp = 7'b0100100;
            4'b0011: digito2_tmp = 7'b0110000;
            4'b0100: digito2_tmp = 7'b0011001;
            4'b0101: digito2_tmp = 7'b0010010;
            4'b0110: digito2_tmp = 7'b0000011;
            4'b0111: digito2_tmp = 7'b1111000;
            4'b1000: digito2_tmp = 7'b0000000;
            4'b1001: digito2_tmp = 7'b0011000;
            default: digito2_tmp = 7'b1111111;
          endcase
        end

        case (dig3_dec)
          4'b0000: digito3_tmp = 7'b1000000;
          4'b0001: digito3_tmp = 7'b1111001;
          4'b0010: digito3_tmp = 7'b0100100;
          4'b0011: digito3_tmp = 7'b0110000;
          4'b0100: digito3_tmp = 7'b0011001;
          4'b0101: digito3_tmp = 7'b0010010;
          4'b0110: digito3_tmp = 7'b0000011;
          4'b0111: digito3_tmp = 7'b1111000;
          4'b1000: digito3_tmp = 7'b0000000;
          4'b1001: digito3_tmp = 7'b0011000;
          default: digito3_tmp = 7'b1111111;
        endcase

        if(score1 < 10)begin
          digito4_tmp = 7'b1111111;
        end
        else begin
          case (dig4_dec)
            4'b0000: digito4_tmp = 7'b1000000;
            4'b0001: digito4_tmp = 7'b1111001;
            4'b0010: digito4_tmp = 7'b0100100;
            4'b0011: digito4_tmp = 7'b0110000;
            4'b0100: digito4_tmp = 7'b0011001;
            4'b0101: digito4_tmp = 7'b0010010;
            4'b0110: digito4_tmp = 7'b0000011;
            4'b0111: digito4_tmp = 7'b1111000;
            4'b1000: digito4_tmp = 7'b0000000;
            4'b1001: digito4_tmp = 7'b0011000;
            default: digito4_tmp = 7'b1111111;
          endcase
        end

        if(score1 < 100)begin
          digito5_tmp = 7'b1111111;
        end
        else begin
          case (dig5_dec)
            4'b0000: digito5_tmp = 7'b1000000;
            4'b0001: digito5_tmp = 7'b1111001;
            4'b0010: digito5_tmp = 7'b0100100;
            4'b0011: digito5_tmp = 7'b0110000;
            4'b0100: digito5_tmp = 7'b0011001;
            4'b0101: digito5_tmp = 7'b0010010;
            4'b0110: digito5_tmp = 7'b0000011;
            4'b0111: digito5_tmp = 7'b1111000;
            4'b1000: digito5_tmp = 7'b0000000;
            4'b1001: digito5_tmp = 7'b0011000;
            default: digito5_tmp = 7'b1111111;
          endcase
        end
      end
    end    

    assign  digito0 = digito0_tmp;
    assign  digito1 = digito1_tmp;
    assign  digito2 = digito2_tmp;
    assign  digito3 = digito3_tmp;
    assign  digito4 = digito4_tmp;
    assign  digito5 = digito5_tmp;

endmodule