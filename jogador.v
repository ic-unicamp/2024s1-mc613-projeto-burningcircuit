module jogador(
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
    if (reset || reiniciar) begin
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