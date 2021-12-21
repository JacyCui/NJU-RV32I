module contrgen(
	input [6:0] op,
	input [2:0] func3,
	input [6:0] func7,
	output reg [2:0] extOp,
	output reg regWr,
	output reg aluAsrc,
	output reg [1:0] aluBsrc,
	output reg [3:0] aluCtr,
	output reg [2:0] branch,
	output reg memToReg,
	output reg memWr,
	output reg [2:0] memOp
);

	always @ (*) begin
		case (op[6:2]) 
			5'b01101: begin
				extOp = 3'b001;
				regWr = 1'b1;
				branch = 3'b000;
				memToReg = 1'b0;
				memWr = 1'b0;
				aluBsrc = 2'b01;
				aluCtr = 4'b0011;
			end
			5'b00101: begin
				extOp = 3'b001;
				regWr = 1'b1;
				branch = 3'b000;
				memToReg = 1'b0;
				memWr = 1'b0;
				aluAsrc = 1'b1;
				aluBsrc = 2'b01;
				aluCtr = 4'b0000;
			end
			5'b00100: begin
				extOp = 3'b000;
				regWr = 1'b1;
				branch = 3'b000;
				memToReg = 1'b0;
				memWr = 1'b0;
				aluAsrc = 1'b0;
				aluBsrc = 2'b01;
				case (func3) 
					3'b000: aluCtr = 4'b0000;
					3'b010: aluCtr = 4'b0010;
					3'b011: aluCtr = 4'b1010;
					3'b100: aluCtr = 4'b0100;
					3'b110: aluCtr = 4'b0110;
					3'b111: aluCtr = 4'b0111;
					3'b001: begin
						case (func7[5])
							1'b0: aluCtr = 4'b0001;
						endcase
					end
					3'b101: begin
						case (func7[5])
							1'b0: aluCtr = 4'b0101;
							1'b1: aluCtr = 4'b1101;
						endcase
					end
				endcase
			end
			5'b01100: begin
				regWr = 1'b1;
				branch = 3'b000;
				memToReg = 1'b0;
				memWr = 1'b0;
				aluAsrc = 1'b0;
				aluBsrc = 2'b00;
				case (func3)
					3'b000: begin
						case (func7[5])
							1'b0: aluCtr = 4'b0000;
							1'b1: aluCtr = 4'b1000;
						endcase
					end
					3'b001: begin
						case (func7[5])
							1'b0: aluCtr = 4'b0001;
						endcase
					end
					3'b010: begin
						case (func7[5])
							1'b0: aluCtr = 4'b0010;
						endcase
					end
					3'b011: begin
						case (func7[5])
							1'b0: aluCtr = 4'b1010;
						endcase
					end
					3'b100: begin
						case (func7[5])
							1'b0: aluCtr = 4'b0100;
						endcase
					end
					3'b101: begin
						case (func7[5])
							1'b0: aluCtr = 4'b0101;
							1'b1: aluCtr = 4'b1101;
						endcase
					end
					3'b110: begin
						case (func7[5])
							1'b0: aluCtr = 4'b0110;
						endcase
					end
					3'b111: begin
						case (func7[5])
							1'b0: aluCtr = 4'b0111;
						endcase
					end
				endcase
			end
			5'b11011: begin
				extOp = 3'b100;
				regWr = 1'b1;
				branch = 3'b001;
				memToReg = 1'b0;
				memWr = 1'b0;
				aluAsrc = 1'b1;
				aluBsrc = 2'b10;
				aluCtr = 4'b0000;
			end
			5'b11001: begin
				extOp = 3'b000;
				regWr = 1'b1;
				branch = 3'b010;
				memToReg = 1'b0;
				memWr = 1'b0;
				aluAsrc = 1'b1;
				aluBsrc = 2'b10;
				case (func3)
					3'b000: aluCtr = 4'b0000;
				endcase
			end
			5'b11000: begin
				extOp = 3'b011;
				regWr = 1'b0;
				memWr = 1'b0;
				aluAsrc = 1'b0;
				aluBsrc = 2'b00;
				case (func3)
					3'b000: begin
						branch = 3'b100;
						aluCtr = 4'b0010;
					end
					3'b001: begin
						branch = 3'b101;
						aluCtr = 4'b0010;
					end
					3'b100: begin
						branch = 3'b110;
						aluCtr = 4'b0010;
					end
					3'b101: begin
						branch = 3'b111;
						aluCtr = 4'b0010;
					end
					3'b110: begin
						branch = 3'b110;
						aluCtr = 4'b1010;
					end
					3'b111: begin
						branch = 3'b111;
						aluCtr = 4'b1010;
					end
				endcase
			end
			5'b00000: begin
				extOp = 3'b000;
				regWr = 1'b1;
				branch = 3'b000;
				memToReg = 1'b1;
				memWr = 1'b0;
				memOp = func3;
				aluAsrc = 1'b0;
				aluBsrc = 2'b01;
				aluCtr = 4'b0000;
			end
			5'b01000: begin
				extOp = 3'b010;
				regWr = 1'b0;
				branch = 3'b000;
				memWr = 1'b1;
				memOp = func3;
				aluAsrc = 1'b0;
				aluBsrc = 2'b01;
				aluCtr = 4'b0000;
			end
		endcase
	end

endmodule
