`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/29/2022 06:27:25 PM
// Design Name: 
// Module Name: Synchronizer
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


module Synchronizer(clk, rst,pre, out);

input clk;
input pre;
input rst;
output  out;
reg q1,q2;
always @(posedge clk)begin
if(rst == 1)begin
q1<= 0;
q2 <= 0;
end
else begin
q1 <= pre;
q2 <= q1;

end

end
assign out = q2;
endmodule
