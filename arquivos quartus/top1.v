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
  output [1:0] saida_jogador1
  );

 /*
 KEY[3] -> anti-horario
 KEY[2] -> horario
 */

  //estados        coord_passada_y = coord_atual_y;
  reg [1:0] matriz_jogo [0:59] [0:79] ;
  reg [3:0] estado;
  reg [2:0] estado_matriz;
  reg [6:0] contador_matriz_linha;
  reg [6:0] contador_matriz_coluna;
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

  reg [2:0] contador_jogador1;
  // reg leitura_realizada;
  integer i;
  integer j;


  

  always @ (posedge CLOCK_50) begin
    if (reset || reiniciar == 1) begin
      coord_atual_x = COORD_INICIAL_X;
      coord_atual_y = COORD_INICIAL_Y;
      coord_futura_x = 0;
      coord_futura_y = 0;
      contador_jogador1 = 0;
      estado_matriz = 1;
      contador_matriz_coluna = 0;
      contador_matriz_linha = 0;
      fim_de_jogo = 0;

    end
    else if (estado_matriz == 0) begin
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

      
      else if (contador_clock == 0)
      begin
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
        // else begin
        //   contador_clock = contador_clock + 1;
        // end
        
        matriz_jogo[coord_atual_y >> 3][coord_atual_x >> 3] = 1;
        //guarda coord atual

        coord_atual_x = coord_futura_x;
        coord_atual_y = coord_futura_y;
      end


      else if (contador_jogador1 == 2) 
      begin
        //detecta colisao e encerra jogo
        dado_matriz = matriz_jogo[(coord_futura_y) >> 3][(coord_futura_x) >> 3];
        if (dado_matriz != 0) begin
            fim_de_jogo = 1;
          end
      end
      contador_jogador1 = contador_jogador1 + 1;
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
        matriz_jogo[contador_matriz_linha][contador_matriz_coluna] = 2;
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
        if (contador_clock < 800000) begin
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
      estado = IDLE;
      sentido = 0;
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
  assign saida_jogador1 = matriz_jogo[next_y >> 3][next_x >> 3];

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
  output [7:0] VGA_B    // BLUE (to resistor DAC to VGA connector)
);

  wire [9:0] next_x;
  wire [9:0] next_y;
  wire [7:0] jogador1_red;
  wire [7:0] jogador1_green;
  wire [7:0] jogador1_blue;
  reg [7:0] jogador1_traco_red;
  reg [7:0] jogador1_traco_green;
  reg [7:0] jogador1_traco_blue;
  reg [7:0] borda_red;
  reg [7:0] borda_green;
  reg [7:0] borda_blue;
  wire [7:0] input_red;
  wire [7:0] input_green;
  wire [7:0] input_blue;
  reg [1:0] matriz_jogo [0:59] [0:79];

  wire [1:0] saida_jogador1;
  wire [1:0] saida_jogador2;
  



  jogador1 jogador1(
    .CLOCK_50(CLOCK_50),
    .VGA_CLK(VGA_CLK),
    .reset(SW[0]),
    .reiniciar(SW[1]),
    .KEY(KEY),
    .next_x(next_x),
    .next_y(next_y),
    .OUT_R(jogador1_red),
    .OUT_G(jogador1_green),
    .OUT_B(jogador1_blue),
    .saida_jogador1(saida_jogador1)
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
  
   always@ (posedge VGA_CLK)begin
      if (saida_jogador1 == 1)begin

        jogador1_traco_red = 255;
        jogador1_traco_green = 255;
        jogador1_traco_blue = 0;
      end
      else begin
        jogador1_traco_red = 0;
        jogador1_traco_green = 0;
        jogador1_traco_blue = 0;
      end

      if((next_x >= 16 && next_x <= 623) && (next_y >= 16 && next_y <= 463))begin
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
  

  assign input_red = jogador1_red ^ borda_red ^ jogador1_traco_red;
  assign input_green = jogador1_green ^ borda_green ^ jogador1_traco_green;
  assign input_blue = jogador1_blue ^ borda_blue ^ jogador1_traco_blue;

 

endmodule