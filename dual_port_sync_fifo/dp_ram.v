`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.04.2017 16:32:06
// Design Name: 
// Module Name: dp_ram
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Verilog Model for a Dual Port Synchronous RAM  
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module dp_ram #(
// Parameters
parameter ADDR_WIDTH = 10,
parameter DATA_WIDTH = 8
)(
input  wire                  clk,

input  wire                  cs_i,

input  wire                  wren1_i,
input  wire [ADDR_WIDTH-1:0] addr1_i,
input  wire [DATA_WIDTH-1:0] wr_data1_i,
output wire [DATA_WIDTH-1:0] rd_data1_o,

input  wire                  wren2_i,
input  wire [ADDR_WIDTH-1:0] addr2_i,
input  wire [DATA_WIDTH-1:0] wr_data2_i,
output wire [DATA_WIDTH-1:0] rd_data2_o
    );

// Local parameters
parameter RAM_DEPTH = 1 << ADDR_WIDTH;

// Local Reg/Wire declarations
reg [DATA_WIDTH-1:0] mem[RAM_DEPTH-1:0];
reg [DATA_WIDTH-1:0] rd_data1_reg;
reg [DATA_WIDTH-1:0] rd_data2_reg;

// PORT 1 Data Write 
always@ (posedge clk) begin
  if (cs_i && wren1_i) begin
    mem[addr1_i] <= wr_data1_i;
  end else begin
    mem[addr1_i] <= mem[addr1_i];
  end
end

// PORT 1 Data Read
always@ (posedge clk) begin
  if (cs_i && !wren1_i) begin
    rd_data1_reg <= mem[addr1_i];
  end else begin
    rd_data1_reg <= rd_data1_reg;
  end
end

assign rd_data1_o = rd_data1_reg; 

// PORT 2 Data Write 
always@ (posedge clk) begin
  if (cs_i && wren2_i) begin
    mem[addr2_i] <= wr_data2_i;
  end else begin
    mem[addr2_i] <= mem[addr2_i];
  end
end

// PORT 2 Data Read
always@ (posedge clk) begin
  if (cs_i && !wren2_i) begin
    rd_data2_reg <= mem[addr2_i];
  end else begin
    rd_data2_reg <= rd_data2_reg;
  end
end

assign rd_data2_o = rd_data2_reg; 

endmodule
