`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/17/2022 03:54:36 AM
// Design Name: 
// Module Name: edge_counter
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

module edge_counter(input clk, rst, output reg[1:0] count);

	always@(posedge clk, posedge rst) begin
		if(rst) count<=0;
		else count<=1;
		
	end

endmodule
    
