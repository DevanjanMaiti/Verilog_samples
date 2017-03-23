`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.03.2017 16:44:29
// Design Name: 
// Module Name: priority_encoder_tb
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


module priority_encoder_tb(

    );
    
reg  [2:0] input_data;
wire [1:0] output_data;
integer count = 0;   

// DUT Instance
priority_encoder_top priority_encoder_top_dut(
  .data_in_i(input_data),
  .data_out_o(output_data)
); 

initial begin
#50
for (count = 0; count < 8; count=count+1) begin
   input_data = count;
   #20;
end
end
 
endmodule
