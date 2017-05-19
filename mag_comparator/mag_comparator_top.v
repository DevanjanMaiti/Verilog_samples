`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Devanjan Maiti 
// 
// Create Date: 23.03.2017 19:18:07
// Design Name: 
// Module Name: mag_comparator_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description:
//        G = Gmsb + Emsb.Glsb
//        E = Emsb.Elsb
//        L = Lmsb + Emsb.Llsb 
// 
//     The code below is for a 2-bit comparator
//
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mag_comparator_top(
input  wire [1:0] in1_i,
input  wire [1:0] in2_i,
output wire       greater_o,
output wire       equal_o,
output wire       lesser_o
    );

assign greater_o = (in1_i[1] & ~in2_i[1]) | (((in1_i[1] & in2_i[1]) | (~in1_i[1] & ~in2_i[1])) & (in1_i[0] & ~in2_i[0]));
assign equal_o   = ((in1_i[1] & in2_i[1]) | (~in1_i[1] & ~in2_i[1])) & ((in1_i[0] & in2_i[0]) | (~in1_i[0] & ~in2_i[0]));
assign lesser_o  = (~in1_i[1] & in2_i[1]) | (((in1_i[1] & in2_i[1]) | (~in1_i[1] & ~in2_i[1])) & (~in1_i[0] & in2_i[0]));


endmodule
