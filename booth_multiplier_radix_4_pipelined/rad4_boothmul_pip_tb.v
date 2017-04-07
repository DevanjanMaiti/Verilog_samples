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


module rad4_boothmul_pip_tb(

    );

reg         clk;
reg         rst_n;
reg  [ 7:0] multiplier;
reg  [ 7:0] multiplicand;
wire [15:0] product;

// DUT Instance
rad4_boothmul_pip_top rad4_boothmul_pip_top_dut(
  .clk(clk),
  .rst_n(rst_n),
  .mltplr_i(multiplier),
  .mltplcnd_i(multiplicand),
  .prdct_o(product)
);

initial begin
clk = 1'b0;
rst_n = 1'b0;
#50

repeat(4) #20 clk = ~clk;
rst_n = 1'b1;

forever #20 clk = ~clk;
end

initial begin
multiplier   = 8'd0;
multiplicand = 8'd0;

@(posedge rst_n);
multiplier   = -8'd128;
multiplicand = 8'd127;
repeat(100) @(posedge clk);
$finish;
end

endmodule
