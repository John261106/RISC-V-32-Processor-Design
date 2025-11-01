module top_module(
input wire CLK,
input wire RST
);

//declare all the top module signals here

// Fetch stage signals
wire PCSrcE;
wire [31:0] PCTargetE;
wire [31:0] ALUResult;
wire [31:0] RD;
wire [31:0] PCF;
wire [31:0] PCPlus4F;

// Decode stage signals
wire WE3;
wire [4:0] A1;
wire [4:0] A2;
wire [4:0] A3;
wire [31:0] WD3;
wire [31:0] Imm;
wire [6:0] op;
wire [2:0] funct3;
wire [6:0] funct7;
wire [4:0] Rd11_7;

wire RegWriteD;
wire [1:0] ResultSrcD;
wire MemWriteD;
wire Cond_SrcD;
wire [3:0] ALUControlD;
wire ALUSrcD;
wire [31:0] RD1;
wire [31:0] RD2;
wire [31:0] ImmExtD;
wire [4:0] RdD;

// Execute stage signals
wire Cond_SrcE;
wire [3:0] ALUControlE;
wire ALUSrcE;
wire [31:0] RD1E;
wire [31:0] RD2E;
wire [31:0] PCE;
wire [31:0] ImmExtE;
wire [31:0] PCTargetE;
wire PCSrcE;
wire [31:0] ALUResultE;
wire [31:0] WriteDataE;

// Memory stage signals
wire MemWriteM;
wire [31:0] ALUResultM;
wire [31:0] WriteDataM;
wire [31:0] RD3;
wire [31:0] ALUResultM1;


Fetch Fetch1(
.PCSrcE(PCSrc),
.CLK(CLK),
.RST(RST),
.PCTargetE(PCTarget),
.ALUResultE(ALUResult),
.RD(RD),
.PCF(PC),
.PCPlus4F(PCPlus4)
);

Decode Decode1(
.op(RD[6:0]),
.funct3(RD[14:12]),
.funct7(RD[31:25]),
.CLK(CLK),
.RST(RST), //active-low reset synchronous
.WE3(WE3),
.A1(RD[19:15]),
.A2(RD[24:20]),
.A3(A3),//need to connect to RdW
.Imm(RD[31:7]),
.WD3(WD3), // need to connect it to ResultW
.Rd11_7(RD[11:7]), // this will be Instr[11:7]

.RegWriteD(RegWriteD),
.ResultSrcD(ResultSrcD), 
.MemWriteD(MemWriteD),
.Cond_SrcD(Cond_SrcD),
.ALUControlD(ALUControlD),
.ALUSrcD(ALUSrcD),
.RD1(RD1),   //following book notation
.RD2(RD2),   //following book notation
.ImmExtD(ImmExtD),
.RdD(RdD)
);

Execute Execute1 (
.Cond_SrcE(Cond_SrcE),
.ALUControlE(ALUControlE),
.ALUSrcE(ALUSrcE),
.RD1E(RD1E),
.RD2E(RD2E),
.PCE(PCE),
.ImmExtE(ImmExtE),
.PCTargetE(PCTargetE),
.PCSrcE(PCSrcE),
.ALUResultE(ALUResultE),
.WriteDataE(WriteDataE)
);

Memory Memory1 (
.MemWriteM(MemWriteM),
.ALUResultM(ALUResultM),
.WriteDataM(WriteDataM),
.CLK(CLK),
.RST(RST),
.RD3(RD3),
.ALUResultM1(ALUResultM1)
);

FD FD1 (
    .RD(RD),
    .PCF(PCF),
    .PCPlus4F(PCPlus4F),
    .RST(RST),
    .CLK(CLK),
    .InstrD(InstrD),
    .PCD(PCD),
    .PCPlus4D(PCPlus4D)
);

DE DE1 (
    .CLK(CLK),
    .RST(RST),

    .RegWriteD(RegWriteD),
    .ResultSrcD(ResultSrcD),
    .MemWriteD(MemWriteD),
    .ALUControlD(ALUControlD),
    .ALUSrcD(ALUSrcD),
    .PCD(PCD),
    .RdD(RdD),
    .ImmExtD(ImmExtD),
    .RD1D(RD1),
    .RD2D(RD2),
    .PCPlus4D(PCPlus4D),
    .Cond_SrcD(Cond_SrcD),

    .RegWriteE(RegWriteE),
    .ResultSrcE(ResultSrcE),
    .MemWriteE(MemWriteE),
    .BranchE(BranchE),
    .ALUControlE(ALUControlE),
    .ALUSrcE(ALUSrcE),
    .RD1E(RD1E),
    .RD2E(RD2E),
    .PCE(PCE),
    .RdE(RdE),
    .ImmExtE(ImmExtE),
    .PCPlus4E(PCPlus4E),
    .Cond_SrcE(Cond_SrcE)
);

	MW MW1 (
    .CLK(CLK),
    .RST(RST),
    .RegWriteM(RegWriteM),
    .ResultSrcM(ResultSrcM),
    .ALUResultM(ALUResultM),
    .ReadDataM(ReadDataM),
    .RdM(RdM),
    .PCPlus4M(PCPlus4M),

    .RegWriteW(RegWriteW),
    .ResultSrcW(ResultSrcW),
    .ALUResultW(ALUResultW),
    .ReadDataW(ReadDataW),
    .RdW(RdW),
    .PCPlus4W(PCPlus4W)
);

EM EM1 (
    .CLK(CLK),
    .RST(RST),
    .RegWriteE(RegWriteE),
    .ResultSrcE(ResultSrcE),
    .MemWriteE(MemWriteE),
    .ALUResultE(ALUResultE),
    .PCPlus4E(PCPlus4E),
    .RdE(RdE),
    .WriteDataE(WriteDataE),

    .RegWriteM(RegWriteM),
    .ResultSrcM(ResultSrcM),
    .MemWriteM(MemWriteM),
    .ALUResultM(ALUResultM),
    .RdM(RdM),
    .PCPlus4M(PCPlus4M),
    .WriteDataM(WriteDataM)
);	



	





endmodule
