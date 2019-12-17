`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:03:46 12/03/2019 
// Design Name: 
// Module Name:    counter 
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

module counter(resetn,
					clk_1kHz,clk_1hz,
					i_btns,
					o_line1,o_line2,
					i_load_data,
					i_load_sig,
					o_current_time
					);
					
input resetn,clk_1kHz;
input clk_1hz;
input [15:0] i_btns;
input [20:0] i_load_data;
input i_load_sig;
output [127:0] o_line1, o_line2; //LCD output string stream
output[20:0] o_current_time;

reg mode12 = 0;
reg stop = 0;
wire w_mode12;
wire w_stop;

oneshot o1(i_btns[15],clk_1kHz,w_mode12);
oneshot o2(i_btns[14],clk_1kHz,w_stop);
always @(posedge clk_1kHz or negedge resetn) begin
	if(~resetn) begin
		mode12 <= 0;
	end
	else if(w_mode12) begin
		mode12 <= ~mode12;
	end
	else begin
		mode12 <= mode12;
	end
end

always @(posedge clk_1kHz or negedge resetn) begin
	if(~resetn) begin
		stop <= 0;
	end
	else if(w_stop) begin
		stop <= ~stop;
	end
	else begin
		stop <= stop;
	end
end


reg [6:0] hour = 0;
reg [6:0] hour2;
reg ampm;
reg [6:0] minute = 0;
reg [6:0] second = 0;
wire [15:0]w_hour, w_minute, w_second;

always @(posedge clk_1hz or posedge i_load_sig or negedge resetn) begin
	if(~resetn) begin
		{hour,minute,second} <= 0;
	end
	else if(i_load_sig)
		{hour,minute,second} <= i_load_data;
	else begin
		if(second == 59) begin
			second <= 0;
			if(minute == 59) begin
				minute <= 0;
				hour <= hour == 23 ? 0 : hour + 1;
			end
			else minute <= minute + 1;
		end
		else second <= stop ? second : second + 1;
	end
end 

always @(*) begin
	if(hour == 0) begin
		hour2 = 12;
		ampm = 0;
	end
	else if (1 <= hour && hour <= 11) begin
		hour2 = hour;
		ampm = 0;
	end
	else if ( hour == 12) begin
		hour2 = 12;
		ampm = 1;
	end
	else begin
		hour2 = hour - 12;
		ampm = 1;
	end
end

reg [15:0] w_ampm;

always @(*) begin
	if(mode12) begin
		w_ampm = ampm ? {`P,`M} : {`A,`M};
	end
	else
		w_ampm = {`_,`_};
end

Digit_2_Seperator D1(mode12 ? hour2 : hour, w_hour);
Digit_2_Seperator D2(minute,w_minute);
Digit_2_Seperator D3(second,w_second);

assign o_line1 = {`_,`_,`D,`I,`G,`I,`T,`A,`L,`_,`C,`L,`O,`C,`K,`_};
assign o_line2 = {stop ? {`S,`T,`O,`P} : {`_,`_,`_,`_},
						`_,w_ampm,`_, 							//AM / PM
						w_hour,`colon,w_minute,`colon,w_second //HH : WW : SS 
					  };
assign o_current_time = {hour,minute,second};

endmodule
