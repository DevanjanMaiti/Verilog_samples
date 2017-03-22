`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2016 15:27:15
// Design Name: 
// Module Name: divider_top
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


module divider_top (

    input  wire            clk,
    input  wire            rst_n,
    input  wire            start_i,
    input  wire    [06:00] divisor_i,
    output wire    [06:00] quotient_o
);

//--------------------------------------------
//           WIRE/REG DECLARATIONS
//--------------------------------------------
  reg      [06:00] divisor;  
  reg      [07:00] div_temp; 
  reg      [06:00] quo_counter;
  reg      [06:00] quotient;
  reg              start_status;
  reg              start_status_reg;
  reg      [06:00] dividend;
  reg      [06:00] remainder;
  reg              done;

  wire     [06:00] twos_comp_out;
  wire             overflow; 
  wire     [07:00] adder_out;
  wire     [06:00] mux_out;
  wire     [06:00] start_mux_out;
  
parameter DIVIDEND = 7'd17;  

assign overflow = div_temp[7];

always @(posedge clk or negedge rst_n) begin
  if (~rst_n)
    start_status <= 1'b0; 
  else
    start_status <= (start_i || start_status);
end

always @(posedge clk or negedge rst_n) begin
  if (~rst_n)
    start_status_reg <= 1'b0; 
  else
    start_status_reg <= start_status;
end

always @(posedge clk or negedge rst_n) begin
  if (~rst_n)
    remainder <= 7'b0; 
  else if ((cur_state == SUB) && (~overflow))
    remainder <= adder_out[6:0];
end

always @(posedge clk or negedge rst_n) begin
  if (~rst_n)
    done <= 1'b0; 
  else if ((cur_state == SUB) && (~overflow))
    done <= 1'b1;
end

//--------------------------------------------
//            CONTROLLER FSM
//--------------------------------------------
parameter IDLE      = 4'b0001; 
parameter SUB       = 4'b0010; 
parameter ADD       = 4'b0100; 
parameter RESULT    = 4'b1000; 

reg    [03:00] cur_state;
reg    [03:00] next_state;

always @(posedge clk or negedge rst_n) begin
  if (~rst_n)
    cur_state <= IDLE; 
  else
    cur_state <= next_state;
end

always @(cur_state or overflow) begin
  case (cur_state)
    IDLE:      if (overflow)
                 next_state = SUB;
               else 
                 next_state = IDLE;
    SUB:       if(~overflow)
                 next_state = ADD;
               else
                 next_state = SUB;
    ADD:         next_state = RESULT;
    RESULT:      next_state = RESULT;   
    default:     next_state = IDLE;
  endcase
end

//--------------------------------------------
//         START SIGNAL GEN FSM 
//--------------------------------------------
parameter RST  = 3'b001; 
parameter LOW  = 3'b010; 
parameter HIGH = 3'b100; 

reg    [02:00] pre_state;
reg    [02:00] nex_state;

always @(posedge clk or negedge rst_n) begin
  if (~rst_n)
    pre_state <= RST; 
  else
    pre_state <= nex_state;
end

always @(pre_state or start_i) begin
  case (pre_state)
    RST:     
             if (~start_i)  
               nex_state = LOW;
             else 
               nex_state = RST;
    LOW:     if (start_i)
               nex_state = HIGH;
             else
               nex_state = LOW;
    HIGH:    
             nex_state = RST;
    default: nex_state = RST;
  endcase
end

//--------------------------------------------
//      DIVIDEND/TEMP/REMAINDER REGISTER
//--------------------------------------------
always @(posedge clk or negedge rst_n) begin
  if (~rst_n)
    div_temp <= 8'b0; //TODO: Set overflow and feed fixed data and find out how overflow will come (bit-width issues)
  else if (pre_state == HIGH) 
    div_temp <= {1'b1, DIVIDEND}; //DIVIDEND VALUE
  else 
    div_temp <= adder_out;
end

//--------------------------------------------
//          DIVIDEND REGISTER
//--------------------------------------------
always @(posedge clk or negedge rst_n) begin
  if (~rst_n)
    dividend <= 8'b0; 
  else if (pre_state == RST) 
    dividend <= div_temp[6:0]; //DIVIDEND VALUE
  else 
    dividend <= dividend;
end

//--------------------------------------------
//            DIVISOR REGISTER 
//--------------------------------------------
always @(posedge clk or negedge rst_n) begin
  if (~rst_n)
    divisor <= 7'b0;
  else
    divisor <= divisor_i;
end

//--------------------------------------------
//            TWOS COMPLEMENTER
//--------------------------------------------
assign twos_comp_out = (~start_mux_out) + 7'd1;

//--------------------------------------------
//               ADD/SUB MUX
//--------------------------------------------
assign mux_out = (overflow) ? twos_comp_out : start_mux_out;

//--------------------------------------------
//               START MUX
//--------------------------------------------
assign start_mux_out = (start_status_reg) ? divisor : 7'b0;

//--------------------------------------------
//                  ADDER
//--------------------------------------------
assign adder_out = div_temp[6:0] + mux_out;

//--------------------------------------------
//             QUOTIENT COUNTER 
//--------------------------------------------
always @(posedge clk or negedge rst_n) begin 
  if (~rst_n)
    quo_counter <= 7'b0;
  else if (overflow)
    quo_counter <= quo_counter + 7'd1;
  else 
    quo_counter <= quo_counter;
end

//--------------------------------------------
//             QUOTIENT REGISTER 
//--------------------------------------------
always @(posedge clk or negedge rst_n) begin
  if (~rst_n)
    quotient <= 7'b0;
  else if (~overflow && ~done)
    quotient <= quo_counter - 1'b1;
  else 
    quotient <= quotient;    
end

//--------------------------------------------
//             QUOTIENT OUTPUT 
//--------------------------------------------
assign quotient_o = ~quotient;

endmodule
