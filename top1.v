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

/*
 falta implementar:
    1.colocar a escrita no FB para ser feita em função da coord_passada de x e y
    2.e a leitura do FB para ser feita em função da coord_atual de x e y
*/


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
  input [7:0] dado_mem_atual,
  output reg [7:0] OUT_R,     // RED (to resistor DAC OUT connector)
  output reg [7:0] OUT_G,   // GREEN (to resistor DAC to OUT connector)
  output reg [7:0] OUT_B,    // BLUE (to resistor DAC to OUT connector)
  output [18:0] endereco_ram,
  output [7:0] sinalRGB,

  // output [9:0] out_coord_passada_x_j1,
  // output [9:0] out_coord_passadaj1,
  output reg wren
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

  parameter COORD_INICIAL_X = 216; 
  parameter COORD_INICIAL_Y = 240; 
  reg [9:0] coord_passada_x;
  reg [9:0] coord_passada_y;

  parameter COMPRIMENTO_JOGADOR1 = 8;
  parameter ALTURA_JOGADOR1 = 8;
  reg [1:0] sentido; /* sentido = 0 -> direita 
                        sentido = 1 -> baixo
                        sentido = 2 -> esquerda
                        sentido = 3 -> cima  */
  reg [19:0] contador_clock;
  reg [9:0] coord_futura_x;
  reg [9:0] coord_futura_y;

  reg [9:0] coord_atual_x;
  reg [9:0] coord_atual_y;

  reg fim_de_jogo;

  parameter COORD_INICIAL_mem = COORD_INICIAL_X + (COORD_INICIAL_Y * 640);

  reg jogo_iniciado;

  wire [7:0] primeiro_movimento;

  assign primeiro_movimento = (next_x == COORD_INICIAL_X + COMPRIMENTO_JOGADOR1 && next_y == COORD_INICIAL_Y) ? dado_mem_atual : 0 ; 

  // reg leitura_realizada;

// contador de frame
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

// always posiçoes
always @(posedge VGA_CLK)begin
   if(reset)begin
    coord_passada_x = 0;
    coord_passada_y = 0;
    coord_atual_x = COORD_INICIAL_X;
    coord_atual_y = COORD_INICIAL_Y;
    coord_futura_x = COORD_INICIAL_X;
    coord_futura_y = COORD_INICIAL_Y;
   end

   else if (contador_clock == 0) begin
    coord_passada_x = coord_atual_x;
    coord_passada_y = coord_atual_y;
    if(sentido == 0) begin // deslocando para direita
      coord_futura_x = coord_atual_x + COMPRIMENTO_JOGADOR1;  
    end 
    else if (sentido == 1) begin //deslocando para baixo
      coord_futura_y = coord_atual_y + ALTURA_JOGADOR1; 
    end
    else if (sentido == 2) begin // deslocando para esquerda
      coord_futura_x = coord_atual_x - COMPRIMENTO_JOGADOR1;  
    end 
    else if (sentido == 3) begin //deslocando para cima
      coord_futura_y = coord_atual_y - ALTURA_JOGADOR1;
    end
  end

    if(reiniciar == 1) begin
      coord_passada_x = 0;
      coord_passada_y = 0;
      coord_futura_x = COORD_INICIAL_X;
      coord_futura_y = COORD_INICIAL_Y;
      coord_atual_x = COORD_INICIAL_X ;
      coord_atual_y = COORD_INICIAL_Y;
      // leitura_realizada = 0;
    end
    else begin
      coord_atual_x = coord_futura_x;
      coord_atual_y = coord_futura_y;
    end
  
end

// always movimento/botoes
  always@ (posedge VGA_CLK)begin
    if(reset)begin
      estado = IDLE;
      sentido = 0;
    end
      // end_mem = coord_futura_x + (coord_futura_y * 640);
      
    if(reiniciar == 1) begin
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

// always colisao
always @( posedge VGA_CLK)begin
  if (reset || reiniciar == 1 )begin
    fim_de_jogo = 0;
  end
  else begin
    if( next_x == coord_atual_x && next_y == coord_atual_y ) begin
      if( (coord_atual_x == COORD_INICIAL_X) && (coord_atual_y == COORD_INICIAL_Y) && ( primeiro_movimento != 0) ) begin
        fim_de_jogo = 1;
      end
      else if(dado_mem_atual != 0 ) begin
        fim_de_jogo = 1;
      end
    end

    if( !((coord_passada_x >= 16 && coord_passada_x <= 623) && (coord_passada_y >= 16 && coord_passada_y <= 463)) ) begin
      fim_de_jogo = 1;
    end
  end

