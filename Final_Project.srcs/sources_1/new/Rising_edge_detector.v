`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2022 01:02:45 PM
// Design Name: 
// Module Name: seq_det
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


module Rising_edge_detector(clk, rst, x, z );
input clk, rst, x;
output  z;

reg[1:0] state, nxtstate;
parameter [1:0] A= 2'b00, B = 2'b01, C= 2'b10;

always @ (x , state) begin
case(state)
A: if(x== 0)begin
 nxtstate = B;

 end
 else
 begin 
  nxtstate = A;

 end
B:
if(x== 0)begin
 nxtstate = B;

 end
 else
 begin 
  nxtstate = C;

 end
 
C:
if(x== 0)begin
 nxtstate = B;

 end
 else
 begin 
  nxtstate = A;

 end

 endcase
 end
 
 always @(posedge clk) begin
 if(rst == 1) state <= B;
 else state <= nxtstate;
 
 end
 
 assign z= (state == C);
endmodule
