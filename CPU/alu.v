module alu(
	input [31:0] dataa,
	input [31:0] datab,
	input [3:0]  ALUctr,
	output reg less,
	output zero,
	output reg [31:0] aluresult);

	assign zero = ALUctr[2:0] == 3'b010 ? dataa == datab : aluresult == 0;

	always @ (*) begin
		casex (ALUctr) 
			4'b0000: aluresult = dataa + datab;
			4'b1000: aluresult = dataa - datab;
			4'bx001: aluresult = dataa << datab[4:0];
			4'b0010: begin less = $signed(dataa) < $signed(datab); aluresult = {31'd0, less}; end
			4'b1010: begin less = dataa < datab; aluresult = {31'd0, less}; end
			4'bx011: aluresult = datab;
			4'bx100: aluresult = dataa ^ datab;
			4'b0101: aluresult = dataa >> datab[4:0];
			4'b1101: aluresult = $signed(dataa) >>> datab[4:0];
			4'bx110: aluresult = dataa | datab;
			4'bx111: aluresult = dataa & datab;
		endcase
	end

endmodule
