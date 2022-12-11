

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2022 04:53:41 PM
// Design Name: 
// Module Name: repexp2
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


module bin_counter_nbits #(parameter x=3, parameter n= 10, parameter z = n)(clk,prerst, reset,en, UpDown, count );

input clk,reset, UpDown,en,prerst;
output reg [x-1:0] count;


always @(posedge clk, posedge reset, posedge prerst) begin
 if (reset == 1)
 begin
 count <= 0;
 end
else if(prerst == 1)count <= (z)-1;
 else 
 if(en ==1) begin
case (UpDown)
0: 
  if ((count==(n)-1))
  begin
  count <= 0;
  end
else count <= count + 1; 

1: 
 if ((count==0))
  begin
  
    count <= (n)-1;
  end
else 
 count <= count - 1;  
endcase
 end

 end

endmodule
