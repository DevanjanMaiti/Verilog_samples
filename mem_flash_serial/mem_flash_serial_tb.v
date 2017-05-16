`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: IISc
// Engineer: Devanjan Maiti (devanjan@dese.iisc.ernet.in)
// 
// Create Date: 15.05.2017 11:38:30
// Design Name: 
// Module Name: mem_flash_serial_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: This is a verilog testbench for the serial flash
//              chip model that supports single write, burst read
//              and write operations.
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`define BURST_MODE

module mem_flash_serial_tb(

);
// Wire/Reg Declarations ------------------------------------------
reg  Cen;  // Chip Enable
reg  Sclk; // Clk to Flash
reg  Sin;  // Input Data to Flash
wire Sout; // Output from Flash

reg  [ 7:0] opcode;
reg  [23:0] address;
reg  [ 7:0] single_wr_data;
wire [39:0] single_wr_reg;
wire [31:0] burst_rd_reg;
reg  [39:0] burst_wr_data;  // 5 Bytes of Burst Data
wire [71:0] burst_wr_reg;   // 5 Bytes of Burst Data
reg  [ 6:0] wr_count;

// Data Initialization --------------------------------------------
initial begin
`ifndef BURST_MODE
  #40
  opcode         = 8'h04;
  address        = 24'hFFFFFF;
  single_wr_data = 8'hAA;
  #2000  // Wait for Write to happen
  opcode         = 8'h03;
  address        = 24'hFFFFFF;
`else
  #40
  opcode         = 8'h02;
  address        = 24'hFFFFA5;
  burst_wr_data  = 40'h00A0A0A0AF;
  #3200  // Wait for Write to happen
  opcode         = 8'h03;
  address        = 24'hFFFFA5;
`endif
end

assign single_wr_reg = {opcode, address, single_wr_data};
assign burst_wr_reg  = {opcode, address, burst_wr_data};
assign burst_rd_reg  = {opcode, address};

// DUT Instance ---------------------------------------------------
mem_flash_serial mem_flash_serial_inst(
  .Cen  (Cen),
  .Sclk (Sclk),
  .Sin  (Sin),
  .Sout (Sout)
);

// Test Logic -----------------------------------------------------
initial begin
  Sclk = 1'b0;
  #30
  forever #20 Sclk = ~Sclk;
end

initial begin
`ifndef BURST_MODE
  #50
  Cen = 1'b1;
  #50
  Cen = 1'b0;
  #1600  // Wait for Write to happen
  Cen = 1'b1;
  #400
  Cen = 1'b0;
  #1600  // Wait for Burst Read to happen
  Cen = 1'b1;
`else
  #50
  Cen = 1'b1;
  #50
  Cen = 1'b0;
  #2900  // Wait for Write to happen
  Cen = 1'b1;
  #400
  Cen = 1'b0;
  #2850  // Wait for Burst Read to happen
  Cen = 1'b1;
`endif
end 

`ifndef BURST_MODE
// Single Write ---------------------------------------------------
always@ (posedge Sclk) begin
  if (Cen) begin
    wr_count <= 7'b0;
  end else if ((wr_count < 7'd40) && (opcode == 8'h04)) begin 
    Sin <= single_wr_reg[7'd39 - wr_count];  // MSB First
    wr_count <= wr_count + 1'b1;      
  end else if ((wr_count < 7'd32) && (opcode == 8'h03)) begin
    Sin <= burst_rd_reg[7'd31 - wr_count];   // MSB First
    wr_count <= wr_count + 1'b1;      
  end
end
`else
// Burst Write ----------------------------------------------------
always@ (posedge Sclk) begin
  if (Cen) begin
    wr_count <= 7'b0;
    Sin <= 1'bx;
  end else if ((wr_count < 7'd72) && (opcode == 8'h02)) begin 
    Sin <= burst_wr_reg[7'd71 - wr_count];  // MSB First
    wr_count <= wr_count + 1'b1;      
  end else if ((wr_count < 7'd32) && (opcode == 8'h03)) begin
    Sin <= burst_rd_reg[7'd31 - wr_count];   // MSB First
    wr_count <= wr_count + 1'b1;      
  end
end
`endif

endmodule
