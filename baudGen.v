`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:27:01 11/23/2013 
// Design Name: 
// Module Name:    baudGen 
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
module baudGen (clk, rstb, baud_select,shifting, shifting_rx, shift, HB, FB);

input clk, rstb;
input [3:0] baud_select;
input shifting;
input shifting_rx;
output shift;
output HB, FB;

reg [18:0] counter_tx;
wire [3:0] baud_select;
reg [18:0] clock_bits;
wire shift;
wire [1:0] sel_tx;
wire [1:0] sel_rx;
reg[18:0] counter_rx;
wire HB ;
wire FB ;


assign sel_tx = {shifting,shift};
assign sel_rx = {shifting_rx, FB};

assign shift = (counter_tx == clock_bits);

assign HB = (counter_rx == (clock_bits/2)); //Half Bit
assign FB = (counter_rx == clock_bits); //Full Bit


//Clock bit-time generator using baud select

always @ (*)
begin
	clock_bits = clock_bits;
	
	case (baud_select)

	4'b0000: clock_bits = 166667;
	4'b0001: clock_bits = 41667;
	4'b0010: clock_bits = 20833;
	4'b0011: clock_bits = 10417;
	4'b0100: clock_bits = 5208;
	4'b0101: clock_bits = 2604;
	4'b0110: clock_bits = 1302;
	4'b0111: clock_bits = 868;
	4'b1000: clock_bits = 434;
	4'b1001: clock_bits = 217;
	4'b1010: clock_bits = 109;
	4'b1011: clock_bits = 54;
	default clock_bits = 5208;
	
	endcase

end


// Tx Counter
always @(posedge clk, negedge rstb)

if 		(!rstb) counter_tx <= 18'b0;

else 

begin
	counter_tx <= counter_tx;
	
	case (sel_tx)

		2'b00: counter_tx <= 18'b0 ;
		2'b01: counter_tx <= 18'b0 ;
		2'b10: counter_tx <= counter_tx + 1;
		2'b11: counter_tx <= 18'b0;
		default counter_tx <= counter_tx;
	
	endcase
end


// Rx Counter
always @(posedge clk, negedge rstb)
	
if(!rstb) counter_rx <= 18'b0;
	
else
begin
	counter_rx <= counter_rx;			// default value
			
		case (sel_rx)
			2'b00	:	counter_rx <= 18'b0;
			2'b01	:	counter_rx <= 18'b0;
			2'b10	:	counter_rx <= counter_rx + 1;
			2'b11 :	counter_rx <= 18'b0;
			default counter_rx <= counter_rx;
		endcase
end
		
endmodule

