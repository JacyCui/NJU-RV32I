module Counter60(
    input clk,
	 input en,
	 input rst,
	 input [7:0] cin,
	 output [3:0] ten,
	 output [3:0] one,
	 output rco
	 );
	 
	 wire rco1;
	 
	 Counter c1(clk, en, rst, cin[3:0], 10, one, rco1);
	 Counter c2(rco1, en, rst, cin[7:4], 6, ten, rco);
	 
	 
endmodule
