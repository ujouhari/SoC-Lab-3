`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:44:26 10/14/2013 
// Design Name: 
// Module Name:    Configration 
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
module Configration( clk, rstb, data , bit8, parity_en, odd_n_even , dbits);
	
	input clk,rstb;
	input [7:0] data;
	input bit8;
	input parity_en;
	input odd_n_even;
	
	output [2:0] dbits;
	reg [2:0] dbits;
	
	wire[2:0] select;
	
	assign select = {bit8, parity_en,odd_n_even};
	
	always @ (posedge clk, negedge rstb)
	
	if (!rstb) dbits <= 3'b000;
	
	else case (select)
			3'b000 : dbits <=3'b111;
			
			3'b001 :	dbits <=3'b111;
			
			3'b010 : dbits <= {2'b11,^(data[6:0])};
			
			3'b011 : dbits <= {2'b11 , ~^(data[6:0])};
					
			3'b100 : dbits <= {2'b11, data[7]};
			
			3'b101 : dbits <= {2'b11 , data[7]};
			
			3'b110 : dbits <= {1'b1, ^(data[7:0]) , data[7]};
			
			3'b111 :	dbits <= {1'b1, ~^(data[7:0]) , data[7]};
					
								
			endcase	
				
endmodule
