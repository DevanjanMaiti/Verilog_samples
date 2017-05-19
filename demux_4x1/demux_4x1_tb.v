`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.03.2017 14:01:41
// Design Name: 
// Module Name: demux_4x1_tb
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


module demux_4x1_tb(

    );
    
reg        input_data;
reg  [1:0] select;   
wire [3:0] output_data; 
  
//DUT Instance    
demux_4x1_top demux_4x1_top_dut(
  .data_in_i(input_data),
  .sel_i(select),
  .data_out_o(output_data)
);

initial begin

#50
input_data = 1'b1;
select = 2'b00;
#20
select = 2'b01;
#20
select = 2'b10;
#20
select = 2'b11;

end

endmodule
