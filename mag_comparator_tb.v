`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.03.2017 14:48:15
// Design Name: 
// Module Name: mag_comparator_tb
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


module mag_comparator_tb(

    );

reg  [3:0] test_data;
wire greater;
wire equal;
wire lesser;

integer count;

// DUT Instance
mag_comparator_top mag_comparator_top_dut (
  .in1_i(test_data[1:0]),
  .in2_i(test_data[3:2]),
  .greater_o(greater),
  .equal_o(equal),
  .lesser_o(lesser)
);

initial begin
#50
  for(count = 0; count < 16; count = count+1) begin
    test_data = count;     
    #20;
  end
end

endmodule
