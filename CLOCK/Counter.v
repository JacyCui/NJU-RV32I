module Counter(
    input clk,
    input en,
    input rst,
	 input [3:0] cin,
    input [3:0] cnt_limit,
    output reg[3:0] Q = 0,
    output reg rco = 0
    );
	 

	 always @ (posedge clk or negedge rst) begin
	     if (!rst) begin
		      Q <= cin;
		  end
		  else begin
			  if (en) begin
					if (Q == cnt_limit - 1) begin
						 Q <= 0;
						 rco <= 1;
					end
					else begin
						 Q <= Q + 1;
						 rco <= 0;
					end
			  end
		  end
	 end
	 

endmodule
	 