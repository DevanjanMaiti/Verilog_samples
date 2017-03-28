`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.03.2017 17:46:17
// Design Name: 
// Module Name: priority_enc_4to2
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


module priority_enc_4to2(
input  wire [3:0] data_in_i,
output wire [1:0] data_out_o
    );

assign data_out_o[1] = (data_in_i[3]) | (~data_in_i[3] & data_in_i[2]);
assign data_out_o[0] = (data_in_i[3]) | (~data_in_i[3] & ~data_in_i[2] & data_in_i[1]);

endmodule
