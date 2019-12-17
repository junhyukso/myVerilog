module piezoController(clk_1MHz,enable,note,out); 
input clk_1MHz, enable;
input [2:0] note;
output reg out;

reg [10:0] toggle_point,cnt;

//Hardcode toggle point of C3 to C4
always @ (*) begin
	case (note)
		0 : toggle_point = 1911; //C3
		1 : toggle_point = 1702; //D3
		2 : toggle_point = 1516; //E3
		3 : toggle_point = 1431; //F3
		4 : toggle_point = 1275; //G3
		5 : toggle_point = 1136; //A3 (440Hz)
		6 : toggle_point = 1012; //B3
		7 : toggle_point = 955;  //C4
	endcase
end


always @ (posedge clk_1MHz) begin
	if(~enable) begin
		cnt<=0;
		out<=0;
	end
	else if(cnt >= toggle_point) begin
		cnt <= 0;
		out <= ~out;
	end
	else
		cnt <= cnt+1;
end


endmodule