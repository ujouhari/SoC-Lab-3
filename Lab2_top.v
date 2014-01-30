`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:25:56 10/21/2013 
// Design Name: 
// Module Name:    Lab2_top 
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
///////////////////////////////////////////////////////////////////////////////
module Lab2_top(clk, rst, baud_select, CSn, WE, data_in, bit8, parity_en, odd_n_even, dbits, data_out, txready, txout);

input clk;
input rst;
input [3:0]baud_select;
input bit8;
input parity_en;
input odd_n_even;

output [7:0] data_out;
output [2:0] dbits;
output txready;
output txout;
output CSn;
output WE;
output [7:0] data_in;


aiso aiso(.clk(clk),.rst(rst),.rstbs(rstbs));

Counter_clocks Counter_clocks(.clk(clk), .rstb(rstbs), .baud_select(baud_select) ,.shifting(shifting), .shift(shift));

UART_Transmitter UART_Transmitter(.clk(clk) ,.rstb(rstbs), .CSn(CSn), .WE(WE), .data_in(data_in), .dbits(dbits), .data_out(data_out),.shift(shift), .shifting(shifting), .txready(txready), .txout(txout));

Configration Configration(.clk(clk), .rstb(rstbs), .data(data_out) , .bit8(bit8), .parity_en(parity_en), .odd_n_even(odd_n_even) , .dbits(dbits));

tx_proc tx_proc (.clk(clk), .reset_ns(rstbs), .TXrdy(txready), .CSn(CSn), .WE(WE), .data_in(data_in));


endmodule
