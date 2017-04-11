`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.04.2017 19:14:07
// Design Name: 
// Module Name: dp_ram_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Dual Port Synchronous RAM Testbench 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module dp_ram_tb(

    );

// Local parameters
parameter ADDRESS_WIDTH = 10;
parameter DATA_WIDTH    = 8;

// Local Wire/Reg Declarations
reg                      clk;
reg                      csel;
reg                      wren1;
reg  [ADDRESS_WIDTH-1:0] address1;
reg  [DATA_WIDTH-1:0]    wr_data1;
wire [DATA_WIDTH-1:0]    rd_data1;
reg                      wren2;
reg  [ADDRESS_WIDTH-1:0] address2;
reg  [DATA_WIDTH-1:0]    wr_data2;
wire [DATA_WIDTH-1:0]    rd_data2;

// DUT Instance
dp_ram #(
  .ADDR_WIDTH(ADDRESS_WIDTH),
  .DATA_WIDTH(DATA_WIDTH)
) dp_ram_dut(
  .clk(clk),
  .cs_i(csel),
  .wren1_i(wren1),
  .addr1_i(address1),
  .wr_data1_i(wr_data1),
  .rd_data1_o(rd_data1),
  .wren2_i(wren2),
  .addr2_i(address2),
  .wr_data2_i(wr_data2),
  .rd_data2_o(rd_data2)
);

initial begin
clk = 1'b0;
forever #10 clk = ~clk;
end

initial begin
#50
address1 = 10'd10;
wr_data1 = 8'hAB;
wren1 = 1'b1;
csel = 1'b1;
#50
address1 = 10'd10;
wr_data1 = 8'hCD;
wren1 = 1'b1;
csel = 1'b1;
address2 = 10'd10;
wren2 = 1'b0;
#50
address2 = 10'd10;
wren1 = 1'b0;
wren2 = 1'b0;
#50
//#50
//address1 = 10'd1;
//wr_data1 = 8'hAA;
//wren1 = 1'b1;
//csel = 1'b1;
//#50
//address1 = 10'd5;
//wr_data1 = 8'hBB;
//wren1 = 1'b1;
//csel = 1'b1;
//#50
//address1 = 10'd1;
//wren1 = 1'b0;
//csel = 1'b1;
//#50
//address1 = 10'd5;
//wren1 = 1'b0;
//csel = 1'b1;
//#50
//address2 = 10'd1023;
//wr_data2 = 8'hCC;
//wren2 = 1'b1;
//csel = 1'b1;
//#50
//address2 = 10'd500;
//wr_data2 = 8'hDD;
//wren2 = 1'b1;
//csel = 1'b1;
//#50
//address2 = 10'd1023;
//wren2 = 1'b0;
//csel = 1'b1;
//#50
//address2 = 10'd500;
//wren2 = 1'b0;
//csel = 1'b1;
//#50
repeat(100) @(posedge clk);
$finish;
end

endmodule
