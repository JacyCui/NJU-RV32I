module clk_1s(
    input clk,
	 output reg clk_1s
    );
	 
	 reg[31:0] count_clk = 0;
	 
	 always @(posedge clk) begin
	     if (count_clk == 24999999) begin
		      count_clk <= 0;
				clk_1s <= ~clk_1s;
	     end
		  else
		      count_clk <= count_clk + 1;
	 end
	 
endmodule
