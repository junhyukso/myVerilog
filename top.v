`timescale 1ns / 1ps

module top(
				clk_1Hz,clk_1kHz,clk_1MHz,resetn,
				i_btns,i_sel,
				o_lcd_rs,o_lcd_rw,o_lcd_e,o_lcd_data,
				o_piezo
			  );
input clk_1Hz,clk_1kHz,clk_1MHz,resetn;
input [15:0] 	i_btns; // BUTTON_SW1
input [2:0]		i_sel;  // BUS_SW[7]

output o_lcd_rs,o_lcd_rw,o_lcd_e;
output [7:0] o_lcd_data;
output o_piezo;

wire [15:0]		M1_inputs,	
					M2_inputs,	
					M3_inputs,	
					M4_inputs,
					M5_inputs,
					M6_inputs,
					M7_inputs,
					M8_inputs;
  
wire [127:0] 	M1_line1, 	M1_line2,	
					M2_line1, 	M2_line2,
					M3_line1, 	M3_line2,
					M4_line1, 	M4_line2,
					M5_line1, 	M5_line2,
					M6_line1, 	M6_line2,
					M7_line1, 	M7_line2,
					M8_line1, 	M8_line2,
					W_line1,		W_line2; 

wire [20:0] w_time_load,w_current_time;
wire	w_load_sig;
one_to_eight_demux d(i_btns,
							i_sel,
							M1_inputs,
							M2_inputs,
							M3_inputs,
							M4_inputs,
							M5_inputs,
							M6_inputs,
							M7_inputs,
							M8_inputs
							);

counter 			M1	(resetn,clk_1kHz,clk_1Hz,M1_inputs,M1_line1,M1_line2,w_time_load,w_load_sig,w_current_time); //pass w_current_time to M3
time_setting 	M2	(M2_inputs,M2_line1,M2_line2,clk_1kHz,w_time_load,w_load_sig,resetn);								//pass w_time_load,w_load_sig to M1 
world_clock 	M3	(M3_inputs,M3_line1,M3_line2,w_current_time,clk_1kHz);
stopwatch		M4 (M4_inputs,M4_line1,M4_line2,clk_1kHz,resetn);
piano				M5 (M5_inputs,M5_line1,M5_line2,clk_1MHz,o_piezo);
simple_text		M6	(M6_inputs,M6_line1,M6_line2);



eight_to_one_mux m({M1_line1,M1_line2},
						{M2_line1,M2_line2},
						{M3_line1,M3_line2},
						{M4_line1,M4_line2},
						{M5_line1,M5_line2},
						{M6_line1,M6_line2},
						{M7_line1,M7_line2},
						{M8_line1,M8_line2},
						i_sel,
						{W_line1,W_line2}
						);

LCD L1(W_line1,W_line2,resetn,clk_1kHz,o_lcd_e,o_lcd_rs,o_lcd_rw,o_lcd_data);

endmodule
