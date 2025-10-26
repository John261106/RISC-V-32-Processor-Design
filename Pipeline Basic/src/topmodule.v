module TopModule(
input CLK,
input RST
);
//VERY IMPORTANT NOTE : we want 5th bit of funct7 for the present design
//
// Clock and Reset
wire CLK;
wire RST;         // active low reset synchronous

// Program Counter logic
wire [31:0] PC, PCNext, PCPlus4, PCTarget;
wire PCSrc;

// Register File
wire WE3;         // write enable for regfile
wire [4:0]  A1, A2, A3;  // register addresses
wire [31:0] WD3, RD1, RD2;

// Immediate Generator
wire [24:0] Imm;
wire [1:0] ImmSrc;
wire [31:0] ImmExt;

// ALU
wire [31:0] SrcA, SrcB, ALUResult;
wire [2:0] ALUControl;
wire Zero;

// Control Unit
wire [6:0] op;
wire [2:0] funct3;
wire funct7; //we are considering only one bit of funct7, for the basic instruction set we planned to implement that is enough for now
wire RegWrite, ALUSrc, MemWrite, Branch;
wire [1:0] ResultSrc;
wire [1:0] ALUOp;


// Data Memory
wire WE;          // memory write enable
wire [31:0] A, WD, RD;


//ALU
ALU ALU1(
.SrcA(SrcA),
.SrcB(SrcB),
.ALUControl(ALUControl),
.ALUResult(ALUResult),
.Zero(Zero)
);

//ALUDecoder 
ALUDecoder ALUDecoder1(
.funct3(RD[14:12]), //this is for only R,I,S,B instructions, funct3 not defined for U,J type
.funct7(RD[31:25]), //this is for R type
.op(RD[6:0]),
.ALUOp(ALUOp),
.ALUControl(ALUControl)
);

//BranchJump
BranchJump BranchJump1(
.Branch(Branch),
.Zero(Zero),
.PCSrc(PCSrc)
);

//DataMemory
DataMemory DataMemory1(
.CLK(CLK),
.WE(WE),
.A(A),
.WD(WD),
.RST(RST),
.RD1(RD1)
);

//Extend
Extend Extend1(
.Imm(Imm),
.ImmSrc(ImmSrc),
.ImmExt(ImmExt)
);

//instruction memory
InstructionMemory InstructionMemory1(
.A(A),
.RD(RD)
);


//whenever it is R, I, S, B funct3 is RD[14:12]

//MainDecoder *A BIT INVOLVED -- check carefullu*
MainDecoder MainDecoder1(
.op(RD[6:0]),
.ResultSrc(ResultSrc),
.MemWrite(MemWrite),
.ALUOp(ALUOp),
.ALUControl(ALUControl),
.Branch(Branch),
.RegWrite(RegWrite),
.ALUSrc(ALUSrc)
); //check main decoder again

//PC Mux
PCMux PCMux1(
.PCSrc(PCSrc),
.PCPlus4(PCPlus4),
.PCTarget(PCTarget),
.PCNext(PCNext)
);

//PCPlus4
PCAdd4 PCAdd41(
.PC(PC),
.PCPlus4(PCPlsu4)
);

//PCPlusImm
PCPlusImm PCPlusImm1(
.PC(PC),
.ImmExt(ImmExt),
.PCTarget(PCTarget)
);

//PC
PC PC1(
.CLK(CLK),
.RST(RST),
.PCNext(PCNext)
)

RegisterFile RegisterFile1(
.CLK(CLK),
.RST(RST), //active-low reset synchronous
.WE3(WE3),
.A1(RD[19:15]), //only for R,I,S,B type
.A2(RD[24:20]), //only for R,S,B type
.A3(RD[11:7]), //only for R,I
.WD3(WD3),
.RD1(RD1),
.RD2(RD2)
);

SrcBMux (
.RD2(RD2),
.ImmExt(ImmExt),
.ALUSrc(ALUSrc),
.SrcB(SrcB)
);

endmodule
