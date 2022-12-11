`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/09/2022 12:44:34 AM
// Design Name: 
// Module Name: BCD7SEG
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

module BCD7SEG(
input[3:0]X,input [1:0]EN, output reg [0:6]O,output reg [0:3]A
    );
    always@(*)
    begin
    case(X)
    0: O = 7'b0000001;
    1: O = 7'b1001111;
    2: O = 7'b0010010;
    3: O = 7'b0000110;
    4: O = 7'b1001100;
    5: O = 7'b0100100;
    6: O = 7'b0100000;
    7: O = 7'b0001111;
    8: O = 7'b0000000;
    9: O = 7'b0000100;
    
    
    endcase
    case(EN)
    0:A= 4'b0111;
    1:A= 4'b1011;
    2:A=4'b1101;
    3:A=4'b1110;
    endcase
    end
endmodule
