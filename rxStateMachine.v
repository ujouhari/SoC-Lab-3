`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:50:38 11/23/2013 
// Design Name: 
// Module Name:    rxStateMachine 
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
module rxStateMachine( clk, rstb, rx, HB, FB, PE, OE, Csn, TXready, adrs, shiftingRx, dataOut);

input clk,rstb;
input PE,OE,CSn,Txready,adrs;
input HB ; 
input FB;
input rx;
output shiftingRx;
output dataOut;

reg RXready;
wire read;

//wire parityError;
//reg overflowError;

reg [1:0] presentState, nextState ; //Represents state
reg [3:0] presentBit, nextBit;		//Counts the bit number
reg [7:0] presentData, nextData;		//Register for the data bits
reg [2:0] presentCount, nextCount;	//BTU counter

reg [7:0] temp;
wire [7:0] status;

assign read = (~adrs && OE && ~Csn);

assign dataOut = temp;

assign shifting_rx = presentCount;

assign status[0] = RXready;
assign status[1] = TXready;
assign status[2] = 1'b0;
assign status[3] = 1'b0;
assign status[4] = overflowError;
assign status[5] = parityError;
assign status[6] = 1'b0;
assign status[7] = 1'b0;


parameter [1:0]
	s0 = 2'b00,
	s1 = 2'b01,
	s2 = 2'b10,
	s3 = 2'b11;

always @ (posedge clk, negedge rstb)
if (!rstb) 
begin
presentState <= s0;
presentBit <= 3'b0;
presentData <= 7'b0;
presentCount <= 1'b0;
end

else 		
begin
presentState <= nextState;
presentBit <= nextBit;
presentData <= nextData;
presentCount <= nextCount;
end

always @(*)

case (presentState)

		s0:if (~rx && ~RXready)
			begin
			nextState = s1;
			nextBit = 3'b0;
			nextData = 8'b0;
			nextCount = 1'b1;
			end
		
		s1: if (HB) 
			 begin	
			 nextState = s2;
			 nextBit = 3'b0;
			 end
					
		s2: if (FB)
			 begin
			 nextData = {rx, data[7:1]};
				if (presentBit == 7)
				begin
				nextState = s3;
				nextBit = 3'b0;
				end
				else
				nextBit = presentBit + 1;
			end
			
		s3:
			if (FB)
				begin
					if (presentBit == 1)
					begin
						state_next = s0;
						nextCount = 1'b0;
						done = 1'b1;
					end
					else
					nextBit = presentBit + 1;
				end
	endcase
	
//RXready signal
always @(posedge clk, negedge rstb)
if 		(!rstb) 									RXready <= 1'b0;
else if  ((presentState == s0) && read)	RXready <= 1'b0;
else if  (done)									RXready <= 1'b1;

//
always @ (posedge clk, negedge rstb)
if 		(!rstb)		temp <= 8'b0;
else if 	(adrs)		temp <= status;
else if	(!adrs)		temp <= presentData;

endmodule
