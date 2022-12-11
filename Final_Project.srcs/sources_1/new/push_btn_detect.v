`timescale 1ns / 1ps

module PB_detector(input x,rst, clk, output y);
wire nclk;
clockDivider cd(clk,rst,nclk);
wire s1,s2;
debouncer deb(nclk, rst, x,s1 );
Synchronizer S(nclk,rst, s1,s2 );
Rising_edge_detector sq(nclk, rst, s2, y);
endmodule
