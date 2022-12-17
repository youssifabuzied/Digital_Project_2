`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/09/2022 06:25:01 PM
// Design Name: 
// Module Name: Alarm
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


module Alarm( clk, rst, enmin, enhours,  UpDown,min0, min1, hours0, hours1  );
input clk, rst, enmin, enhours,UpDown;
output[3:0]hours0, min0;
output[2:0]hours1, min1;
reg rstman;
reg prerst;
wire clkout;
wire en1, en2;

assign en1 = (enmin&&(min0==9&&~UpDown||min0==0&&UpDown)) ? 1:0;  //enable of min1
assign en2 = ((enhours&&(hours0==9&&~UpDown||hours0==0&&UpDown)))? 1:0;  //enable of hours1
// clock divider for the alarm time displayed
clockDivider ck(clk, rst, clkout);

// The idea of how the alarm minutes's units enables the alarm minutes's tens and this is applied for the hours also
// But, the minutes is not enabling the hours because here we enter the alarm mode when we are at the adjusting mode so we want to adjust the hours  
// seperated form the minutes   
bin_counter_nbits #(4,  10)s2(clkout,0, rst,enmin, UpDown, min0 );
bin_counter_nbits #(3,  6)s3(clkout,0, rst,en1, UpDown, min1 );
bin_counter_nbits #(4,  10,4)s4(clkout,prerst, rstman||rst,(enhours), UpDown, hours0 );
bin_counter_nbits #(3,  6,3)s5(clkout,prerst, rstman||rst,(en2), UpDown, hours1 );
always @ * begin 
if(hours0== 4 && hours1 == 2&&~UpDown) rstman = 1;  //This when we are adding hours in the adjust mode and it reaches 24, we reset to 0
else rstman = 0;
if(hours0== 9 && hours1 == 5) prerst = 1;  //When hours = 00 and we minus 1, we make hours = 23(values of z-1)
else prerst = 0;
end
 
endmodule
