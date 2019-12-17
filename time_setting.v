`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:13:13 12/04/2019 
// Design Name: 
// Module Name:    time_setting 
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
`include "CONSTANTS.v"
module time_setting(i_btns,o_line1,o_line2,clk_1kHz,o_load_data,o_load_sig,resetn);

/////basic io///////////////////////
input 	[15:0] 	i_btns;
output 	[127:0]	o_line1 , o_line2;

////custom io//////////////////////
input 				clk_1kHz,resetn;
output	[20:0] 	o_load_data;
output 				o_load_sig;

//////////////////////////////////////////

reg 			ap;
reg [6:0]	h,m,s;

wire [15:0]w_hour, w_minute, w_second;

//one-shot-triggering
wire up_h, up_m, up_s;

oneshot o2(i_btns[15],clk_1kHz,up_h);
oneshot o3(i_btns[14],clk_1kHz,up_m);
oneshot o4(i_btns[13],clk_1kHz,up_s);



always @(posedge clk_1kHz or negedge resetn)begin
	if			(~resetn) {h,m,s} <= 0; 
	else if	(up_h)	h <= (h == 23) ? 0 : h +1;
	else if	(up_m)	m <= (m == 59) ? 0 : m +1;
	else if	(up_s) 	s <= (s == 59) ? 0 : s +1;
end

Digit_2_Seperator D1(h,w_hour);
Digit_2_Seperator D2(m,w_minute);
Digit_2_Seperator D3(s,w_second);

assign o_line1 = {`_,`_,`_,`_,`T,`i,`m,`e,`_,`s,`e,`t,`_,`_,`_,`_};

assign o_line2 = {`_,`_,`_,`_,
						`_,`_,`_, 			
						w_hour,`colon,w_minute,`colon,w_second,`_ //HH : WW : SS 
					  };
					  
assign o_load_data  	= {h,m,s};
assign o_load_sig		= i_btns[0] ? 1 : 0;

endmodule
