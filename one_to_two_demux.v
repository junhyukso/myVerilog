`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:12:43 12/04/2019 
// Design Name: 
// Module Name:    one_to_two_demux 
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
module one_to_eight_demux(i_in,i_sel,o_out1,o_out2,o_out3,o_out4,o_out5,o_out6,o_out7,o_out8);

input [15:0] i_in;
input  [2:0] i_sel;
output reg [15:0] o_out1,o_out2,o_out3,o_out4,o_out5,o_out6,o_out7,o_out8;

always @(*) begin
	case(i_sel)
		0 : {o_out1,o_out2,o_out3,o_out4,o_out5,o_out6,o_out7,o_out8} = { i_in	, 16'b0	, 16'b0	, 16'b0 	, 16'b0	, 16'b0	, 16'b0	,	16'b0};
		1 : {o_out1,o_out2,o_out3,o_out4,o_out5,o_out6,o_out7,o_out8} = { 16'b0	, i_in	, 16'b0	, 16'b0 	, 16'b0	, 16'b0	, 16'b0	,	16'b0};
		2 : {o_out1,o_out2,o_out3,o_out4,o_out5,o_out6,o_out7,o_out8} = { 16'b0	, 16'b0	, i_in	, 16'b0 	, 16'b0	, 16'b0	, 16'b0	,	16'b0};
		3 : {o_out1,o_out2,o_out3,o_out4,o_out5,o_out6,o_out7,o_out8} = { 16'b0	, 16'b0	, 16'b0	, i_in  	, 16'b0	, 16'b0	, 16'b0	,	16'b0};
		4 : {o_out1,o_out2,o_out3,o_out4,o_out5,o_out6,o_out7,o_out8} = { 16'b0	, 16'b0	, 16'b0	, 16'b0  , i_in	, 16'b0	, 16'b0	,	16'b0};
		5 : {o_out1,o_out2,o_out3,o_out4,o_out5,o_out6,o_out7,o_out8} = { 16'b0	, 16'b0	, 16'b0	, 16'b0  , 16'b0	, i_in	, 16'b0	,	16'b0};
		6 : {o_out1,o_out2,o_out3,o_out4,o_out5,o_out6,o_out7,o_out8} = { 16'b0	, 16'b0	, 16'b0	, 16'b0  , 16'b0	, 16'b0	, i_in	,	16'b0};
		7 : {o_out1,o_out2,o_out3,o_out4,o_out5,o_out6,o_out7,o_out8} = { 16'b0	, 16'b0	, 16'b0	, 16'b0  , 16'b0	, 16'b0	, 16'b0	,	i_in };
	endcase
end

endmodule
