`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:56:39 10/21/2013 
// Design Name: 
// Module Name:    aiso 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module aiso(clk,rst,rstbs);

input clk;
input rst;
output rstbs;

reg q1,q2;
wire rstbs;

assign rstbs=q2;

always @(posedge clk, posedge rst)

if (rst) {q1,q2} <= 2'b0;
else		{q1,q2} <= {1'b1,q1};


endmodule


