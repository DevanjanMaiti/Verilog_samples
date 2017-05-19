`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.03.2017 17:07:01
// Design Name: 
// Module Name: priority_encoder_ifelse
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


module priority_encoder_ifelse(

input  wire [2:0] data_in_i,
output reg  [1:0] data_out_o
 
    );
    
always@ (data_in_i) begin    
  if (data_in_i[2]) begin
    data_out_o = 2'b11;
  end else if (data_in_i[1]) begin
    data_out_o = 2'b10; 
  end else if (data_in_i[0]) begin
    data_out_o = 2'b01; 
  end else begin
    data_out_o = 2'b00;  
  end    
end
    
endmodule
