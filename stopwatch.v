`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:31:21 12/10/2019 
// Design Name: 
// Module Name:    stopwatch 
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

module stopwatch(i_btns,o_line1,o_line2,clk_1kHz,resetn);
input	clk_1kHz;
input resetn;
input [15:0] i_btns;
output [127:0] o_line1,o_line2;

wire go;
wire stop;
wire rst;

oneshot o1(i_btns[15],clk_1kHz,go);
oneshot o2(i_btns[14],clk_1kHz,stop);
assign rst = i_btns[13];

reg[6:0] min = 0,sec = 0,mils = 0;
reg isGo = 0;
reg [2:0] CNT_100Hz = 0;
reg clk_100Hz = 0;

always @(posedge clk_1kHz or posedge rst) begin
	if(rst)
		{CNT_100Hz,clk_100Hz} <= 0;
	else if(CNT_100Hz >= 4) begin
		clk_100Hz <= ~clk_100Hz;
		CNT_100Hz <= 0;
	end
   else begin
		clk_100Hz <= clk_100Hz;
		CNT_100Hz <= CNT_100Hz + 1;
	end
end

always @(posedge clk_1kHz or posedge rst) begin
	if(rst)
		isGo <= 0;
	else if(go)
		isGo <= 1;
	else if(stop)
		isGo <= 0;
	else
		isGo <= isGo;
end

always @(posedge clk_100Hz or posedge rst) begin
	if(rst)
		{min,sec,mils} <= 0;
	else if(~isGo)
		{min,sec,mils} <= {min,sec,mils};
	else begin
		mils 	<= (mils == 99) ? 0 	: mils + 1;
		if(mils == 99) sec <= (sec == 59) ? 0	: sec + 1;
		if(mils == 99 && sec == 59) min <= (min == 59) ? 0 : min + 1;
	end
end

wire [15:0] w_min,w_sec,w_mils;

Digit_2_Seperator D1(min,w_min);
Digit_2_Seperator D2(sec,w_sec);
Digit_2_Seperator D3(mils,w_mils);



assign o_line1 = { {`S,`T,`O,`P,`W,`A,`T,`C,`H,`_,`colon,`_}, ( isGo ? {`_,`g,`o,`_} : {`s,`t,`o,`p} ) };
assign o_line2 = {`_,`_,`_,`_,w_min,`colon, w_sec,`colon, w_mils,`_,`_,`_,`_};

endmodule
