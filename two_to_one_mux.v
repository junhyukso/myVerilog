`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:16:57 12/04/2019 
// Design Name: 
// Module Name:    two_to_one_mux 
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
module eight_to_one_mux(i_input1,i_input2,i_input3,i_input4,i_input5,i_input6,i_input7,i_input8,i_sel,o_output);

input [255:0] i_input1,i_input2,i_input3,i_input4,i_input5,i_input6,i_input7,i_input8;
input  [2:0]  i_sel;
output reg[255:0] o_output;

always @(*) begin
	case(i_sel)
		0 : o_output = i_input1;
		1 : o_output = i_input2;
		2 : o_output = i_input3;
		3 : o_output = i_input4;
		4 : o_output = i_input5;
		5 : o_output = i_input6;
		6 : o_output = i_input7;
		7 : o_output = i_input8;
	endcase
end

endmodule