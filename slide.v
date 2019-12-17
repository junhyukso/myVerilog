module LCD(i_line1,i_line2,rst,clk,LCD_E,LCD_RS, LCD_RW,LCD_DATA);
input rst, clk;
input [127:0] i_line1;
input [127:0] i_line2;
output LCD_E, LCD_RS, LCD_RW;
output [7:0] LCD_DATA;

wire LCD_E;
reg LCD_RS, LCD_RW;
reg [7:0] LCD_DATA;

reg [2:0] 	STATE ;
parameter 	DELAY = 3'b000,
				FUNCTION_SET = 3'b001,
				ENTRY_MODE = 3'b010,
				DISP_ONOFF = 3'b011,
				LINE1 = 3'b100,
				LINE2 = 3'b101,
				DELAY_T = 3'b110,
				SHIFT = 3'b111;

integer CNT ;
integer CNT_100HZ ;
reg clk_100hz;

always @(negedge rst or posedge clk)
begin
 if(rst == 1'b0)
  begin
  CNT_100HZ = 0;
  clk_100hz = 1'b0;
  end
 else if (CNT_100HZ >= 2)
  begin
  CNT_100HZ = 0;
  clk_100hz = ~clk_100hz;
  end
 else
  CNT_100HZ = CNT_100HZ + 1;
end  

always @(negedge rst or posedge clk_100hz)
begin
 if(rst == 1'b0)
  STATE = DELAY;
 else
  begin
   case(STATE)
    DELAY :
     if (CNT == 70) STATE = FUNCTION_SET;
    FUNCTION_SET :
     if (CNT == 30) STATE = DISP_ONOFF;
    DISP_ONOFF :
     if (CNT == 30) STATE = ENTRY_MODE;
    ENTRY_MODE :
     if (CNT == 30) STATE = LINE1;
    LINE1 :
     if (CNT == 17) STATE = LINE2;
    LINE2 :
     if (CNT == 17) STATE = LINE1;
	  
    default : STATE = DELAY;
   endcase
  end
end 


always @(negedge rst or posedge clk_100hz)
begin
 if(rst == 1'b0)
  CNT = 0;
 else
  begin
   case (STATE)
    DELAY :
     if (CNT >= 70) CNT = 0;
     else CNT = CNT + 1;
    FUNCTION_SET :
     if (CNT >= 30) CNT = 0;
     else CNT = CNT + 1;
    DISP_ONOFF :
     if (CNT >= 30) CNT = 0;
     else CNT = CNT + 1;
    ENTRY_MODE :
     if (CNT >= 30) CNT = 0;
     else CNT = CNT + 1;
    LINE1 :
     if (CNT >= 17) CNT = 0;
     else CNT = CNT + 1;
    LINE2 :
     if (CNT >= 17) CNT = 0;
     else CNT = CNT + 1;
	  
    default : CNT = 0;
   endcase
  end
end

always @(negedge rst or posedge clk_100hz)
begin
 if (rst == 1'b0)
  begin
   LCD_RS = 1'b1;
   LCD_RW = 1'b1;
   LCD_DATA = 8'b00000000;
  end
 else
  begin
   case (STATE)
    FUNCTION_SET :
     begin
      LCD_RS = 1'b0;
      LCD_RW = 1'b0;
      LCD_DATA = 8'b00111100;
     end
    
    DISP_ONOFF :
     begin
      LCD_RS = 1'b0;
      LCD_RW = 1'b0;
      LCD_DATA = 8'b00001100;
     end
	 
    ENTRY_MODE :
     begin
      LCD_RS = 1'b0;
      LCD_RW = 1'b0;
      LCD_DATA = 8'b00000110;
     end
    LINE1 :
     begin
      LCD_RW = 1'b0;
		if(CNT == 0) {LCD_RS,LCD_DATA} = 9'b010000000;
		else begin
			LCD_RS = 1'b1;
			case(CNT)
				1 : LCD_DATA = i_line1[127:120];
				2 : LCD_DATA = i_line1[119:112];
				3 : LCD_DATA = i_line1[111:104];
				4 : LCD_DATA = i_line1[103:96];
				5 : LCD_DATA = i_line1[95:88];
				6 : LCD_DATA = i_line1[87:80];
				7 : LCD_DATA = i_line1[79:72];
				8 : LCD_DATA = i_line1[71:64];
				9 : LCD_DATA = i_line1[63:56];
				10 : LCD_DATA = i_line1[55:48];
				11 : LCD_DATA = i_line1[47:40];
				12 : LCD_DATA = i_line1[39:32];
				13 : LCD_DATA = i_line1[31:24];
				14 : LCD_DATA = i_line1[23:16];
				15 : LCD_DATA = i_line1[15:8];
				16 : LCD_DATA = i_line1[7:0];
				default : LCD_DATA = 0;
			endcase
		end
     end
    LINE2 :
     begin
		LCD_RW = 1'b0;
		if(CNT == 0) {LCD_RS,LCD_DATA} = 9'b011000000;
		else begin
			LCD_RS = 1'b1;
			case(CNT)
				1 : LCD_DATA = i_line2[127:120];
				2 : LCD_DATA = i_line2[119:112];
				3 : LCD_DATA = i_line2[111:104];
				4 : LCD_DATA = i_line2[103:96];
				5 : LCD_DATA = i_line2[95:88];
				6 : LCD_DATA = i_line2[87:80];
				7 : LCD_DATA = i_line2[79:72];
				8 : LCD_DATA = i_line2[71:64];
				9 : LCD_DATA = i_line2[63:56];
				10 : LCD_DATA = i_line2[55:48];
				11 : LCD_DATA = i_line2[47:40];
				12 : LCD_DATA = i_line2[39:32];
				13 : LCD_DATA = i_line2[31:24];
				14 : LCD_DATA = i_line2[23:16];
				15 : LCD_DATA = i_line2[15:8];
				16 : LCD_DATA = i_line2[7:0];
				default : LCD_DATA = 0;
			endcase
		end
     end

    default :
     begin
      LCD_RS = 1'b1;
      LCD_RW = 1'b1;
      LCD_DATA = 8'b00000000;
     end
   endcase
  end
end

assign LCD_E = clk_100hz;  

endmodule