end



//desenha JOGADOR11

  reg [18:0] end_jog1;
  reg [18:0] contador_ram;
  reg [7:0] sinalRGB_jog1;
  integer i;

// always de deletar valores do framebuffer
  always @(posedge CLOCK_50) begin
    if(reset || reiniciar == 1)begin
      OUT_R = 0;
      OUT_G = 0;
      OUT_B = 0;
      wren = 1;
      sinalRGB_jog1 = 8'b00000000;
      // if( (( contador_ram >= COORD_INICIAL_mem) && ( contador_ram < COORD_INICIAL_mem + 8)) ||
      //     (( contador_ram >= COORD_INICIAL_mem+640) && ( contador_ram < COORD_INICIAL_mem + 640 + 8)) ||
      //     (( contador_ram >= COORD_INICIAL_mem+640*2) && ( contador_ram < COORD_INICIAL_mem + 640*2 + 8)) ||
      //     (( contador_ram >= COORD_INICIAL_mem+640*3) && ( contador_ram < COORD_INICIAL_mem + 640*3 + 8)) ||
      //     (( contador_ram >= COORD_INICIAL_mem+640*4) && ( contador_ram < COORD_INICIAL_mem + 640*4 + 8)) ||
      //     (( contador_ram >= COORD_INICIAL_mem+640*5) && ( contador_ram < COORD_INICIAL_mem + 640*5 + 8)) ||
      //     (( contador_ram >= COORD_INICIAL_mem+640*6) && ( contador_ram < COORD_INICIAL_mem + 640*6 + 8)) ||
      //     (( contador_ram >= COORD_INICIAL_mem+640*7) && ( contador_ram < COORD_INICIAL_mem + 640*7 + 8))) begin
      //       sinalRGB_jog1 = 8'b00000001;
      //   end
      end_jog1 = contador_ram;
      // for(i = 0; i <= 307200; i = i+1 ) begin
      //   end_jog1 = i;
      // end
      contador_ram = contador_ram + 1; 
      // contador_ram = contador_ram % 307200;


    end
    else begin
      // if (reiniciar == 1) begin
      //   OUT_R = 0;
      //   OUT_G = 0;
      //   OUT_B = 0;
      //   wren = 1;
      //   sinalRGB_jog1 = 8'b00000000;
      //   if((contador_ram >= (COORD_INICIAL_X + (COORD_INICIAL_Y * 640))  && contador_ram < (COORD_INICIAL_X + 8 + (COORD_INICIAL_Y * 640))) && (contador_ram >= (COORD_INICIAL_X + (COORD_INICIAL_Y * 640)) && contador_ram < (COORD_INICIAL_X + ((COORD_INICIAL_Y+8) * 640))) )begin
      //     sinalRGB_jog1 = 8'b00000001;
      //   end

      //   end_jog1 = contador_ram;
      //   // for(i = 0; i <= 307200; i = i+1 ) begin
      //   //   end_jog1 = i;
      //   // end
      //   contador_ram = contador_ram + 1; 
      // end
      contador_ram = 0;
      if( (next_x >= coord_passada_x) && (next_x < coord_passada_x + COMPRIMENTO_JOGADOR1) )begin
        if ( (next_y >= coord_passada_y) && (next_y < coord_passada_y + ALTURA_JOGADOR1) )begin
          OUT_R = 127;
          OUT_G = 127;
          OUT_B = 0;
          end_jog1 = next_x + (next_y * 640);
          wren = 1;
          sinalRGB_jog1 =  8'b00000001;
        end
        else begin
          OUT_R = 0;
          OUT_G = 0;
          OUT_B = 0;
          end_jog1 = 0;
          sinalRGB_jog1 = 8'b00000000;
          wren = 0;
        end
      end
      else begin
        OUT_R = 0;
        OUT_G = 0;
        OUT_B = 0;
        end_jog1 = 0;
        sinalRGB_jog1 = 8'b00000000;
        wren = 0;
      end
    end
  end

  
  
  // assign out_coord_passada_x_j1 = coord_passada_x;
  // assign out_coord_passadaj1 = coord_passada_y;
  // assign endereco_ram = coord_passada_x + (coord_passada_y * 640);
  // assign endereco_ram = (  ( ( (next_x >= coord_passada_x) && (next_x < coord_passada_x + 8) ) && ( (next_y >= coord_passada_y) && (next_y < coord_passada_y + 8)  )  ) ) ?  next_x + (next_y * 640) : 0;
  // assign endereco_ram = (  ( ( (next_x >= coord_passada_x) && (next_x < coord_passada_x + 8) ) && ( (next_y >= coord_passada_y) && (next_y < coord_passada_y + 8)  )  ) ) ?  next_x + (next_y * 640) : 0;
  // assign endereco_ram = (leitura_realizada == 1) ? end_jog1 : 0;
  assign endereco_ram = end_jog1 ;
  assign sinalRGB = sinalRGB_jog1;


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
  wire [18:0] endereco_ram_jogador1;
  wire [18:0] endereco_escrita_jogador1;
  wire [18:0] endereco_leitura_jogador1;
  wire wren_jogador1;
  wire [7:0] sinalRGB_jogador1;
  wire [7:0] sinalRGB_jogador2;
  wire [7:0] saida_jogador1;
  wire [7:0] saida_jogador2;

  // wire [9:0] coord_passada_x_j1;
  // wire [9:0] coord_passadaj1;


  // assign sinalRGB_jogador1 =  ( ( (next_x >= coord_passada_x_j1) && (next_x < coord_passada_x_j1 + 8) ) && ( (next_y >= coord_passadaj1) && (next_y < coord_passadaj1 + 8)  )  ) ? 8'b00000001: 8'b00000000 ;
  // assign sinalRGB_jogador1 = 8'b00000001;
  // assign sinalRGB_jogador2 = 8'b10000000;
  assign endereco_leitura_jogador1 = next_x + (next_y * 640);

  // assign endereco_escrita_jogador1 = 320 + (240 * 640);
  //assign endereco_ram_jogador1 = (wren_jogador1 == 1)? endereco_escrita_jogador1: endereco_leitura_jogador1;

  ram ram (
  .data(sinalRGB_jogador1), // endereço de escrita jogador 1
	.rdaddress(endereco_leitura_jogador1),
	.rdclock(VGA_CLK),
	.wraddress(endereco_escrita_jogador1),
	.wrclock(CLOCK_50),
	.wren(wren_jogador1),
	.q(saida_jogador1)
  );

  


  jogador1 jogador1(
    .CLOCK_50(CLOCK_50),
    .VGA_CLK(VGA_CLK),
    .reset(SW[0]),
    .reiniciar(SW[1]),
    .KEY(KEY),
    .next_x(next_x),
    .next_y(next_y),
    .dado_mem_atual(saida_jogador1),
    .OUT_R(jogador1_red),
    .OUT_G(jogador1_green),
    .OUT_B(jogador1_blue),
    .endereco_ram(endereco_escrita_jogador1),
    .sinalRGB(sinalRGB_jogador1),
    // .out_coord_passada_x_j1(coord_passada_x_j1),
    // .out_coord_passadaj1(coord_passadaj1)
    .wren(wren_jogador1)
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

      if (saida_jogador1 == 8'b00000001)begin

        jogador1_traco_red = 255;
        jogador1_traco_green = 255;
        jogador1_traco_blue = 0;
      end
      else begin
        jogador1_traco_red = 0;
        jogador1_traco_green = 0;
        jogador1_traco_blue = 0;
      end
      // else begin
      //   jogador1_traco_blue = 0;
      //   jogador1_traco_green = 0;
      //   jogador1_traco_red = 0;
      // end

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
  
  // assign input_red = borda_red ^ jogador1_traco_red;
  // assign input_green = borda_green ^ jogador1_traco_green;
  // assign input_blue = borda_blue ^ jogador1_traco_blue;


  assign input_red = jogador1_red ^ borda_red ^ jogador1_traco_red;
  assign input_green = jogador1_green ^ borda_green ^ jogador1_traco_green;
  assign input_blue = jogador1_blue ^ borda_blue ^ jogador1_traco_blue;

  // assign input_red = (next_x == 320 && next_y == 240) ?  jogador1_traco_red: jogador1_red ^ borda_red;
  // assign input_green = (next_x == 320 && next_y == 240) ? jogador1_traco_green : jogador1_green ^ borda_green;
  // assign input_blue = (next_x == 320 && next_y == 240) ?  jogador1_traco_blue : jogador1_blue ^ borda_blue;

  // assign input_red =  jogador1_traco_red;
  // assign input_green =  jogador1_traco_green;
  // assign input_blue =  jogador1_traco_blue;

endmodule