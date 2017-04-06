`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.03.2017 19:50:13
// Design Name: 
// Module Name: rad4_booth_mul_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module rad4_booth_mul_tb(

    );

reg  [ 7:0] multiplier;
reg  [ 7:0] multiplicand;
wire [15:0] product;

// DUT Instance
rad4_booth_mul_top rad4_booth_mul_top_dut(
  .mltplr_i(multiplier),
  .mltplcnd_i(multiplicand),
  .prdct_o(product)
);

initial begin
#50
multiplier   = -8'd5;
multiplicand = 8'd8;
end

endmodule
