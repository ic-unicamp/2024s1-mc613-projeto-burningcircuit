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


module vga(
  input CLOCK_50,
  input [9:0] SW,
  input wren,
  input [7:0] input_red,
  input [7:0] input_green,
  input [7:0] input_blue,
  output reg VGA_CLK,
  output VGA_SYNC_N,
  output VGA_BLANK_N,
  output VGA_HS,
  output VGA_VS,
  output [7:0] VGA_R,     // RED (to resistor DAC VGA connector)
  output [7:0] VGA_G,   // GREEN (to resistor DAC to VGA connector)
  output [7:0] VGA_B,    // BLUE (to resistor DAC to VGA connector)
  output [9:0] next_x,  // x-coordinate of NEXT pixel that will be drawn
  output [9:0] next_y  // y-coordinate of NEXT pixel that will be drawn
);


  reg [9:0] x;
  reg [9:0] y;
  wire ativo;

  always @(posedge CLOCK_50) begin
    if (SW[0]) begin
      VGA_CLK <= 0;
    end else begin
      VGA_CLK <= ~VGA_CLK;
    end
  end

  always @(posedge VGA_CLK) begin
    if (SW[0]) begin
      x = 0;
      y = 0;
    end else begin
      x = x + 1;
      if (x == 800) begin
        x = 0;
        y = y + 1;
        if (y == 525) begin
          y = 0;
        end
      end
    end
  end

  assign VGA_HS = (x<96)?0:1 ;
  assign VGA_VS = (y<2)?0:1 ;
  assign ativo = ((x>96) && (y>2))?1:0 ;
  assign VGA_R = (ativo)? input_red:0 ;
  assign VGA_G = (ativo)? input_green:0 ;
  assign VGA_B   = (ativo)? input_blue:0 ;
  assign VGA_SYNC_N = 0 ;
  assign VGA_BLANK_N = 1 ;
  assign next_x = ((x > 143) && (x <= 783))? x - 143:0 ;
  assign next_y = ((y > 36) && (y < 515))? y - 36:0 ;

endmodule

