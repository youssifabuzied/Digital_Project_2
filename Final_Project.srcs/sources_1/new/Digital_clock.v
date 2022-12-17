`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/09/2022 01:48:48 AM
// Design Name: 
// Module Name: Digital_clock
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
//en means clock
module Digital_Clock( clk, rst, en,enmin, enhours,UpDown, outsec0, outsec1, outmin0, outmin1, outhours0, outhours1);
 input enmin,enhours,clk, rst, en, UpDown;
 wire clkout;
 clockDivider c(clk, rst, clkout);
 reg rstman, rstmanh, prerst;
 output [3:0]outsec0, outmin0,outhours0;
 output [2:0]outsec1, outmin1, outhours1;

 //wire [3:0]outmin0;wire [2:0]outmin1;wire [3:0]outhours0;wire [1:0]outhours1;
 wire res = (UpDown && ~en)?1:0;
bin_counter_nbits #(4,  10)s0(clkout,0, rstman||rst,en, 0, outsec0 );
bin_counter_nbits #(3,  6)s1(clkout,0, rstman||rst,en&&outsec0==9, 0, outsec1 );
bin_counter_nbits #(4,  10)s2(clkout,0, rstman||rst,en&&outsec0==9&&outsec1==5||(enmin), res, outmin0 );
bin_counter_nbits #(3,  6)s3(clkout,0, rstman||rst,(en&&outsec0==9&&outsec1==5&&outmin0==9)||(enmin&&(outmin0==9&&~UpDown||outmin0==0&&UpDown)), res, outmin1 );
bin_counter_nbits #(4,  10,4)s4(clkout,prerst, rstman||rstmanh||rst, en&&outsec0==9&&outsec1==5&&outmin0==9&&outmin1==5||(enhours), res, outhours0 );
bin_counter_nbits #(3,  6,3)s5(clkout,prerst, rstman||rstmanh||rst,en&&outsec0==9&&outsec1==5&&outmin0==9&&outmin1==5&&outhours0==9||((enhours&&(outhours0==9&&~UpDown||outhours0==0&&UpDown))), res, outhours1 );
always @ * begin 
if(outhours0== 4 && outhours1 == 2&&~UpDown) rstmanh = 1;
else rstmanh = 0;
if(outhours0== 4 && outhours1 == 2&&outmin0==0&&outmin1==0&&~UpDown) rstman =1;
else rstman = 0;
if(outhours0== 9 && outhours1 == 5&&~en) prerst = 1;
else prerst = 0;
end
/*
 wire nclk;
 reg  [3:0]segin;
 clockDivider#(250000) ck(clk,rst,nclk);
  wire [1:0]count;
 bin_counter_nbits #(2,  4)s6(nclk,0, rst,1, 0, count );
 always @ * begin
 case (count)
 2'b00: segin = outmin0;
 2'b01: segin = outmin1;
 2'b10: segin = outhours0;
 2'b11: segin = outhours1;
 
 endcase
 
 end 
BCD7SEG seg(segin, count, O, A);
*/
endmodule
