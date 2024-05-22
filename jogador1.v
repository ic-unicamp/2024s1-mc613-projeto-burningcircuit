module jogador1(
  input VGA_CLK,
  input reset,
  input reiniciar,
  input [3:0] KEY,
  input [9:0] next_x,  // x-coordinate of NEXT pixel that will be drawn
  input [9:0] next_y,  // y-coordinate of NEXT pixel that will be drawn
  output reg [7:0] OUT_R,     // RED (to resistor DAC OUT connector)
  output reg [7:0] OUT_G,   // GREEN (to resistor DAC to OUT connector)
  output reg [7:0] OUT_B    // BLUE (to resistor DAC to OUT connector)
);

 /*
 KEY[3] -> anti-horario
 KEY[2] -> horario
 */

  //estados
  reg [3:0] estado;
  parameter IDLE = 3'b000;  
  parameter AH_MOVE = 3'b011;
  parameter H_MOVE = 3'b100;
  parameter ESPERA = 3'b101;

  parameter COORD_INICIAL_X = 219; 
  parameter COORD_INICIAL_Y = 239; 
  reg [9:0] coord_atual_x;
  reg [9:0] coord_atual_y;

  parameter COMPRIMENTO_JOGADOR1 = 8;
  parameter ALTURA_JOGADOR1 = 8;
  reg [1:0] sentido; /* sentido = 0 -> direita 
                        sentido = 1 -> baixo
                        sentido = 2 -> esquerda
                        sentido = 3 -> cima  */
  reg [19:0] contador_clock;
  reg [9:0] posicao_futura_x;
  reg [9:0] posicao_futura_y;


  always @ (posedge VGA_CLK) begin
    if (reset) begin
      contador_clock = 0;
    end
    else begin
      if (contador_clock < 1000000) begin
        contador_clock = contador_clock + 1;
      end
      else begin
        contador_clock = 0;
      end
    end
  end

  always@ (posedge VGA_CLK)begin
    if(reset || (reiniciar == 0))begin
      estado = IDLE;
      coord_atual_x = COORD_INICIAL_X;
      coord_atual_y = COORD_INICIAL_Y;
    end
    else if (contador_clock == 0) begin
      coord_atual_x = posicao_futura_x;
      coord_atual_y = posicao_futura_y;
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

      if(sentido == 0) begin // deslocando para direita
        posicao_futura_x = coord_atual_x + COMPRIMENTO_JOGADOR1;  
      end 
      else if (sentido == 1) begin //deslocando para baixo
        posicao_futura_y = coord_atual_y + ALTURA_JOGADOR1;  
      end
      else if (sentido == 2) begin // deslocando para esquerda
        posicao_futura_x = coord_atual_x - COMPRIMENTO_JOGADOR1;  
      end 
      else if (sentido == 3) begin //deslocando para cima
        posicao_futura_y = coord_atual_y - ALTURA_JOGADOR1;  
      end
    end
  end

//desenha JOGADOR11
  always @(*) begin
    if(reset)begin
    OUT_R = 0;
    OUT_G = 0;
    OUT_B = 0;

    end
    else begin
      if( (next_x >= coord_atual_x) && (next_x < coord_atual_x + COMPRIMENTO_JOGADOR1) )begin
        if ( (next_y >= coord_atual_y) && (next_y < coord_atual_y + ALTURA_JOGADOR1) )begin
          OUT_R = 255;
          OUT_G = 255;
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
  end

endmodule	