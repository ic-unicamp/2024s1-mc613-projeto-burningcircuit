// wires
wire [9:0] score1, score2;
wire [3:0] dig0_dec, dig1_dec, dig2_dec, dig3_dec, dig4_dec, dig5_dec;

// instanciando
  display display (
    .entrada_score1(score1),
    .entrada_score2(score2),
    .dig0(dig0_dec),
    .dig1(dig1_dec),
    .dig2(dig2_dec),
    .dig3(dig3_dec),
    .dig4(dig4_dec),
    .dig5(dig5_dec)
  );

  conversao conversao (
    .score1(score1),
    .score2(score2),
    .dig0_dec(dig0_dec),
    .dig1_dec(dig1_dec),
    .dig2_dec(dig2_dec),
    .dig3_dec(dig3_dec),
    .dig4_dec(dig4_dec),
    .dig5_dec(dig5_dec),
    .digito0(HEX0),
    .digito1(HEX1),
    .digito2(HEX2),
    .digito3(HEX3),
    .digito4(HEX4),
    .digito5(HEX5)
  );

  /* Jogador 1

    .score2(score2) na chamada

    dentro do modulo:
        output [9:0] score2 

        reg [9:0] score2_reg;
        assign score2 = score2_reg;

        score2_reg = 0 no reset

        quando jogador1 colidir, score2 = score2 + 1
         */

  /* Jogador 2

    .score1(score1) na chamada

    dentro do modulo:
        output [9:0] score1 

        reg [9:0] score1_reg;
        assign score1 = score1_reg;

        score1_reg = 0 no reset

        quando jogador2 colidir, score1 = score1 + 1
         */

module display(
    input [9:0] entrada_score1,
    input [9:0] entrada_score2,
    input reset,
    output [3:0] dig0, 
    output [3:0] dig1,
    output [3:0] dig2,
    output [3:0] dig3,
    output [3:0] dig4,
    output [3:0] dig5 
  );

    //Seta os valores de cada digito em decimal

    reg [2:0] i;
    reg [3:0] digito_atual, dig0_tmp, dig1_tmp, dig2_tmp, dig3_tmp, dig4_tmp, dig5_tmp;
    reg [19:0] entrada_tmp_score1, entrada_tmp_score2;

    always @(*) begin
      if (reset) begin
        dig0_tmp = 0;
        dig1_tmp = 0;
        dig2_tmp = 0;
        dig3_tmp = 0;
        dig4_tmp = 0;
        dig5_tmp = 0;
      end else begin
        //Score do jogador 1
        entrada_tmp_score1 = entrada_score1;
        i = 0;
        if (entrada_score1 == 0 || entrada_score1 === 10'bxxxxxxxxx) begin
          dig3_tmp = 0;
        end
        else begin
          while (i <= 2) begin   
            digito_atual = entrada_tmp_score1 % 10;
            case (i) 
              3'b000: dig3_tmp = digito_atual;
              3'b001: dig4_tmp = digito_atual;
              3'b010: dig5_tmp = digito_atual;
              default:
              begin
                dig3_tmp = 0;
                dig4_tmp = 0;
                dig5_tmp = 0;
              end
            endcase
            entrada_tmp_score1 = entrada_tmp_score1 / 10;
            i = i + 1;
          end
        end


        //Score do jogador 2
        entrada_tmp_score2 = entrada_score2;
        i = 0;
        if (entrada_score2 == 0 || entrada_score2 === 10'bxxxxxxxxx) begin
          dig0_tmp = 0;
        end
        else begin
          while (i <= 2) begin   
            digito_atual = entrada_tmp_score2 % 10;
            case (i) 
              3'b000: dig0_tmp = digito_atual;
              3'b001: dig1_tmp = digito_atual;
              3'b010: dig2_tmp = digito_atual;
              default:
              begin
                dig0_tmp = 0;
                dig1_tmp = 0;
                dig2_tmp = 0;
              end
            endcase
            entrada_tmp_score2 = entrada_tmp_score2 / 10;
            i = i + 1;
          end
        end
      end
    end

    assign dig0 = dig0_tmp;
    assign dig1 = dig1_tmp;
    assign dig2 = dig2_tmp;
    assign dig3 = dig3_tmp;
    assign dig4 = dig4_tmp;
    assign dig5 = dig5_tmp;

endmodule


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