module jogador1(
  input CLOCK_50,
  input VGA_CLK,
  input reset,
  input reiniciar,
  input [3:0] KEY,
  input [9:0] next_x,  // x-coordinate of NEXT pixel that will be drawn
  input [9:0] next_y,  // y-coordinate of NEXT pixel that will be drawn
  output reg [7:0] OUT_R,     // RED (to resistor DAC OUT connector)
  output reg [7:0] OUT_G,   // GREEN (to resistor DAC to OUT connector)
  output reg [7:0] OUT_B,   // BLUE (to resistor DAC to OUT connector)
  output  [9:0] scoreJ1,
  output  [9:0] scoreJ2,
  output [1:0] saida_jogador
  );

 /*
 KEY[3] -> anti-horario J1
 KEY[2] -> horario J1
 KEY[1] -> anti-horario J2
 KEY[0] -> horario J2
 */

  reg [1:0] matriz_jogo [0:59] [0:79] ;
  reg [3:0] estadoJ1;
  reg [3:0] estadoJ2;
  reg [2:0] estado_matriz;
  reg [6:0] contador_matriz_linha;
  reg [6:0] contador_matriz_coluna;
  parameter IDLE = 3'b000;  
  parameter AH_MOVE = 3'b011;
  parameter H_MOVE = 3'b100;
  parameter ESPERA = 3'b101;
  parameter COORD_INICIAL1_X = 216; 
  parameter COORD_INICIAL2_X = 416; 
  parameter COORD_INICIAL_Y = 240; 
  parameter COMPRIMENTO_JOGADOR = 8;
  parameter ALTURA_JOGADOR = 8;
  reg [1:0] sentidoJ1;
  reg [1:0] sentidoJ2; /* sentido = 0 -> direita 
                        sentido = 1 -> baixo
                        sentido = 2 -> esquerda
                        sentido = 3 -> cima  */
  reg [19:0] contador_clock;
  reg [9:0] coord_atual_x1;
  reg [9:0] coord_atual_y1;
  reg [9:0] coord_futura_x1;
  reg [9:0] coord_futura_y1;
  reg [9:0] coord_atual_x2;
  reg [9:0] coord_atual_y2;
  reg [9:0] coord_futura_x2;
  reg [9:0] coord_futura_y2;
  reg fim_de_jogo;
  reg [1:0] dado_matrizJ1;
  reg [1:0] dado_matrizJ2;
  reg [9:0] reg_scoreJ1;
  reg [9:0] reg_scoreJ2;

  always @ (posedge CLOCK_50) begin
    if (reset || reiniciar == 1) begin
      coord_atual_x1 = COORD_INICIAL1_X;
      coord_atual_y1 = COORD_INICIAL_Y;
      coord_futura_x1 = COORD_INICIAL1_X + 8;
      coord_futura_y1 = COORD_INICIAL_Y;
      coord_atual_x2 = COORD_INICIAL2_X;
      coord_atual_y2 = COORD_INICIAL_Y;
      coord_futura_x2 = COORD_INICIAL2_X - 8;
      coord_futura_y2 = COORD_INICIAL_Y;
      estado_matriz = 1;
      contador_matriz_coluna = 0;
      contador_matriz_linha = 0;
      fim_de_jogo = 0;
      if (reset) begin
        reg_scoreJ1 = 0;
        reg_scoreJ2 = 0;
      end
    end
    else if (estado_matriz == 0  ) begin
      
      //lê e gera o rgb
      if ((next_x > coord_atual_x1) && (next_x <= coord_atual_x1 + COMPRIMENTO_JOGADOR) && (next_y >= coord_atual_y1) && (next_y < coord_atual_y1 + ALTURA_JOGADOR)) begin
          OUT_R = 127;
          OUT_G = 127;
          OUT_B = 0;
      end
      else if ((next_x > coord_atual_x2) && (next_x <= coord_atual_x2 + COMPRIMENTO_JOGADOR) && (next_y >= coord_atual_y2) && (next_y < coord_atual_y2 + ALTURA_JOGADOR)) begin
          OUT_R = 0;
          OUT_G = 0;
          OUT_B = 127;
      end
      else begin
          OUT_R = 0;
          OUT_G = 0;
          OUT_B = 0;
      end

      if (contador_clock == 125000)
        begin
        // movendo jogador 1
          if(sentidoJ1 == 0) begin // deslocando para direita
            coord_futura_x1 = coord_atual_x1 + COMPRIMENTO_JOGADOR;
            coord_futura_y1 = coord_atual_y1;  
          end 
          else if (sentidoJ1 == 1) begin //deslocando para baixo
            coord_futura_y1 = coord_atual_y1 + ALTURA_JOGADOR; 
            coord_futura_x1 = coord_atual_x1;
          end
          else if (sentidoJ1 == 2) begin // deslocando para esquerda
            coord_futura_x1 = coord_atual_x1 - COMPRIMENTO_JOGADOR; 
            coord_futura_y1 = coord_atual_y1;  
          end 
          else if (sentidoJ1 == 3) begin //deslocando para cima
            coord_futura_y1 = coord_atual_y1 - ALTURA_JOGADOR;
            coord_futura_x1 = coord_atual_x1;
          end
          
          //movendo jogador 2
          if(sentidoJ2 == 0) begin // deslocando para direita
            coord_futura_x2 = coord_atual_x2 + COMPRIMENTO_JOGADOR;
            coord_futura_y2 = coord_atual_y2;  
          end 
          else if (sentidoJ2 == 1) begin //deslocando para baixo
            coord_futura_y2 = coord_atual_y2 + ALTURA_JOGADOR; 
            coord_futura_x2 = coord_atual_x2;
          end
          else if (sentidoJ2 == 2) begin // deslocando para esquerda
            coord_futura_x2 = coord_atual_x2 - COMPRIMENTO_JOGADOR; 
            coord_futura_y2 = coord_atual_y2;  
          end 
          else if (sentidoJ2 == 3) begin //deslocando para cima
            coord_futura_y2 = coord_atual_y2 - ALTURA_JOGADOR;
            coord_futura_x2 = coord_atual_x2;
          end
        end

      else if (contador_clock == 250000) 
        begin
          // guardando dados de onde os jogadores passaram
          matriz_jogo[coord_atual_y1 >> 3][coord_atual_x1 >> 3] = 1;
          matriz_jogo[coord_atual_y2 >> 3][coord_atual_x2 >> 3] = 2;

        
        end

      else if (contador_clock == 375000) begin
          dado_matrizJ1 = matriz_jogo[(coord_futura_y1) >> 3][(coord_futura_x1) >> 3];
          dado_matrizJ2 = matriz_jogo[(coord_futura_y2) >> 3][(coord_futura_x2) >> 3];

      end

      else if (contador_clock == 500000) 
        begin
          // verificando colisão
         if ((dado_matrizJ1 != 0 || dado_matrizJ2 != 0) && fim_de_jogo == 0) begin
          //  if (dado_matrizJ1 != 0 && dado_matrizJ2 != 0) begin
          //     scoreJ1 = scoreJ1 + 1;
          //     scoreJ2 = scoreJ2 + 1;
           //end
           if (dado_matrizJ1 != 0) begin
              reg_scoreJ2 = reg_scoreJ2 + 1;
           end
           if (dado_matrizJ2 != 0) begin
              reg_scoreJ1 = reg_scoreJ1 + 1;
          end
           fim_de_jogo = 1;
           estado_matriz = 0;
         end          
        end
      else if (contador_clock == 625000) begin
          coord_atual_x1 = coord_futura_x1;
          coord_atual_y1 = coord_futura_y1;
          coord_atual_x2 = coord_futura_x2;
          coord_atual_y2 = coord_futura_y2;
        end
        end
    

    case(estado_matriz)
        0: begin //estado de espera
            contador_matriz_coluna = 0;
            contador_matriz_linha = 0;
            if (reset || reiniciar == 1) begin
                estado_matriz = 1;
            end
        end
        1: begin //estado que zera a matriz
            if(contador_matriz_coluna > 79) begin
                contador_matriz_coluna = 0;
                contador_matriz_linha = contador_matriz_linha + 1;
                if (contador_matriz_linha > 59)
                estado_matriz = 0;
            end
            if ((contador_matriz_linha >= 2 && contador_matriz_linha <= 57) && (contador_matriz_coluna >= 2 && contador_matriz_coluna <= 77)) begin
                matriz_jogo[contador_matriz_linha][contador_matriz_coluna] = 0;
            end
            else begin
                matriz_jogo[contador_matriz_linha][contador_matriz_coluna] = 3;
            end
            contador_matriz_coluna = contador_matriz_coluna + 1;
        end
        default: begin
            estado_matriz = 0;
        end
    endcase
  end


  always @ (posedge VGA_CLK) begin
    if (reset) begin
      contador_clock = 0;
    end
    else begin
      if(fim_de_jogo == 0) begin
        if (contador_clock < 1000000) begin
          contador_clock = contador_clock + 1;
        end
        else begin
          contador_clock = 0;
        end
      end
    end
  end

  always@ (posedge VGA_CLK)begin
    if(reset || reiniciar == 1)begin
      estadoJ1 = IDLE;
      sentidoJ1 = 0;
    end
      
    case(estadoJ1)
      IDLE: begin
        if(KEY[3] == 0) begin
          estadoJ1 = AH_MOVE;
        end
        else if(KEY[2] == 0) begin
          estadoJ1 = H_MOVE;
        end
        else begin
            estadoJ1 = IDLE;
        end
      end
      AH_MOVE: begin
        sentidoJ1 = sentidoJ1 - 1;
        estadoJ1 = ESPERA; 
      end 
      H_MOVE: begin
        sentidoJ1 = sentidoJ1 + 1;
        estadoJ1 = ESPERA; 
      end   
      ESPERA: begin
        if(KEY[3] == 1 && KEY[2] == 1 && KEY[1] == 1 && KEY[0] == 1)begin
          estadoJ1 = IDLE;
        end
      end
      default: begin
        estadoJ1 = IDLE;
      end
    endcase
  end

