`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.03.2017 14:30:31
// Design Name: 
// Module Name: fp_normalizer_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Floating Point Normalizer using a 16-bit barrel shifter inside 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fp_normalizer_top(
input  wire        clk,
input  wire        rst_n,
input  wire [15:0] denorm_data_i,
output wire [15:0] norm_data_o,
output wire [ 3:0] leading_bit_o
    );

// Wire/Reg Declarations
reg  [15:0] denorm_data_reg;
wire [ 3:0] or_4input;
wire [ 3:0] sel;
reg  [ 3:0] leading_bit;
reg  [ 3:0] mux_out;
reg  [15:0] shifted_data_reg;
wire [15:0] bs_data_out;

// Leading 1 position detection
assign or_4input[3] = denorm_data_reg[15] | denorm_data_reg[14] | denorm_data_reg[13] | denorm_data_reg[12];
assign or_4input[2] = denorm_data_reg[11] | denorm_data_reg[10] | denorm_data_reg[ 9] | denorm_data_reg[ 8];
assign or_4input[1] = denorm_data_reg[ 7] | denorm_data_reg[ 6] | denorm_data_reg[ 5] | denorm_data_reg[ 4];
assign or_4input[0] = denorm_data_reg[ 3] | denorm_data_reg[ 2] | denorm_data_reg[ 1] | denorm_data_reg[ 0];

// 4to2 Priority Encoder 1st Instance
priority_enc_4to2 priority_enc_4to2_inst1(
  .data_in_i(or_4input),
  .data_out_o(sel[3:2])
);

// 4to1 MUXes
always @* begin
  case (sel[3:2]) 
    00: mux_out[3] = denorm_data_reg[15]; 
    01: mux_out[3] = denorm_data_reg[11];
    10: mux_out[3] = denorm_data_reg[ 7];
    11: mux_out[3] = denorm_data_reg[ 3];
  endcase
end

always @* begin
  case (sel[3:2]) 
    00: mux_out[2] = denorm_data_reg[14]; 
    01: mux_out[2] = denorm_data_reg[10];
    10: mux_out[2] = denorm_data_reg[ 6];
    11: mux_out[2] = denorm_data_reg[ 2];
  endcase
end

always @* begin
  case (sel[3:2]) 
    00: mux_out[1] = denorm_data_reg[13]; 
    01: mux_out[1] = denorm_data_reg[ 9];
    10: mux_out[1] = denorm_data_reg[ 5];
    11: mux_out[1] = denorm_data_reg[ 1];
  endcase
end

always @* begin
  case (sel[3:2]) 
    00: mux_out[0] = denorm_data_reg[12]; 
    01: mux_out[0] = denorm_data_reg[ 8];
    10: mux_out[0] = denorm_data_reg[ 4];
    11: mux_out[0] = denorm_data_reg[ 0];
  endcase
end

// 4to2 Priority Encoder 2nd Instance
priority_enc_4to2 priority_enc_4to2_inst2(
  .data_in_i(mux_out),
  .data_out_o(sel[1:0])
);

// Barrel Shifter Instance
barrel_shifter barrel_shifter_inst(
  .data_in_i(denorm_data_reg),
  .shift_i(~sel),
  .data_out_o(bs_data_out)
);

// Denormalized data input register
always@ (posedge clk or negedge rst_n) begin
  if(~rst_n) begin
    denorm_data_reg <= 16'b0;
  end else begin
    denorm_data_reg <= denorm_data_i;
  end
end

// Normalized data output register
always@ (posedge clk or negedge rst_n) begin
  if(~rst_n) begin
    shifted_data_reg <= 16'b0;
  end else begin
    shifted_data_reg <= bs_data_out;
  end
end

// Output assignments
assign leading_bit_o = sel;
assign norm_data_o = shifted_data_reg;

endmodule
