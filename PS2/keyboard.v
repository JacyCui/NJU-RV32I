module keyboard(
	input clk,
	input clrn,
	input ps2_clk,
	input ps2_data,
	output reg [7:0] cur_key = 0,
	output reg shift = 0,
	output reg ctrl = 0,
	output reg capslock = 0
	);

	wire [7:0] keydata;
	wire ready;
	reg nextdata_n = 1;
	reg up = 1, is_new = 1;
	wire overflow;

	ps2_keyboard mykey(clk, clrn, ps2_clk, ps2_data, keydata, ready, nextdata_n, overflow);

	always @ (posedge clk) begin
		if (!clrn) begin
			cur_key <= 0;
		end
		else begin
			if (ready && nextdata_n) begin
					if (keydata == 8'hf0) begin
						cur_key <= 0;
						up <= 0;
					end
					else begin
						if (up) begin
							if (keydata == 8'h12 || keydata == 8'h59) begin
								shift <= 1;
								cur_key <= 0;
							end
							else if (keydata == 8'h14) begin
								ctrl <= 1;
								cur_key <= 0;
							end
							else if (keydata == 8'h58) begin
								capslock <= ~capslock;
								cur_key <= 0;
							end
							else begin
								cur_key <= keydata;
							end
						end
						else begin
							cur_key <= 0;
							if (keydata == 8'h12 || keydata == 8'h59) begin
								shift <= 0;
							end
							if (keydata == 8'h14) begin
								ctrl <= 0;
							end
							up <= 1;
						end
					end
				nextdata_n <= 0;
			end
			else begin
				nextdata_n <= 1;
			end
			  
		 end    
	end
endmodule
