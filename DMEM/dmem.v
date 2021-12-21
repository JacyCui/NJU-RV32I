module dmem(
	input  [31:0] addr,
	output reg [31:0] dataout,
	input  [31:0] datain,
	input  rdclk,
	input  wrclk,
	input [2:0] memop,
	input we);
	
	
	reg [3:0] byteen;
	reg [31:0] temp;
	wire [31:0] cur;
	
	ram2pben mem(
		.byteena_a(byteen), 
		.data(temp),
		.rdaddress(addr[16:2]),
		.rdclock(rdclk),
		.wraddress(addr[16:2]),
		.wrclock(wrclk),
		.wren(we), 
		.q(cur)
	);
	
	always @ (*)
		case (memop)
			3'b000: 
				case (addr[1:0]) 
					2'b00: dataout = {{24{cur[7]}}, cur[7:0]};
					2'b01: dataout = {{24{cur[15]}}, cur[15:8]};
					2'b10: dataout = {{24{cur[23]}}, cur[23:16]};
					2'b11: dataout = {{24{cur[31]}}, cur[31:24]};
				endcase
			3'b001:
				case (addr[1:0]) 
					2'b00, 2'b01: dataout = {{16{cur[15]}}, cur[15:0]};
					2'b10, 2'b11: dataout = {{16{cur[31]}}, cur[31:16]};
				endcase
			3'b010: 
				dataout = cur;
			3'b100:
				case (addr[1:0]) 
					2'b00: dataout = {24'b0, cur[7:0]};
					2'b01: dataout = {24'b0, cur[15:8]};
					2'b10: dataout = {24'b0, cur[23:16]};
					2'b11: dataout = {24'b0, cur[31:24]};
				endcase
			3'b101:
				case (addr[1:0]) 
					2'b00, 2'b01: dataout = {16'b0, cur[15:0]};
					2'b10, 2'b11: dataout = {16'b0, cur[31:16]};
				endcase
		endcase

	always @ (*) 
		if (we)
			case (memop)
				3'b000: 
					case (addr[1:0])
						2'b00: begin byteen = 4'b0001; temp = {24'd0, datain[7:0]}; end
						2'b01: begin byteen = 4'b0010; temp = {16'd0, datain[7:0], 8'd0}; end
						2'b10: begin byteen = 4'b0100; temp = {8'd0, datain[7:0], 16'd0}; end
						2'b11: begin byteen = 4'b1000; temp = {datain[7:0], 24'd0}; end
					endcase
				3'b001:
					case (addr[1:0])
						2'b00, 2'b01: begin byteen = 4'b0011; temp = {16'd0, datain[15:0]}; end
						2'b10, 2'b11: begin byteen = 4'b1100; temp = {datain[15:0], 16'd0}; end
					endcase
				3'b010: begin byteen = 4'b1111; temp = datain; end
			endcase

endmodule
