`timescale 1ns/1ns

/***************************************************
 File: ECHO.v
 Test Environment UART for CoreUART and ECHO
 John Tramel CECS460A CSULB
 September 20, 2008
 Redesigned 10/22/2012 for status/data registers

****************************************************/

module echo(clk, reset_ns, data_out, adrs,
            data_in, WE, OE, CSn);

// system inputs

input         clk;           // 50 MHz input clock
input         reset_ns;      // low active reset
input  [ 7:0] data_out;      // data received on rx

output [ 7:0] data_in;       // data to send out tx
output        WE;            // low active write enable
output        OE;            // low active output enable
output        CSn;           // low active chip select
output        adrs;          // 1: status, 0: data

//
// declare variables
//

reg     [7:0] data_in;       // data to send out tx
wire          WE;            // high active write enable
wire          OE;            // high active output enable
wire          CSn;           // low active chip select
reg     [3:0] state;         // state machine
integer       count_err;     // count overflows
reg     [7:0] data;
reg     [7:0] status;
wire          load_status;
wire          load_data;
wire          parity_err;
wire          overflow;
wire          TXrdy;
wire          RXrdy;

//
// service the UART interface
//

assign load_status = adrs  && !CSn && OE;
assign load_data   = !adrs && !CSn && OE;
assign parity_err  = status[5];
assign overflow    = status[4];
assign TXrdy       = status[1];
assign RXrdy       = status[0];

  always @(posedge clk or negedge reset_ns)
        if (reset_ns == 1'b0)
           begin
           status  <= 8'b0;
			  data    <= 8'b0;
			  data_in <= 8'b0;
			  end
			else
			  begin
			  status  <= (load_status) ? data_out : status;
			  data    <= (load_data) ? data_out : data;
			  data_in <= data;
			  end		  
			  
	reg    [3:0] ctl;
	assign {adrs,CSn,OE,WE} = ctl;
			  
   always @(posedge clk or negedge reset_ns)
        if (reset_ns == 1'b0)
           begin
           state <= 4'h0;
			  ctl   <= 4'b0100;
			  end
        else
	       case (state)
		     4'h0: {state,ctl} <= {4'h1,4'b1100}; //CSn-status
			  4'h1: {state,ctl} <= {4'h2,4'b1010}; //CSn,adrs,OE
			  4'h2: {state,ctl} <= {4'h3,4'b1100}; //off
			  4'h3: {state,ctl} <= (RXrdy) ? {4'h4,4'b0100} : {4'h0,4'b1100};
			  4'h4: {state,ctl} <= {4'h5,4'b0100}; //CSn-data
			  4'h5: {state,ctl} <= {4'h6,4'b0010}; //CSn-data,adrs,OE
			  4'h6: {state,ctl} <= {4'h7,4'b0100}; //off
			  4'h7: {state,ctl} <= {4'h8,4'b0100}; //CSn-status
			  4'h8: {state,ctl} <= (TXrdy) ? {4'h9,4'b0100} : {4'h4,4'b1010};
			  4'h9: {state,ctl} <= {4'hA,4'b0001};
			  4'hA: {state,ctl} <= {4'hB,4'b0100};
			  4'hB: {state,ctl} <= {4'h0,4'b1100};
			 
				default: {state,ctl} <= {4'h0,4'b1100};
	        endcase

   //
   // keep track of error conditions
   //

   always @(posedge clk or negedge reset_ns)
	   if (reset_ns == 1'b0)
		   count_err <= 0;
	   else if (overflow == 1'b1)
		   count_err <= count_err + 1;
	   else if (parity_err == 1'b1)
		   count_err <= count_err + 1;

endmodule 