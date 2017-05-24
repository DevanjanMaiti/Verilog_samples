`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: IISc
// Engineer: Devanjan Maiti (devanjan@dese.iisc.ernet.in)
// 
// Create Date: 15.05.2017 11:35:33
// Design Name: 
// Module Name: mem_flash_serial
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: This is the verilog module of a serial flash
//              chip supporting single write, burst read and
//              write operations.
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mem_flash_serial(
input  wire Cen,
input  wire Sclk,
input  wire Sin,
output reg  Sout
);

// Paramters
parameter ADDR_WIDTH = 24;
parameter DATA_WIDTH = 8;
parameter ADDR_SIZE = 1 << ADDR_WIDTH;   

// Wire/Reg Declarations ------------------------------------------
reg  [ADDR_WIDTH-1:0] address;
reg  [ADDR_WIDTH-1:0] address_reg;
reg  [ADDR_WIDTH-1:0] addr_reg;
reg  [ADDR_WIDTH-1:0] addr_final;
reg  [DATA_WIDTH-1:0] memory [ADDR_SIZE-1:0]; 

reg  [7:0] opcode;
reg  [3:0] opcode_dec_cnt;
wire [3:0] opcode_dec_cnt_nxt;
reg  [4:0] address_dec_cnt;
wire [4:0] address_dec_cnt_nxt;
reg  [3:0] data_cnt;
wire [3:0] data_cnt_nxt;

// FSM Parameters -------------------------------------------------
parameter SIZE        = 6;
parameter IDLE        = 6'b000001;
parameter OPCODE_DEC  = 6'b000010;
parameter ADDRESS_DEC = 6'b000100;
parameter SINGLE_WR   = 6'b001000;
parameter BURST_RD    = 6'b010000;
parameter BURST_WR    = 6'b100000;   

// FSM Variables --------------------------------------------------
reg [SIZE-1:0] pre_state;
reg [SIZE-1:0] next_state;

// FSM Next State Logic -------------------------------------------
always@ (*) begin
  next_state = IDLE;
  
  case(pre_state)
    IDLE:        if (Cen) begin
                   next_state = IDLE;
                 end else begin
                   next_state = OPCODE_DEC;
                 end
    
    OPCODE_DEC:  if (opcode_dec_cnt == 4'd0) begin
                   next_state = ADDRESS_DEC;
                 end else begin
                   next_state = OPCODE_DEC;
                 end
    
    ADDRESS_DEC: if (address_dec_cnt == 5'd0) begin
                   if(opcode == 8'h04) begin  // Single Write Opcode
                     next_state = SINGLE_WR;
                   end else if (opcode == 8'h02) begin  // Burst Write Opcode
                     next_state = BURST_WR;
                   end else begin // Burst Read Opcode (8'h03)
                     next_state = BURST_RD;
                   end
                 end else begin
                   next_state = ADDRESS_DEC;
                 end
    
    SINGLE_WR:   if (Cen) begin
                   next_state = IDLE;
                 end else begin
                   next_state = SINGLE_WR;
                 end
    
    BURST_WR:    if (Cen) begin
	           next_state = IDLE;
		 end else begin
		   next_state = BURST_WR;
		 end
    
    BURST_RD:    if (Cen) begin
	           next_state = IDLE;
		 end else begin
		   next_state = BURST_RD;
		 end
    
    default:     next_state = IDLE;
  endcase
end

// FSM Present State Register -------------------------------------
always@ (posedge Sclk) begin
  if (Cen) begin
    pre_state <= IDLE;
  end else begin
    pre_state <= next_state;
  end
end

// FSM Output Glue Logic ------------------------------------------
// Opcode Count Register ------------------------------------------
always@ (posedge Sclk) begin
  if (Cen) begin
    opcode_dec_cnt <= 4'd7;
  end else begin
    opcode_dec_cnt <= opcode_dec_cnt_nxt;
  end
end

assign opcode_dec_cnt_nxt = (pre_state == IDLE) ? 4'd7 : (((pre_state == OPCODE_DEC) && (opcode_dec_cnt != 4'd0)) ? (opcode_dec_cnt - 1'b1) : 4'd7);

// Address Count Register ------------------------------------------
always@ (posedge Sclk) begin
  if (Cen) begin
    address_dec_cnt <= 5'd23;
  end else begin
    address_dec_cnt <= address_dec_cnt_nxt;
  end
end

assign address_dec_cnt_nxt = (pre_state == IDLE) ? 5'd23 : (((pre_state == ADDRESS_DEC) && (address_dec_cnt != 5'd0)) ? (address_dec_cnt - 1'b1) : 5'd23);

// Data Count Register ---------------------------------------------
always@ (posedge Sclk) begin
  if (Cen) begin
    data_cnt <= 4'd7;
  end else begin
    data_cnt <= data_cnt_nxt;
  end
end

assign data_cnt_nxt = (pre_state == IDLE) ? 4'd7 : ((((pre_state == SINGLE_WR) || (pre_state == BURST_RD) || (pre_state == BURST_WR)) && (data_cnt != 4'd0)) ? (data_cnt - 1'b1) : 4'd7);

// Opcode Register -------------------------------------------------
always@ (posedge Sclk) begin
  if (Cen) begin
    opcode <= 8'b0;
  end else if (pre_state == OPCODE_DEC) begin
    opcode[opcode_dec_cnt] <= Sin;
  end else begin
    opcode <= opcode; 
  end
end

// Address Management ----------------------------------------------
always@ (*) begin
  if (Cen) begin
    address = 8'b0;
  end else if (pre_state == ADDRESS_DEC) begin
    address[address_dec_cnt] = Sin;
//  end else if ((pre_state == BURST_RD || pre_state == BURST_WR) && (data_cnt == 4'd0)) begin
//    address = address + 1'b1;  
  end else begin
    address = address; 
  end
end

always@ (posedge Sclk) begin
  if (Cen) begin
    addr_reg <= 24'b0;
  end else if (pre_state == ADDRESS_DEC) begin
    addr_reg <= address;
  end else if ((pre_state == BURST_RD || pre_state == BURST_WR) && (data_cnt_nxt == 4'd0)) begin
    addr_reg <= addr_reg + 1'b1;
  end
end

always@ (*) begin
  if (pre_state == ADDRESS_DEC) begin
    addr_final = address;
  end else if (pre_state == BURST_RD || pre_state == BURST_WR) begin
    addr_final = addr_reg;
  end else begin
    addr_final = addr_final;
  end
end

always@ (posedge Sclk) begin
  if (Cen) begin
    address_reg <= 24'b0;
  end else begin
    address_reg <= addr_final;
  end
end

// Write Mode (Single and Burst) -----------------------------------
always@ (posedge Sclk) begin
  if ((pre_state == SINGLE_WR) || (pre_state == BURST_WR)) begin 
    memory[address_reg][data_cnt] <= Sin;
  end else begin
    memory[address_reg] <= memory[address_reg];
  end
end

// Read Mode -------------------------------------------------------
always@ (negedge Sclk) begin
  if (next_state == BURST_RD) begin
    Sout <= memory[addr_final][data_cnt_nxt];
  end else begin
    Sout <= 1'bz;
  end
end

endmodule
