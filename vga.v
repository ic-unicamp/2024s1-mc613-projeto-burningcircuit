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