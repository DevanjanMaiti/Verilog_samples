`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.03.2017 16:08:43
// Design Name: 
// Module Name: barrel_shifter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 16-bit Barrel Shifter Module
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module barrel_shifter(
input  wire [15:0] data_in_i,
input  wire [ 3:0] shift_i,
output wire [15:0] data_out_o  
    );

// First stage MUXes
assign muxout_c0r0  = shift_i[0] ? 1'b0          : data_in_i[0];
assign muxout_c0r1  = shift_i[0] ? data_in_i[0]  : data_in_i[1];
assign muxout_c0r2  = shift_i[0] ? data_in_i[1]  : data_in_i[2];
assign muxout_c0r3  = shift_i[0] ? data_in_i[2]  : data_in_i[3];
assign muxout_c0r4  = shift_i[0] ? data_in_i[3]  : data_in_i[4];
assign muxout_c0r5  = shift_i[0] ? data_in_i[4]  : data_in_i[5];
assign muxout_c0r6  = shift_i[0] ? data_in_i[5]  : data_in_i[6];
assign muxout_c0r7  = shift_i[0] ? data_in_i[6]  : data_in_i[7];
assign muxout_c0r8  = shift_i[0] ? data_in_i[7]  : data_in_i[8];
assign muxout_c0r9  = shift_i[0] ? data_in_i[8]  : data_in_i[9];
assign muxout_c0r10 = shift_i[0] ? data_in_i[9]  : data_in_i[10];
assign muxout_c0r11 = shift_i[0] ? data_in_i[10] : data_in_i[11];
assign muxout_c0r12 = shift_i[0] ? data_in_i[11] : data_in_i[12];
assign muxout_c0r13 = shift_i[0] ? data_in_i[12] : data_in_i[13];
assign muxout_c0r14 = shift_i[0] ? data_in_i[13] : data_in_i[14];
assign muxout_c0r15 = shift_i[0] ? data_in_i[14] : data_in_i[15];

// Second stage MUXes
assign muxout_c1r0  = shift_i[1] ? 1'b0         : muxout_c0r0;
assign muxout_c1r1  = shift_i[1] ? 1'b0         : muxout_c0r1;
assign muxout_c1r2  = shift_i[1] ? muxout_c0r0  : muxout_c0r2;
assign muxout_c1r3  = shift_i[1] ? muxout_c0r1  : muxout_c0r3;
assign muxout_c1r4  = shift_i[1] ? muxout_c0r2  : muxout_c0r4;
assign muxout_c1r5  = shift_i[1] ? muxout_c0r3  : muxout_c0r5;
assign muxout_c1r6  = shift_i[1] ? muxout_c0r4  : muxout_c0r6;
assign muxout_c1r7  = shift_i[1] ? muxout_c0r5  : muxout_c0r7;
assign muxout_c1r8  = shift_i[1] ? muxout_c0r6  : muxout_c0r8;
assign muxout_c1r9  = shift_i[1] ? muxout_c0r7  : muxout_c0r9;
assign muxout_c1r10 = shift_i[1] ? muxout_c0r8  : muxout_c0r10;
assign muxout_c1r11 = shift_i[1] ? muxout_c0r9  : muxout_c0r11;
assign muxout_c1r12 = shift_i[1] ? muxout_c0r10 : muxout_c0r12;
assign muxout_c1r13 = shift_i[1] ? muxout_c0r11 : muxout_c0r13;
assign muxout_c1r14 = shift_i[1] ? muxout_c0r12 : muxout_c0r14;
assign muxout_c1r15 = shift_i[1] ? muxout_c0r13 : muxout_c0r15;

// Third stage MUXes
assign muxout_c2r0  = shift_i[2] ? 1'b0         : muxout_c1r0;
assign muxout_c2r1  = shift_i[2] ? 1'b0         : muxout_c1r1;
assign muxout_c2r2  = shift_i[2] ? 1'b0         : muxout_c1r2;
assign muxout_c2r3  = shift_i[2] ? 1'b0         : muxout_c1r3;
assign muxout_c2r4  = shift_i[2] ? muxout_c1r0  : muxout_c1r4;
assign muxout_c2r5  = shift_i[2] ? muxout_c1r1  : muxout_c1r5;
assign muxout_c2r6  = shift_i[2] ? muxout_c1r2  : muxout_c1r6;
assign muxout_c2r7  = shift_i[2] ? muxout_c1r3  : muxout_c1r7;
assign muxout_c2r8  = shift_i[2] ? muxout_c1r4  : muxout_c1r8;
assign muxout_c2r9  = shift_i[2] ? muxout_c1r5  : muxout_c1r9;
assign muxout_c2r10 = shift_i[2] ? muxout_c1r6  : muxout_c1r10;
assign muxout_c2r11 = shift_i[2] ? muxout_c1r7  : muxout_c1r11;
assign muxout_c2r12 = shift_i[2] ? muxout_c1r8  : muxout_c1r12;
assign muxout_c2r13 = shift_i[2] ? muxout_c1r9  : muxout_c1r13;
assign muxout_c2r14 = shift_i[2] ? muxout_c1r10 : muxout_c1r14;
assign muxout_c2r15 = shift_i[2] ? muxout_c1r11 : muxout_c1r15;

// Fourth stage MUXes
assign data_out_o[0]  = shift_i[3] ? 1'b0         : muxout_c2r0;
assign data_out_o[1]  = shift_i[3] ? 1'b0         : muxout_c2r1;
assign data_out_o[2]  = shift_i[3] ? 1'b0         : muxout_c2r2;
assign data_out_o[3]  = shift_i[3] ? 1'b0         : muxout_c2r3;
assign data_out_o[4]  = shift_i[3] ? 1'b0         : muxout_c2r4;
assign data_out_o[5]  = shift_i[3] ? 1'b0         : muxout_c2r5;
assign data_out_o[6]  = shift_i[3] ? 1'b0         : muxout_c2r6;
assign data_out_o[7]  = shift_i[3] ? 1'b0         : muxout_c2r7;
assign data_out_o[8]  = shift_i[3] ? muxout_c2r0  : muxout_c2r8;
assign data_out_o[9]  = shift_i[3] ? muxout_c2r1  : muxout_c2r9;
assign data_out_o[10] = shift_i[3] ? muxout_c2r2  : muxout_c2r10;
assign data_out_o[11] = shift_i[3] ? muxout_c2r3  : muxout_c2r11;
assign data_out_o[12] = shift_i[3] ? muxout_c2r4  : muxout_c2r12;
assign data_out_o[13] = shift_i[3] ? muxout_c2r5  : muxout_c2r13;
assign data_out_o[14] = shift_i[3] ? muxout_c2r6  : muxout_c2r14;
assign data_out_o[15] = shift_i[3] ? muxout_c2r7  : muxout_c2r15;

endmodule
