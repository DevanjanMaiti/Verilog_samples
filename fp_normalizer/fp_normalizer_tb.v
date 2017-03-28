`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.03.2017 18:40:57
// Design Name: 
// Module Name: fp_normalizer_tb
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


module fp_normalizer_tb(

    );

reg  clk;
reg  rst_n;
reg  [15:0] denorm_data_input;
wire [15:0] norm_data_output;
wire [ 3:0] leading_bit_pos;

    
// DUT Instance
fp_normalizer_top fp_normalizer_top_inst(
  .clk(clk),
  .rst_n(rst_n),
  .denorm_data_i(denorm_data_input),
  .norm_data_o(norm_data_output),
  .leading_bit_o(leading_bit_pos)
);

initial begin
clk = 1'b0;
rst_n = 1'b0;
#50

repeat(4) #50 clk = ~clk;
rst_n = 1'b1;

forever #50 clk = ~clk;
end

initial begin
denorm_data_input = 16'b0;
@(posedge rst_n);
denorm_data_input = 16'b0110_0000_0000_0011;
repeat(100) @(posedge clk);
$finish;    
end

endmodule
