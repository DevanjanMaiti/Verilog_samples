`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.03.2017 16:16:43
// Design Name: 
// Module Name: priority_encoder_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: The output is '00' when none of the inputs are selected
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module priority_encoder_top(

input  wire [2:0] data_in_i,
output wire [1:0] data_out_o
 
    );
    
assign data_out_o = {(~data_in_i[2] & data_in_i[1]) | data_in_i[2], (data_in_i[0] & (~data_in_i[1]) & (~data_in_i[2])) | data_in_i[2]};
    
endmodule
