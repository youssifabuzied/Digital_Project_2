`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/09/2022 02:01:38 AM
// Design Name: 
// Module Name: Main
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


module Main(input clk, rst, c, input [1:0]ud, input [1:0] rl, output [0:6] O, output [3:0] A, output reg [3:0] LD, output reg ccc, output reg pin, output speaker);
reg [1:0] stateud, nextstateud;
reg [1:0] statelr, nextstatelr;
reg [1:0]Ld0_state, Ld0_nextstate;
reg clkstate, clknextstate;
wire [3:0] clk_sec0, clk_min0, clk_hours0, alarm_min0, alarm_hours0;
wire [2:0] clk_sec1, clk_min1 , clk_hours1, alarm_min1, alarm_hours1;
wire [1:0] BTNUD, BTNLR;
wire BTNC;
wire clkout;
parameter [1:0] INC = 2'b00, DEC = 2'b01, NC = 2'b10;  // states for the up down btns
parameter [1:0] TH = 2'b00, TM = 2'b01, AH = 2'b10, AM = 2'b11; // states for the right left btns
parameter CK = 0, ADJ = 1; // states for the clk mode
parameter[1:0] LD0_OFF = 2'b00, LD0_ON = 2'b01, LD0_BLINK = 2'b10; // states for the blink mode of the ld0
clockDivider coco(clk, rst, clkout);
Digital_Clock dc(clk, rst, clkstate == CK, statelr == TM && stateud != NC, statelr == TH && stateud != NC, stateud == DEC ,clk_sec0, clk_sec1, clk_min0, clk_min1, clk_hours0, clk_hours1);
Alarm alarm( clk, rst, clkstate == ADJ && statelr == AM && stateud != NC, clkstate == ADJ && statelr == AH && stateud != NC, stateud == DEC, alarm_min0, alarm_min1, alarm_hours0, alarm_hours1);

// push button detectors for all the push btns
PB_detector BTNU (ud[0],rst, clk, BTNUD[0]);
PB_detector BTND (ud[1],rst, clk, BTNUD[1]);
PB_detector BTNL (rl[0],rst, clk, BTNLR[0]);
PB_detector BTNR (rl[1],rst, clk, BTNLR[1]);
PB_detector BTNCC (c,rst, clk, BTNC);

// to exclude the case of working of the comparetor when the 
wire [1:0] edge_count;
edge_counter dg(clkout, rst, edge_count);

wire detect = (clk_min0 == alarm_min0 && clk_min1 == alarm_min1 && clk_hours0 == alarm_hours0 && clk_hours1 == alarm_hours1 && clk_sec0 == 0 && clk_sec1 == 0 && edge_count != 0);
// clock divider for the blinking 
wire blink;
clockDivider #(50000000) cck(clk, rst, blink);
always@* begin
case(Ld0_state)
LD0_OFF:
if(clkstate ==CK && detect) Ld0_nextstate = LD0_BLINK;
else if(clkstate == ADJ) Ld0_nextstate = LD0_ON;
else Ld0_nextstate = LD0_OFF;
LD0_BLINK:
if(clkstate == ADJ) Ld0_nextstate = LD0_ON;
else if (BTNUD[0] == 1 || BTNUD[1] == 1 || BTNLR[0] == 1 || BTNLR[1] == 1) Ld0_nextstate = LD0_OFF;
else Ld0_nextstate = LD0_BLINK;
LD0_ON:
if(clkstate == CK) Ld0_nextstate = LD0_OFF;
else Ld0_nextstate = LD0_ON;
default: Ld0_nextstate = LD0_OFF;

endcase
end
always@(clkstate, BTNC) begin
    case(clkstate)
CK: if(BTNC == 0) clknextstate = CK;
    else clknextstate = ADJ;
ADJ: if(BTNC == 0) clknextstate = ADJ;
    else clknextstate = CK; 
default: clknextstate = CK;    
    endcase 
end

always@(stateud, BTNUD) begin
    
    if(clkstate == ADJ && clknextstate == ADJ)begin
        if(BTNUD == 0) nextstateud = NC;
        else case(stateud)
        
NC: if(BTNUD == 1) nextstateud = INC;
    else nextstateud = DEC;
INC: if(BTNUD == 1) nextstateud = INC;
    else nextstateud = DEC;
DEC: if(BTNUD == 1) nextstateud = INC;
    else nextstateud = DEC;
default: nextstateud = NC;

        endcase  
    end
    else nextstateud = NC;
end

always@(statelr, BTNLR) begin
    
    if(clkstate == ADJ && clknextstate == ADJ)begin
        if(BTNLR == 0) nextstatelr = statelr;
        else case(statelr)
 
TH: if(BTNLR == 2'b01) nextstatelr = TM;
    else nextstatelr = AM;
TM: if(BTNLR == 2'b01) nextstatelr = AH;
    else nextstatelr = TH;
AH: if(BTNLR == 2'b01) nextstatelr = AM;
    else nextstatelr = TM;
AM: if(BTNLR == 2'b01) nextstatelr = TH;
    else nextstatelr = AH;
    
        endcase 
    end
end

always@(posedge clkout, posedge rst)
begin
if(rst)
begin
clkstate<=CK;
statelr<=TH;
stateud<=NC;
Ld0_state <= LD0_OFF;
end
else
begin
clkstate<=clknextstate;
statelr<=nextstatelr;
stateud<=nextstateud;
Ld0_state <= Ld0_nextstate;
end
end

reg is_buzzing;
always @* begin 
if(Ld0_state == LD0_OFF)begin
    ccc = 0;
    is_buzzing = 0;
end
else if (Ld0_state == LD0_ON) begin
    ccc = 1;
    is_buzzing = 0;
end
else begin 
    ccc = blink;
    is_buzzing = 1;
end
end
always @(statelr) begin
if(clkstate == ADJ)
case(statelr)
TH: LD = 4'b1000;
TM: LD = 4'b0100;
AH: LD = 4'b0010;
AM: LD = 4'b0001;
endcase
else LD = 4'b0000;
end

wire nclk;
reg[3:0] segin;
clockDivider#(250000) ck(clk,rst,nclk);
 wire [1:0]count;
 bin_counter_nbits #(2,  4)s6(nclk,0, rst,1, 0, count );
always @(count, statelr, clkstate) begin
 if(clkstate == CK ||statelr == TH || statelr == TM)
 case (count)
 2'b00: segin = clk_hours1;
 2'b01: segin = clk_hours0;
 2'b10: segin = clk_min1;
 2'b11: segin = clk_min0;
 endcase
 else
 case (count)
 2'b00: segin = alarm_hours1;
 2'b01: segin = alarm_hours0;
 2'b10: segin = alarm_min1;
 2'b11: segin = alarm_min0;
 endcase
 
 end 
 // 2nd decimal point 
 always@*  begin 
 if(clkstate == CK)begin 
    if(count == 1) pin = blink;
    else pin = 1;
 
 end
 else pin = 1;
 end
 
Buzzer buzz(clk, is_buzzing, speaker);
 
BCD7SEG seg(segin, count, O, A);
endmodule