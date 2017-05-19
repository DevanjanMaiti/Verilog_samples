`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.03.2017 12:19:19
// Design Name: 
// Module Name: demux_4x1_top
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


module demux_4x1_top(

input  wire       data_in_i,
input  wire [1:0] sel_i,
output reg  [3:0] data_out_o

    );
    
//---------------------------------
//    WIRE/REG Declarations
//---------------------------------


//---------------------------------
//        Glue Logic
//---------------------------------
always@ (sel_i or data_in_i) begin
case (sel_i)
2'b00: begin 
    data_out_o[0] = data_in_i;
    data_out_o[1] = 1'b0;
    data_out_o[2] = 1'b0;
    data_out_o[3] = 1'b0;
    end
2'b01: begin
    data_out_o[0] = 1'b0;
    data_out_o[1] = data_in_i;
    data_out_o[2] = 1'b0;
    data_out_o[3] = 1'b0;   
    end
2'b10: begin
    data_out_o[0] = 1'b0;
    data_out_o[1] = 1'b0;
    data_out_o[2] = data_in_i;
    data_out_o[3] = 1'b0; 
    end
2'b11: begin
    data_out_o[0] = 1'b0;
    data_out_o[1] = 1'b0;
    data_out_o[2] = 1'b0;
    data_out_o[3] = data_in_i; 
    end 
endcase
end
    
endmodule
