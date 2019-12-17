`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:28:51 12/04/2019 
// Design Name: 
// Module Name:    simple_text 
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
module world_clock(i_btns,o_line1,o_line2,i_current_time,clk_1kHz);
input	clk_1kHz;
input [15:0] i_btns;
output [127:0] o_line1,o_line2;

input [20:0] i_current_time;

reg [1:0] 	world_select = 2'b00;
reg [55:0]	world_string;
reg [3:0]	world_offset;

wire 			i_ap;
wire [6:0]	i_h,i_m,i_s;

assign i_h		=	i_current_time[20:14];
assign i_m		=	i_current_time[13:7];
assign i_s		=	i_current_time[6:0];

wire			w_ap;
wire [15:0]	w_h,w_m,w_s;
wire [6:0]	w_temp_h;

wire w_down, w_up;
oneshot o1(i_btns[15],clk_1kHz,w_down);
oneshot o2(i_btns[14],clk_1kHz,w_up);

always @ (posedge clk_1kHz) begin
	if			(w_down)	world_select <= world_select +1;
	else if	(w_up)	world_select <= world_select -1;
	else					world_select <= world_select;
end

always @ (*) begin
	case(world_select)
		0: world_string = {`_,`S,`E,`O,`U,`L,`_};
		1: world_string = {`V,`I,`E,`T,`N,`A,`M};
		2: world_string = {`G,`E,`R,`M,`A,`N,`Y};
		3: world_string = {`_,`E,`G,`Y,`P,`T,`_};
	endcase
end

always @ (*) begin
	case(world_select)
		0: world_offset = 0;
		1: world_offset = 2;
		2: world_offset = 8;
		3: world_offset = 7;
	endcase
end 

assign w_temp_h = ( i_h < world_offset ) ? (24 - (world_offset - i_h)) : (i_h - world_offset);
Digit_2_Seperator D1(w_temp_h,w_h);
Digit_2_Seperator D2(i_m,w_m);
Digit_2_Seperator D3(i_s,w_s);


assign o_line1 = {`_,`W,`O,`R,`L,`D,`_,`colon,`_,world_string};
assign o_line2 = {`_,`_,`_,`_,
						`_,`_,`_, 			//AM / PM
						w_h,`colon,w_m,`colon,w_s,`_ 	//HH : WW : SS 
					  };

endmodule
