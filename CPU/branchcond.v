module branchcond(
	input [2:0] branch,
	input zero,
	input less,
	output reg pcAsrc,
	output reg pcBsrc
	);

	always @ (*) begin
		case (branch)
			3'b000: begin pcAsrc = 1'b0; pcBsrc = 1'b0; end
			3'b001: begin pcAsrc = 1'b1; pcBsrc = 1'b0; end
			3'b010: begin pcAsrc = 1'b1; pcBsrc = 1'b1; end
			3'b100: begin 
				case (zero)
					1'b0: begin pcAsrc = 1'b0; pcBsrc = 1'b0; end
					1'b1: begin pcAsrc = 1'b1; pcBsrc = 1'b0; end
				endcase
			end
			3'b101: begin
				case (zero)
					1'b0: begin pcAsrc = 1'b1; pcBsrc = 1'b0; end
					1'b1: begin pcAsrc = 1'b0; pcBsrc = 1'b0; end
				endcase
			end
			3'b110: begin
				case (less)
					1'b0: begin pcAsrc = 1'b0; pcBsrc = 1'b0; end
					1'b1: begin pcAsrc = 1'b1; pcBsrc = 1'b0; end
				endcase
			end
			3'b111: begin
				case (less)
					1'b0: begin pcAsrc = 1'b1; pcBsrc = 1'b0; end
					1'b1: begin pcAsrc = 1'b0; pcBsrc = 1'b0; end
				endcase
			end
		endcase
	end
	
endmodule
	