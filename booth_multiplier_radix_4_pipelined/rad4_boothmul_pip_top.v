`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.03.2017 17:35:20
// Design Name: 
// Module Name: rad4_booth_mul_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description:This is my implementation of an 8-bit Radix-4 Booth Multiplier 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module rad4_boothmul_pip_top(
input  wire        clk,
input  wire        rst_n,
input  wire [ 7:0] mltplr_i,
input  wire [ 7:0] mltplcnd_i,
output wire [15:0] prdct_o
    );

// wire/reg declarations
reg  [ 8:0] mltplcnd_reg;
reg  [ 7:0] mltplr_reg;

wire [72:0] mux_data_in;     

wire [ 2:0] mux0_sel;
wire [ 2:0] mux1_sel;
wire [ 2:0] mux2_sel;
wire [ 2:0] mux3_sel;

wire [ 8:0] mltpclnd_x0; // Sign-extended
wire [ 8:0] mltpclnd_x1;
wire [ 8:0] mltpclnd_xneg1;
wire [ 8:0] mltpclnd_x2;
wire [ 8:0] mltpclnd_xneg2;

wire [ 8:0] mux0_out;
wire [ 8:0] mux1_out;
wire [ 8:0] mux2_out;
wire [ 8:0] mux3_out;

reg  [ 8:0] mux0_out_reg;
reg  [ 8:0] mux1_out_reg;
reg  [ 8:0] mux2_out_reg;
reg  [ 8:0] mux3_out_reg;

wire [ 8:0] shifted_0bits;
wire [10:0] shifted_2bits;
wire [12:0] shifted_4bits;
wire [14:0] shifted_6bits;

wire [15:0] adder_in_0;
wire [15:0] adder_in_1;
wire [15:0] adder_in_2;
wire [15:0] adder_in_3;

reg  [15:0] cla_adder_out;

// Glue logic
// Sign-extended multiplicand register
always@ (posedge clk or negedge rst_n) begin
  if (~rst_n) begin
    mltplcnd_reg <= 9'b0;  
  end else begin
    mltplcnd_reg <= {mltplcnd_i[7], mltplcnd_i};
  end
end

// Multiplier register 
always@ (posedge clk or negedge rst_n) begin
  if (~rst_n) begin
    mltplr_reg <= 9'b0;  
  end else begin
    mltplr_reg <= mltplr_i;
  end
end

// Multiplicand datapath
assign mltpclnd_x0    = 9'b0;
assign mltpclnd_x1    = mltplcnd_reg;
assign mltpclnd_xneg1 = (~mltplcnd_reg) + 1'b1;
assign mltpclnd_x2    = mltplcnd_reg << 1'b1;
assign mltpclnd_xneg2 = ((~mltplcnd_reg) + 1'b1) << 1'b1;

// Multiplier datapath
// MSB to LSB MUX input data concatenation
assign mux_data_in = {mltpclnd_x0, mltpclnd_xneg1, mltpclnd_xneg1, mltpclnd_xneg2, mltpclnd_x2, mltpclnd_x1, mltpclnd_x1, mltpclnd_x0};

// 3 bit MUX sel line concatenation according to Radix-4 Booth algorithm
assign mux0_sel = {mltplr_reg[1], mltplr_reg[0], 1'b0};
assign mux1_sel = {mltplr_reg[3], mltplr_reg[2], mltplr_reg[1]};
assign mux2_sel = {mltplr_reg[5], mltplr_reg[4], mltplr_reg[3]};
assign mux3_sel = {mltplr_reg[7], mltplr_reg[6], mltplr_reg[5]};

// 8to1 Multiplexer 1st instance
mux_8to1 mux_8to1_inst0(
  .data_in_i(mux_data_in),
  .sel_i(mux0_sel),
  .data_out_o(mux0_out)
);

// 8to1 Multiplexer 2nd instance
mux_8to1 mux_8to1_inst1(
  .data_in_i(mux_data_in),
  .sel_i(mux1_sel),
  .data_out_o(mux1_out)
);

// 8to1 Multiplexer 3rd instance
mux_8to1 mux_8to1_inst2(
  .data_in_i(mux_data_in),
  .sel_i(mux2_sel),
  .data_out_o(mux2_out)
);

// 8to1 Multiplexer 4th instance
mux_8to1 mux_8to1_inst3(
  .data_in_i(mux_data_in),
  .sel_i(mux3_sel),
  .data_out_o(mux3_out)
);

// MUX Output register 0
always@ (posedge clk or negedge rst_n) begin
  if (~rst_n) begin
    mux0_out_reg <= 9'b0;  
  end else begin
    mux0_out_reg <= mux0_out;
  end
end

// MUX Output register 1
always@ (posedge clk or negedge rst_n) begin
  if (~rst_n) begin
    mux1_out_reg <= 9'b0;  
  end else begin
    mux1_out_reg <= mux1_out;
  end
end

// MUX Output register 2
always@ (posedge clk or negedge rst_n) begin
  if (~rst_n) begin
    mux2_out_reg <= 9'b0;  
  end else begin
    mux2_out_reg <= mux2_out;
  end
end

// MUX Output register 3
always@ (posedge clk or negedge rst_n) begin
  if (~rst_n) begin
    mux3_out_reg <= 9'b0;  
  end else begin
    mux3_out_reg <= mux3_out;
  end
end

// Shifting of MUX outputs before adding them
assign shifted_0bits = mux0_out_reg;
assign shifted_2bits = mux1_out_reg << 2;
assign shifted_4bits = mux2_out_reg << 4;
assign shifted_6bits = mux3_out_reg << 6;

// Giving sign-extended version of shifted data to adder
assign adder_in_0 = {{7{shifted_0bits[ 8]}}, shifted_0bits}; 
assign adder_in_1 = {{5{shifted_2bits[10]}}, shifted_2bits}; 
assign adder_in_2 = {{3{shifted_4bits[12]}}, shifted_4bits}; 
assign adder_in_3 = {{1{shifted_6bits[14]}}, shifted_6bits}; 

// Final addition using '+' operator (uses CLA Adder resources in FPGA) 
always@ (posedge clk or negedge rst_n) begin
  if (~rst_n) begin
    cla_adder_out <= 16'b0;
  end else begin
    cla_adder_out = adder_in_3 + adder_in_2 + adder_in_1 + adder_in_0;
  end
end

// Final output
assign prdct_o = cla_adder_out;

endmodule
