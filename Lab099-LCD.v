`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:58:16 11/09/2019 
// Design Name: 
// Module Name:    prelab 
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
module prelab	(	
		RESETN, CLK_1kHz, 
		LCD_E, LCD_RS, LCD_RW, LCD_DATA
	);
	
input 			RESETN, CLK_1kHz;
output 			LCD_E;
output reg		LCD_RS,LCD_RW;
output reg[7:0]LCD_DATA;

reg [2:0]		STATE;
parameter		DELAY				=	3'b000,
					FUNCTION_SET	=	3'b001,
					ENTRY_MODE		=	3'b010,
					DISP_ONOFF		=	3'b011,
					LINE1				=	3'b100,
					LINE2				=	3'b101,
					DELAY_T			=	3'b110,
					CLEAR_DISP		=	3'b111;
					
///////////////////////////////////////////
/////  1000Hz to 125Hz(~1ms) divider //////
	
reg [2:0] 	CNT_100Hz;
reg			CLK_100Hz;

always @ (negedge RESETN or posedge CLK_1kHz) begin
	if(~RESETN)
		{CNT_100Hz,CLK_100Hz} <= {3'b000,1'b0};
	else if (CNT_100Hz  >= 4)
		{CNT_100Hz,CLK_100Hz} <= {3'b000,~CLK_100Hz};
	else
		CNT_100Hz <= CNT_100Hz + 1;
end



//////////////////////////////////////////////
//// main Logic //////////////////////////////

integer	CNT;

//logic flow
always @ (negedge RESETN or posedge CLK_100Hz) begin
	if(~RESETN)
		STATE <= DELAY;
	else begin
		case (STATE)
			DELAY 			:	if (CNT == 70) 	STATE <= FUNCTION_SET; //wait 70ms, go to next state( function set)
			FUNCTION_SET 	:	if (CNT == 30) 	STATE <= DISP_ONOFF;
			DISP_ONOFF 		:	if (CNT == 30) 	STATE <= ENTRY_MODE;
			ENTRY_MODE 		:	if (CNT == 30) 	STATE <= LINE1;
			LINE1 			:	if (CNT == 20) 	STATE <= LINE2;
			LINE2 			:	if (CNT == 20) 	STATE <= DELAY_T;
			DELAY_T 			:	if (CNT == 400) 	STATE <= CLEAR_DISP;
			CLEAR_DISP 		:	if (CNT == 200) 	STATE <= LINE1;
			default			:	STATE <= DELAY;
		endcase
	end
end

//time count
always @ (negedge RESETN or posedge CLK_100Hz) begin
	if(~RESETN)
		CNT <= 0;
	else begin
		case(STATE)
			DELAY				:	CNT <= (CNT >= 70)  ?  0 : CNT + 1;
			FUNCTION_SET	:	CNT <= (CNT >= 30)  ?  0 : CNT + 1;
			DISP_ONOFF		:	CNT <= (CNT >= 30)  ?  0 : CNT + 1;
			ENTRY_MODE		:	CNT <= (CNT >= 30)  ?  0 : CNT + 1;
			LINE1				:	CNT <= (CNT >= 20)  ?  0 : CNT + 1;
			LINE2				:	CNT <= (CNT >= 20)  ?  0 : CNT + 1;
			DELAY_T			:	CNT <= (CNT >= 400) ?  0 : CNT + 1;
			CLEAR_DISP		:	CNT <= (CNT >= 200) ?  0 : CNT + 1;
			default			:	CNT <= 0;
		endcase
	end
end



///////////////////////////////////////////////////////
///// LCD control ////////////////////////////////////

always @ (negedge RESETN or posedge CLK_100Hz) begin
	if(~RESETN)
		{LCD_RS,LCD_RW,LCD_DATA} <= 10'b1100000000; //READ DATA
	else begin
		case (STATE)
			FUNCTION_SET 	: {LCD_RS,LCD_RW,LCD_DATA} <= {5'b00001	 , 5'b11100}; 	//8bit, 2Line display
			DISP_ONOFF 		: {LCD_RS,LCD_RW,LCD_DATA} <= {7'b0000001	 , 3'b100}; 	//Display ON, Cursor OFF, Cursor blink OFF
			ENTRY_MODE 		: {LCD_RS,LCD_RW,LCD_DATA} <= {8'b00000001 , 2'b10}; 		//Increment, Cursor shift
			DELAY_T 			: {LCD_RS,LCD_RW,LCD_DATA} <= {9'b000000001, 1'b0}; 		//cursor At home
			CLEAR_DISP 		: {LCD_RS,LCD_RW,LCD_DATA} <= 10'b0000000001; 				//clear 
			
			LINE1				: begin
				if (CNT == 0)
					{LCD_RS,LCD_RW,LCD_DATA} <= {3'b001	 , 7'h00}; //DD Ram Address SET ( 00 )
				else begin
					{LCD_RS,LCD_RW} <= 2'b10; //Write Data
					case (CNT)
						1			:	LCD_DATA <= 8'b01010101;
						2			: 	LCD_DATA	<= 8'b01011111;
						default 	:	LCD_DATA <= 8'b00100000;
					endcase
				end
			end
			
			LINE2				: begin
				if (CNT == 0)
					{LCD_RS,LCD_RW,LCD_DATA} <= {3'b001	 , 7'h40}; //DD Ram Address SET ( 40 )
				else begin
					{LCD_RS,LCD_RW} <= 2'b10; //Write Data
					case (CNT)
						1			:	LCD_DATA <= 8'b01010101;
						2			: 	LCD_DATA	<= 8'b01011111;
						default 	:	LCD_DATA <= 8'b00100000;
					endcase
				end
			end
			
			default 			: {LCD_RS,LCD_RW,LCD_DATA} <= 10'b1100000000; //READ DATA
			
		endcase
	end
end

assign LCD_E = CLK_100Hz;




endmodule
