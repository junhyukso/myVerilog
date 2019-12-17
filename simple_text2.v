`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:18:26 12/11/2019 
// Design Name: 
// Module Name:    simple_text2 
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
module simple_text(i_btns,o_line1,o_line2);
input [15:0] i_btns;
output [127:0] o_line1,o_line2;

assign o_line1 = {`_,`_,`_,`n2,`n0,`n1,`n8,`n4,`n4,`n0,`n0,`n7,`n2,`_,`_,`_};
assign o_line2 = {`_,`_,`_,`J,`u,`n,`h,`y,`u,`k,`_,`S,`o,`_,`_,`_};

endmodule
