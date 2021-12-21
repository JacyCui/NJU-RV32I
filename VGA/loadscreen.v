module loadscreen(
	input pclk,
	input rst,
	input [7:0] ascii_code,
	input [9:0] h_addr,
	input [9:0] v_addr,
	output rdclk,
	output [11:0] rdaddr,
	output [23:0] vga_data
);

	reg[11:0] vga_font[4095:0];
	integer i;
	initial begin
		$readmemh("vga_font.txt", vga_font, 0, 4095);
	end
	
	reg [9:0] h_count = 0, v_count = 0;
	reg [9:0] h_raw = 0, v_raw = 0;
	reg [11:0] ascii_addr = 0;
	reg [11:0] header = 0;
	
	wire [9:0] h_offset, v_offset;
	assign h_offset = h_addr - h_raw;
	assign v_offset = v_addr - v_raw;
	
	always @ (posedge pclk or posedge rst) begin
		if (rst) begin
			h_count <= 0;
			v_count <= 0;
			ascii_addr <= 0;
			h_raw <= 0;
			v_raw <= 0;
			header <= 0;
		end
		else begin
			if (h_offset >= 8) begin
				h_raw <= h_raw + 10'd9;
				if (h_count >= 63) begin
					h_count <= 0;
					h_raw <= 0;
					ascii_addr <= header;
				end
				else begin
					h_count <= h_count + 10'd1;
					ascii_addr <= ascii_addr + 10'd1;
				end
			end
			if (v_offset >= 16) begin
				v_raw <= v_raw + 10'd16;
				if (v_count >= 29) begin
					v_count <= 0;
					v_raw <= 0;
					header <= 0;
				end
				else begin
					v_count <= v_count + 10'd1;
					header <= header + 12'd64;
				end
			end
		end
	end
	
	
	assign rdaddr = ascii_addr;
	assign rdclk = pclk;
	
	wire [11:0] font_addr = ascii_code << 4;
	wire white;
	wire[11:0] line;
	assign line = vga_font[font_addr + v_offset];
	assign white = line[h_offset];
	assign vga_data = white ? 24'hffffff : 24'h000000;


endmodule
