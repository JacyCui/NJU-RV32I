module clock(
    input en,
	 input clk,
	 input rst,
	 input [23:0] cin,
	 output [3:0] hour_t,
	 output [3:0] hour_o,
	 output [3:0] min_t,
	 output [3:0] min_o,
	 output [3:0] sec_t,
	 output [3:0] sec_o,
	 output rco
    );
	 
    wire rco1, rco2;
	 
	 Counter60 second(clk, en, rst, cin[7:0], sec_t, sec_o, rco1);
	 Counter60 minute(rco1, en, rst, cin[15:8], min_t, min_o, rco2);
	 Counter60 hour(rco2, en, rst, cin[23:16], hour_t, hour_o, rco);
	 
endmodule
