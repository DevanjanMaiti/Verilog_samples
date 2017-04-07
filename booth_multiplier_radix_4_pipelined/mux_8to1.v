`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.03.2017 18:29:07
// Design Name: 
// Module Name: mux_8to1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 8-bits, 8 input to 1 output Multiplexer
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mux_8to1(
input  wire [72:0] data_in_i,
input  wire [ 2:0] sel_i,
output reg  [ 8:0] data_out_o
    );

always@* begin
  case(sel_i)
    3'b000: data_out_o = data_in_i[ 8: 0]; 
    3'b001: data_out_o = data_in_i[17: 9];
    3'b010: data_out_o = data_in_i[26:18];
    3'b011: data_out_o = data_in_i[35:27];
    3'b100: data_out_o = data_in_i[44:36];
    3'b101: data_out_o = data_in_i[53:45];
    3'b110: data_out_o = data_in_i[62:54];
    3'b111: data_out_o = data_in_i[71:63];
  endcase
end 

endmodule