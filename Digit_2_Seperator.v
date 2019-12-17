`include "CONSTANTS.v"
module Digit_2_Seperator(i_bin,o_out);
input [6:0] i_bin;
output reg[15:0]o_out;

reg [7:0] ten, one;

always @(*)begin

if			(i_bin <= 9)	begin ten = `n0; one = i_bin; 	end
else if	(i_bin <= 19)	begin ten = `n1; one = i_bin-10; end
else if	(i_bin <= 29)	begin ten = `n2; one = i_bin-20; end
else if	(i_bin <= 39)	begin ten = `n3; one = i_bin-30; end
else if	(i_bin <= 49)	begin ten = `n4; one = i_bin-40; end
else if	(i_bin <= 59)	begin ten = `n5; one = i_bin-50; end
else if	(i_bin <= 69)	begin ten = `n6; one = i_bin-60; end
else if	(i_bin <= 79)	begin ten = `n7; one = i_bin-70; end
else if	(i_bin <= 89)	begin ten = `n8; one = i_bin-80; end
else if	(i_bin <= 99)	begin ten = `n9; one = i_bin-90; end
else							begin ten = `n0; one = 0; 			end //error case
		
case (one)
	0 : o_out[7:0] = `n0;
	1 : o_out[7:0] = `n1;
	2 : o_out[7:0] = `n2;
	3 : o_out[7:0] = `n3;
	4 : o_out[7:0] = `n4;
	5 : o_out[7:0] = `n5;
	6 : o_out[7:0] = `n6;
	7 : o_out[7:0] = `n7;
	8 : o_out[7:0] = `n8;
	9 : o_out[7:0] = `n9;
	default : o_out[7:0] = `n0; //error case
endcase

o_out[15:8] = ten;

end

endmodule
