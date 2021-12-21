module immgen(
	input [2:0] extOp,
	input [31:0] instr,
	output reg [31:0] imm
	);
	
	wire[31:0] immI, immU, immS, immB, immJ;
	
	assign immI = {{20{instr[31]}}, instr[31:20]};
	assign immU = {instr[31:12], 12'b0};
	assign immS = {{20{instr[31]}}, instr[31:25], instr[11:7]};
	assign immB = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
	assign immJ = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};

	always @ (*) begin
		case (extOp)
			3'b000: imm = immI;
			3'b001: imm = immU;
			3'b010: imm = immS;
			3'b011: imm = immB;
			3'b100: imm = immJ;
		endcase
	end
	
endmodule
	