`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/09/2022 12:46:12 AM
// Design Name: 
// Module Name: Decoder2x4
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
/*
module Decoder2x4(input[1:0]X,output reg [0:3]A);

//active high decoder
  wire nx0, nx1;
  not n1(nx0, X[0]);
  not n2(nx1, X[1]);
  
  and a0(A[0], nx0,nx1);
  and a1(A[1], X[0],nx1);
  and a2(A[2], nx0,X[1]);
  and a3(A[3], X[0],X[1]);

endmodule
*/