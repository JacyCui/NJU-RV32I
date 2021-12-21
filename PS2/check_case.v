module check_case(
	input [7:0] raw_ascii,
	input capslock,
	input shift,
	output reg [7:0] asciicode
	);
	
	always @ (*) begin
		if ((shift || capslock) && raw_ascii >= 8'h61 && raw_ascii <= 8'h7a) begin
			asciicode = raw_ascii - 8'h20;
		end
		else if (shift) begin
			case (raw_ascii)
				8'h2c: asciicode = 8'h3c;
				8'h2e: asciicode = 8'h3e;
				8'h2f: asciicode = 8'h3f;
				8'h3b: asciicode = 8'h3a;
				8'h27: asciicode = 8'h22;
				8'h5b: asciicode = 8'h7b;
				8'h5d: asciicode = 8'h7d;
				8'h5c: asciicode = 8'h7c;
				8'h60: asciicode = 8'h7e;
				8'h30: asciicode = 8'h29;
				8'h31: asciicode = 8'h21;
				8'h32: asciicode = 8'h40;
				8'h33: asciicode = 8'h23;
				8'h34: asciicode = 8'h24;
				8'h35: asciicode = 8'h25;
				8'h36: asciicode = 8'h5e;
				8'h37: asciicode = 8'h26;
				8'h38: asciicode = 8'h2a;
				8'h39: asciicode = 8'h28;
				8'h2d: asciicode = 8'h5f;
				8'h3d: asciicode = 8'h2b;
				default: asciicode = raw_ascii;
			endcase
		end
		else begin
			asciicode = raw_ascii;
		end
	end
	
endmodule
