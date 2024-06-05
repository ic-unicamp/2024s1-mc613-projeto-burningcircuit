module jogador1(
  input CLOCK_50,
  input VGA_CLK,
  input reset,
  input reiniciar,
  input [1:0] matriz_jogo [0:79] [0:59],
  input [3:0] KEY,
  input [9:0] next_x,  // x-coordinate of NEXT pixel that will be drawn
  input [9:0] next_y,  // y-coordinate of NEXT pixel that will be drawn
  output reg [7:0] OUT_R,     // RED (to resistor DAC OUT connector)
  output reg [7:0] OUT_G,   // GREEN (to resistor DAC to OUT connector)
  output reg [7:0] OUT_B,   // BLUE (to resistor DAC to OUT connector)
  output [1:0] saida_jogador1
  );

 /*
 KEY[3] -> anti-horario
 KEY[2] -> horario
 */

  //estados        coord_passada_y = coord_atual_y;
  reg [3:0] estado;
  parameter IDLE = 3'b000;  
  parameter AH_MOVE = 3'b011;
  parameter H_MOVE = 3'b100;
  parameter ESPERA = 3'b101;
  parameter COORD_INICIAL_X = 216; 
  parameter COORD_INICIAL_Y = 240; 
  reg [9:0] coord_atual_x;
  reg [9:0] coord_atual_y;
  parameter COMPRIMENTO_JOGADOR1 = 8;
  parameter ALTURA_JOGADOR1 = 8;
  reg [1:0] sentido; /* sentido = 0 -> direita 
                        sentido = 1 -> baixo
                        sentido = 2 -> esquerda
                        sentido = 3 -> cima  */
  reg [19:0] contador_clock;
  reg [9:0] coord_futura_x;
  reg [9:0] coord_futura_y;
  reg fim_de_jogo;

  reg [1:0] dado_matriz;

  reg [3:0] contador_jogador1;
  // reg leitura_realizada;
  integer i;
  integer j;

  always @ (posedge CLOCK_50) begin
    if (reset) begin
      contador_jogador1 = 0;
      for (i=0;i<80;i=i+1) begin
        for (j=0;j<60;j=j+1) begin
          if ((i >=2 && i <= 77) && (j >= 2 && j <= 57) )begin
            matriz_jogo[i][j] = 0;
          end
          else begin
            matriz_jogo[i][j] = 2;
          end
        end
      end

      fim_de_jogo = 0;

    end
    else begin
      if (contador_jogador1 == 0) begin
        //ler e gera o rgb
        if( (next_x >= coord_atual_x) && (next_x < coord_atual_x + COMPRIMENTO_JOGADOR1) )begin
          if ( (next_y >= coord_atual_y) && (next_y < coord_atual_y + ALTURA_JOGADOR1) )begin
            OUT_R = 127;
            OUT_G = 127;
            OUT_B = 0;
          end
          else begin
            OUT_R = 0;
            OUT_G = 0;
            OUT_B = 0;
          end
      end
      else begin
          OUT_R = 0;
          OUT_G = 0;
          OUT_B = 0;
      end
      end

      
      else if (contador_jogador1 == 1)
      begin
        if (contador_clock == 0) begin
          /// move boneco
          //escreve na memoria
          if(sentido == 0) begin // deslocando para direita
            coord_futura_x = coord_atual_x + COMPRIMENTO_JOGADOR1;
            coord_futura_y = coord_atual_y;  
          end 
          else if (sentido == 1) begin //deslocando para baixo
            coord_futura_y = coord_atual_y + ALTURA_JOGADOR1; 
            coord_futura_x = coord_atual_x;
          end
          else if (sentido == 2) begin // deslocando para esquerda
            coord_futura_x = coord_atual_x - COMPRIMENTO_JOGADOR1; 
            coord_futura_y = coord_atual_y;  
    
          end 
          else if (sentido == 3) begin //deslocando para cima
            coord_futura_y = coord_atual_y - ALTURA_JOGADOR1;
            coord_futura_x = coord_atual_x;

          end
        end
        matriz_jogo[coord_atual_x][coord_atual_y] = 1;
        //guarda coord atual
        coord_atual_x = coord_futura_x;
        coord_atual_y = coord_futura_y;
      end


      else if (contador_jogador1 == 2) 
      begin
        //detecta colisao e encerra jogo
        dado_matriz = matriz_jogo[coord_futura_x][coord_futura_y];
        if (dado_matriz != 0) begin
          fim_de_jogo = 1;
        end

         if( !((coord_atual_x >= 16 && coord_atual_x <= 623) && (coord_atual_y >= 16 && coord_atual_y <= 463)) ) begin
        fim_de_jogo = 1;
      end
      end
      contador_jogador1 = contador_jogador1 + 1;
    end
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
    if(reset)begin
      estado = IDLE;
      coord_atual_x = COORD_INICIAL_X;
      coord_atual_y = COORD_INICIAL_Y;
      sentido = 0;
      fim_de_jogo = 0;
      coord_futura_x = 0;
      coord_futura_y = 0;
      // leitura_realizada = 0;

    end
      
    else if (contador_clock == 0) begin
      
      end
      if(reiniciar == 1) begin
        coord_atual_x = COORD_INICIAL_X;
        coord_atual_y = COORD_INICIAL_Y;
        fim_de_jogo = 0;
        sentido = 0;
        coord_futura_x = COORD_INICIAL_X ;
        coord_futura_y = COORD_INICIAL_Y;
        // leitura_realizada = 0;
      end
      else begin
        coord_atual_x = coord_futura_x;
        coord_atual_y = coord_futura_y;
      end
      
      case(estado)
        IDLE: begin
          if(KEY[3] == 0) begin
            estado = AH_MOVE;
          end
          else if(KEY[2] == 0) begin
            estado = H_MOVE;
          end
          else begin
              estado = IDLE;
          end
        end
        AH_MOVE: begin
          sentido = sentido - 1;
          estado = ESPERA; 
        end 
        H_MOVE: begin
          sentido = sentido + 1;
          estado = ESPERA; 
        end   
        ESPERA: begin
          if(KEY[3] == 1 && KEY[2] == 1 && KEY[1] == 1 && KEY[0] == 1)begin
            estado = IDLE;
          end
        end
        default: begin
          estado = IDLE;
        end
      endcase
     
  end
  assign saida_jogador1 = matriz_jogo[next_x / 8][next_y / 8];

endmodule	