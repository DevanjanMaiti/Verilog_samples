`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.11.2016 11:20:27
// Design Name: 
// Module Name: divider_tb
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


module divider_tb();

reg  clk, rst_n;

reg  start;
 
//----------------------------------------
//       DIVIDER_TOP INSTANCE
//----------------------------------------
divider_top divider_top_inst (
  .clk         (clk),
  .rst_n       (rst_n), 
  .start_i     (start), 
  .divisor_i   (7'd5)
);

initial begin
    clk = 1'b0;
    rst_n = 1'b0;
    start = 1'b0;
    repeat(4) #10 clk = ~clk;
    rst_n = 1'b1;
    repeat(4) #10 clk = ~clk;
    start = 1'b1;
    repeat(2) #10 clk = ~clk;
    start = 1'b0;
    forever #10 clk = ~clk; // generate a clock
end
 
endmodule
