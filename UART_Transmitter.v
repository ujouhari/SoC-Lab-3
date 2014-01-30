`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:43:14 10/14/2013 
// Design Name: 
// Module Name:    UART_Transmitter 
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
module UART_Transmitter(clk,rstb, CSn, WE, data_in, dbits, 
data_out,shift, shifting, txready, txout);

input clk;
input rstb;
input CSn;
input WE;
input [7:0] data_in;
input [2:0] dbits;
input shift;
output [7:0] data_out;
output shifting;
output txready;
output txout;

reg txready;
//reg txout;
wire txout;
wire load;
reg shifting;
reg [7:0] data_out;
reg LSR;
reg [11:0] shift_reg;
reg [3:0] countBit;
wire done;
//wire select;

assign load = WE & ~CSn;

//assign select = {shift,done};

assign done = (countBit==12);

assign txout = shift_reg[0];

always @(posedge clk, negedge rstb)
if (!rstb)
shift_reg <= 12'b1;
else if (LSR)
begin
 shift_reg[0] <= 1'b1;
 shift_reg[1] <= 1'b0;
 shift_reg[8:2] <= data_out[6:0];
 shift_reg[11:9] <= dbits [2:0];
 end
 
else if (shift) shift_reg <= {1'b1, shift_reg[11:1]};


//set-reset to create txready signal.
always @(posedge clk, negedge rstb)

if 		(!rstb) txready <= 1'b1;
else if 	(load)  txready <= 1'b0;
else if 	(done)  txready <= 1'b1;

//Load the data in, if load is active.
always@(posedge clk, negedge rstb)

if 		(!rstb) data_out <= 8'b1;
else if 	(load)  data_out <= data_in;

//Load signal delayed by one clock cycle.
always@ (posedge clk, negedge rstb)

if 	(!rstb) LSR <= 1'b0;
else if (load) LSR <= 1'b1;
else 	 LSR <= 1'b0;

//Shifting signal.
always @ (posedge clk, negedge rstb)

if 		(!rstb) shifting <= 1'b0;
//else if	(done)  shifting <= 1'b0;
else if 	(LSR) shifting <= 1'b1;
else if (done) shifting <= 1'b0;


always @(posedge clk, negedge rstb)
	if (!rstb) countBit <= 4'b0;
	else if (load) countBit <= 4'b0;
	else if (shift) countBit <= countBit + 1;
	else if (done) countBit<=4'b0;
	else	countBit <= countBit;



//Shift register
/*always @ (posedge clk, negedge rstb)

if (!rstb) shift_reg<= 12'b0;
else if (LSR) 
begin
shift_reg <= {dbits[2:0],data_out[6:0],1'b0,1'b1};
 if (shift) shift_reg <= {1'b1,shift_reg[11:1]};
 end
*/

//TxOut.
/*
always @(posedge clk, negedge rstb)

if (!rstb) txout <= 1'b0;
else if (!shift) txout <= 1'b0;
else if (!txready) txout <= shift_reg[countBit];
	*/	
endmodule
