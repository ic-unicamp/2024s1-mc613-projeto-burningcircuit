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