module regfile (
	input  [4:0]  ra,
	input  [4:0]  rb,
	input  [4:0]  rw,
	input  [31:0] wrdata,
	input  regwr,
	input  wrclk,
	output [31:0] outa,
	output [31:0] outb
);
	
	reg [31:0] regs[31:0];
	
	integer i;
	initial begin
		for (i = 0; i <= 31; i = i + 1) begin
			regs[i] = 32'd0;
		end
	end
	
	assign outa = regs[ra];
	assign outb = regs[rb];

	always @ (posedge wrclk) begin
		if (regwr && rw) begin
			regs[rw] <= wrdata;
		end
	end
	
endmodule
