module rv32is(
	input 	clock, //CPU时钟，下降沿有效
	input 	reset, //reset信号，高电平有效
	input  [31:0] imemdataout, //指令存储器提供的32位指令数据
	input  [31:0] dmemdataout, //数据存储器提供的32位读取数据
	
	output [31:0] imemaddr, //32位指令地址
	output 	imemclk, //指令读取时钟，上升沿读取，如果要在时钟下降沿读取指令，请将时钟取反后提供给imemclk
	
	output [31:0] dmemaddr, //32位数据地址
	output [31:0] dmemdatain, //32位写入数据内容
	
	output 	dmemrdclk, //数据存储器的读取时钟，上升沿有效
	output	dmemwrclk, //数据存储器的写入时钟，上升沿有效，如果要在CPU时钟的下降沿写入，请将CPU时钟取反后输出到本信号上
	
	output [2:0] dmemop, //数据存储器的读写方式，按讲义设置
	output	dmemwe, //数据存储器写使能，高电平有效
	output [31:0] dbgdata //32位测试数据，本实验中请将PC连接到此信号上
	);
	
	// clocks
	assign imemclk = ~clock;
	assign dmemrdclk = clock;
	assign dmemwrclk = ~clock;
	wire regwrclk;
	assign regwrclk = ~clock;
	
	// instruction decode
	wire [31:0] instr;
	assign instr = imemdataout;
	
	wire [4:0] ra, rb, rw;
	wire [6:0] op;
	wire [2:0] func3;
	wire [6:0] func7;
	
	assign op = instr[6:0];
	assign ra = instr[19:15];
	assign rb = instr[24:20];
	assign rw = instr[11:7];
	assign func3 = instr[14:12];
	assign func7 = instr[31:25];
	
	// control signal genetation
	wire [2:0] extOp, memOp, branch;
	wire regWr, memToReg, memWr, aluAsrc;
	wire [1:0] aluBsrc;
	wire [3:0] aluCtr;
	
	contrgen myctr(op, func3, func7, extOp, regWr, aluAsrc, aluBsrc, aluCtr, branch, memToReg, memWr, memOp);
	
	// regfile
	wire [31:0] busW, busA, busB;
	regfile myregfile(ra, rb, rw, busW, regWr, regwrclk, busA, busB);
	
	// immediate number generation
	wire [31:0] imm;
	immgen myimm(extOp, instr, imm);
	
	//program counter
	reg [31:0] pc = 0;
	assign dbgdata = pc;
	
	// alu
	reg [31:0] dataA, dataB;
	wire [31:0] result;
	wire less, zero;
	always @ (*) begin
		case (aluAsrc)
			1'b0: dataA = busA;
			1'b1: dataA = pc;
		endcase
		case (aluBsrc)
			2'b00: dataB = busB;
			2'b01: dataB = imm;
			2'b10: dataB = 32'd4;
		endcase
	end
	alu myalu(dataA, dataB, aluCtr, less, zero, result);
	
	// branch
	wire pcAsrc, pcBsrc;
	branchcond mybranch(branch, zero, less, pcAsrc, pcBsrc);
	
	// pc
	wire [31:0] pcA, pcB;
	wire [31:0] nextpc;
	assign pcA = pcAsrc ? imm : 32'd4;
	assign pcB = pcBsrc ? busA : pc;
	assign nextpc = reset ? 32'd0 : pcA + pcB;
	assign imemaddr = nextpc;
	
	always @ (negedge clock) begin
		if (reset) begin
			pc <= 32'd0;
		end
		else begin
			pc <= nextpc;
		end
	end
	
	// mem
	assign dmemop = memOp;
	assign dmemwe = memWr;
	assign dmemaddr = result;
	assign dmemdatain = busB;
	assign busW = memToReg ? dmemdataout : result;

endmodule

