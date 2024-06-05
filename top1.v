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
  reg [1:0] matriz_jogo [0:79] [0:59];

  wire [7:0] saida_jogador1;
  wire [7:0] saida_jogador2;
  



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