always@ (posedge VGA_CLK)begin
    if(reset || reiniciar == 1)begin
      estadoJ2 = IDLE;
      sentidoJ2 = 2;
    end
      
    case(estadoJ2)
      IDLE: begin
        if(KEY[1] == 0) begin
          estadoJ2 = AH_MOVE;
        end
        else if(KEY[0] == 0) begin
          estadoJ2 = H_MOVE;
        end
        else begin
            estadoJ2 = IDLE;
        end
      end
      AH_MOVE: begin
        sentidoJ2 = sentidoJ2 - 1;
        estadoJ2 = ESPERA; 
      end 
      H_MOVE: begin
        sentidoJ2 = sentidoJ2 + 1;
        estadoJ2 = ESPERA; 
      end   
      ESPERA: begin
        if(KEY[3] == 1 && KEY[2] == 1 && KEY[1] == 1 && KEY[0] == 1)begin
          estadoJ2 = IDLE;
        end
      end
      default: begin
        estadoJ2 = IDLE;
      end
    endcase
  end

  assign saida_jogador = matriz_jogo[next_y >> 3][next_x >> 3];
  assign scoreJ1 = reg_scoreJ1;
  assign scoreJ2 = reg_scoreJ2;

endmodule	

module top1(
  input CLOCK_50,
  input [3:0] SW,
  input [3:0] KEY,
  output VGA_CLK,
  output VGA_SYNC_N,
  output VGA_BLANK_N,
  output VGA_HS,
  output VGA_VS,
  output [7:0] VGA_R,     // RED (to resistor DAC VGA connector)
  output [7:0] VGA_G,   // GREEN (to resistor DAC to VGA connector)
  output [7:0] VGA_B,    // BLUE (to resistor DAC to VGA connector)
  output [6:0] HEX0,
  output [6:0] HEX1,
  output [6:0] HEX2,
  output [6:0] HEX3,
  output [6:0] HEX4,
  output [6:0] HEX5
);

  wire [9:0] next_x;
  wire [9:0] next_y;
  wire [7:0] jogador_red;
  wire [7:0] jogador_green;
  wire [7:0] jogador_blue;
  reg [7:0] jogador_traco_red;
  reg [7:0] jogador_traco_green;
  reg [7:0] jogador_traco_blue;
  reg [7:0] borda_red;
  reg [7:0] borda_green;
  reg [7:0] borda_blue;
  wire [7:0] input_red;
  wire [7:0] input_green;
  wire [7:0] input_blue;
  wire [1:0] saida_jogador;
  wire [9:0] scoreJ1, scoreJ2;
  wire [3:0] dig0_dec, dig1_dec, dig2_dec, dig3_dec, dig4_dec, dig5_dec;


  jogador1 jogador1(
    .CLOCK_50(CLOCK_50),
    .VGA_CLK(VGA_CLK),
    .reset(SW[0]),
    .reiniciar(SW[1]),
    .KEY(KEY),
    .next_x(next_x),
    .next_y(next_y),
    .OUT_R(jogador_red),
    .OUT_G(jogador_green),
    .OUT_B(jogador_blue),
    .scoreJ1(scoreJ1),
    .scoreJ2(scoreJ2),
    .saida_jogador(saida_jogador)
  );
  
  display display (
    .entrada_score1(scoreJ1),
    .entrada_score2(scoreJ2),
    .reset(SW[0]),
    .dig0(dig0_dec),
    .dig1(dig1_dec),
    .dig2(dig2_dec),
    .dig3(dig3_dec),
    .dig4(dig4_dec),
    .dig5(dig5_dec)
  );

  conversao conversao (
    .reset(SW[0]),
    .score1(scoreJ1),
    .score2(scoreJ2),
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

  vga vga(
   .CLOCK_50(CLOCK_50),
   .SW(SW),
   .input_red(input_red),
   .input_green(input_green),
   .input_blue(input_blue),
   .VGA_CLK(VGA_CLK),
   .VGA_SYNC_N(VGA_SYNC_N),
   .VGA_BLANK_N(VGA_BLANK_N),
   .VGA_HS(VGA_HS),
   .VGA_VS(VGA_VS),
   .VGA_R(VGA_R),     // RED (to resistor DAC VGA connector),
   .VGA_G(VGA_G),   // GREEN (to resistor DAC to VGA connector),
   .VGA_B(VGA_B),    // BLUE (to resistor DAC to VGA connector)
   .next_x(next_x),  // x-coordinate of NEXT pixel that will be drawn
   .next_y(next_y)
  );
  
   always@ (posedge VGA_CLK) begin

      if (saida_jogador == 1)begin
        jogador_traco_red = 255;
        jogador_traco_green = 255;
        jogador_traco_blue = 0;
      end
      else if (saida_jogador == 2) begin
        jogador_traco_red = 0;
        jogador_traco_green = 0;
        jogador_traco_blue = 255;
      end
      else begin
        jogador_traco_red = 0;
        jogador_traco_green = 0;
        jogador_traco_blue = 0;        
      end

      if((next_x >= 16 && next_x <= 622) && (next_y >= 16 && next_y <= 462))begin
        borda_red = 0;  
        borda_green = 0;  
        borda_blue = 0; 
      end
      else begin
        borda_red = 255;  
        borda_green = 0;  
        borda_blue = 0;
        end

    end
  
  assign input_red = jogador_red ^ borda_red ^ jogador_traco_red;
  assign input_green = jogador_green ^ borda_green ^ jogador_traco_green;
  assign input_blue = jogador_blue ^ borda_blue ^ jogador_traco_blue;

endmodule