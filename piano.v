`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:04:19 12/10/2019 
// Design Name: 
// Module Name:    piano 
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

module piano(i_btns,o_line1,o_line2,clk_1MHz,o_piezo);
input	clk_1MHz;
input [15:0] i_btns;
output [127:0] o_line1,o_line2;
output o_piezo;

reg [4:0] note;
reg o_piezo;
wire enable;

reg [10:0] toggle_point,cnt;

wire C3,D3,E3,F3,G3,A3,B3,C4,D4,E4,F4,G4,A4,B4,C5;
wire flat;

reg [23:0] w_note;

assign flat = i_btns[0];
assign enable = i_btns[15] || i_btns[14] || i_btns[13] || i_btns[12] || i_btns[11] || i_btns[10] || i_btns[9] || i_btns[8] || i_btns[7] || i_btns[6] || i_btns[5] || i_btns[4] || i_btns[3] || i_btns[2] || i_btns[1];
oneshot o1(i_btns[15],clk_1MHz,C3);
oneshot o2(i_btns[14],clk_1MHz,D3);
oneshot o3(i_btns[13],clk_1MHz,E3);
oneshot o4(i_btns[12],clk_1MHz,F3);
oneshot o5(i_btns[11],clk_1MHz,G3);
oneshot o6(i_btns[10],clk_1MHz,A3);
oneshot o7(i_btns[9] ,clk_1MHz,B3);
oneshot o8(i_btns[8] ,clk_1MHz,C4);
oneshot o9(i_btns[7],clk_1MHz,D4);
oneshot o10(i_btns[6],clk_1MHz,E4);
oneshot o11(i_btns[5],clk_1MHz,F4);
oneshot o12(i_btns[4],clk_1MHz,G4);
oneshot o13(i_btns[3],clk_1MHz,A4);
oneshot o14(i_btns[2] ,clk_1MHz,B4);
oneshot o15(i_btns[1] ,clk_1MHz,C5);

always @ (posedge clk_1MHz) begin
	if			(C3) note 	<= 	1;
	else if	(D3) note	<= 	3;
	else if	(E3) note	<= 	5;
	else if	(F3) note	<= 	6;
	else if	(G3) note	<= 	8;
	else if	(A3) note	<= 	10;
	else if	(B3) note	<= 	12;
	else if	(C4) note	<= 	13;
	else if	(D4) note	<= 	15;
	else if	(E4) note	<= 	17;
	else if	(F4) note	<= 	18;
	else if	(G4) note	<= 	20;
	else if	(A4) note	<= 	22;
	else if	(B4) note	<= 	24;
	else if	(C5) note	<= 	25;
	else			  note	<=		note;	
end


//Hardcode toggle point of C3 to C4
always @ (*) begin
	case (note-flat)
		0	: toggle_point =	2032;
		1 	: toggle_point = 	1911; //C3
		2	: toggle_point = 	1805;
		3 	: toggle_point = 	1702; //D3
		4	: toggle_point = 	1607;
		5 	: toggle_point = 	1516; //E3
		6 	: toggle_point = 	1431; //F3
		7	: toggle_point = 	1355;
		8 	: toggle_point = 	1275; //G3
		9	: toggle_point = 	1204;
		10 : toggle_point = 	1136; //A3 (440Hz)
		11	: toggle_point = 	1072;
		12 : toggle_point = 	1012; //B3
		13 : toggle_point = 	955;  //C4
		14 : toggle_point = 	901;  
		15 : toggle_point = 	851;  //D4
		16 : toggle_point = 	803;  
		17 : toggle_point = 	758;  //E4	
		18 : toggle_point = 	715;  //F4	
		19 : toggle_point = 	675;  
		20 : toggle_point = 	637;  //G4	
		21 : toggle_point = 	601;  
		22 : toggle_point = 	568;  //A4	
		23 : toggle_point = 	536;  
		24 : toggle_point = 	506;  //B4	
		25 : toggle_point = 	477;  //C5
		default	: toggle_point = 0;
	endcase
end

always @ (posedge clk_1MHz) begin
	if(~enable) begin
		cnt	<=	0;
		o_piezo	<=	0;
	end
	else if(cnt >= toggle_point) begin
		cnt 	<= 0;
		o_piezo <= ~o_piezo;
	end
	else
		cnt <= cnt+1;
end

always @(*) begin
	case(note-flat)
		0	: w_note =	{`B,`_,`n2};
		1 	: w_note = 	{`C,`_,`n3}; //C3
		2	: w_note = 	{`D,`b,`n3};
		3 	: w_note = 	{`D,`_,`n3}; //D3
		4	: w_note = 	{`E,`b,`n3};
		5 	: w_note = 	{`E,`_,`n3}; //E3
		6 	: w_note = 	{`F,`_,`n3}; //F3
		7	: w_note = 	{`G,`b,`n3};
		8 	: w_note = 	{`G,`_,`n3}; //G3
		9	: w_note = 	{`A,`b,`n3};
		10 : w_note = 	{`A,`_,`n3}; //A3 (440Hz)
		11	: w_note = 	{`B,`b,`n3};
		12 : w_note = 	{`B,`_,`n3}; //B3
		13 : w_note = 	{`C,`_,`n4};  //C4
		14 : w_note = 	{`D,`b,`n4};  
		15 : w_note = 	{`D,`_,`n4};  //D4
		16 : w_note = 	{`E,`b,`n4}; 
		17 : w_note = 	{`E,`_,`n4};  //E4	
		18 : w_note = 	{`F,`_,`n4};  //F4	
		19 : w_note = 	{`G,`b,`n4};  
		20 : w_note = 	{`G,`_,`n4};  //G4	
		21 : w_note = 	{`A,`b,`n4};  
		22 : w_note = 	{`A,`_,`n4};  //A4	
		23 : w_note = 	{`B,`b,`n4};  
		24 : w_note = 	{`B,`_,`n4};  //B4	
		25 : w_note = 	{`C,`_,`n5};  //C5
		default	: w_note	=	{`_,`_,`_};
	endcase
end


assign o_line1 = {`_,`_,`P,`I,`A,`N,`O,`_,`_,`_,`_,`_,`_,`_,`_,`_,`_,`_};
assign o_line2 = {`_,`_,`n,`o,`t,`e,`colon,`_,(enable ? w_note : {`_,`_,`_}),`_,`_,`_,`_,`_,`_,`_};

endmodule
