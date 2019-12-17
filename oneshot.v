`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:23:03 12/04/2019 
// Design Name: 
// Module Name:    oneshot 
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
module oneshot(i_async,i_clk,o_sync);
input i_async,i_clk;
output reg o_sync;
reg a;

always @ (posedge i_clk) begin
	a <= i_async;
	o_sync <= i_async & ~a;
end


endmodule
