`timescale 1ns / 1ps

//en means clock
module Digital_Clock( clk, rst, en,enmin, enhours,UpDown, outsec0, outsec1, outmin0, outmin1, outhours0, outhours1);
 
input enmin,enhours,clk, rst, en, UpDown;
output [3:0]outsec0, outmin0,outhours0;
output [2:0]outsec1, outmin1, outhours1;

wire res = (UpDown && ~en)?1:0;
wire clkout;
wire en1, en2, en3, en4, en5;
reg rstman, rstmanh, prerst;

clockDivider c(clk, rst, clkout);

assign en1 = (en&&outsec0==9) ?1:0;   //enable of sec1
assign en2 = (en&&outsec0==9&&outsec1==5||(enmin))? 1:0;  //enable of min0
assign en3 = (en&&outsec0==9&&outsec1==5&&outmin0==9)||(enmin&&(outmin0==9&&~UpDown||outmin0==0&&UpDown)) ?1:0;  //enable of min1
assign en4 = (en&&outsec0==9&&outsec1==5&&outmin0==9&&outmin1==5||(enhours)) ? 1:0;  //enable of hours0
assign en5 = (en&&outsec0==9&&outsec1==5&&outmin0==9&&outmin1==5&&outhours0==9||((enhours&&(outhours0==9&&~UpDown||outhours0==0&&UpDown)))) ? 1:0;  //enable of hours1

 // here we have en that switches between adjust and diplay mode 
 
 // the idea of the typical clock where the sec enales the minutes, and the minutes enables the hours 
 
 // we have enmin seperated from enhour for the case of the adjust mode where we can adjust the minutes alone and the clocks alone
bin_counter_nbits #(4,  10)s0(clkout,0, rstman||rst,en, 0, outsec0 );
bin_counter_nbits #(3,  6)s1(clkout,0, rstman||rst,en1, 0, outsec1 );
bin_counter_nbits #(4,  10)s2(clkout,0, rstman||rst,en2, res, outmin0 );
bin_counter_nbits #(3,  6)s3(clkout,0, rstman||rst,en3, res, outmin1 );
bin_counter_nbits #(4,  10,4)s4(clkout,prerst, rstman||rstmanh||rst, en4, res, outhours0 );
bin_counter_nbits #(3,  6,3)s5(clkout,prerst, rstman||rstmanh||rst,en5, res, outhours1 );

always @ * begin 
if(outhours0== 4 && outhours1 == 2&&~UpDown) rstmanh = 1; //This when we are adding hours in the adjust mode and it reaches 24, we reset to 0
else rstmanh = 0;
if(outhours0== 4 && outhours1 == 2&&outmin0==0&&outmin1==0&&~UpDown) rstman =1;  //This when it reaches 24:00 in the clock mode, we reset all to 0
else rstman = 0;
if(outhours0== 9 && outhours1 == 5&&~en) prerst = 1;   //When we are in the adjust mode, hours = 00 and we minus 1, we make hours = 23(values of z-1)
else prerst = 0;
end

endmodule
