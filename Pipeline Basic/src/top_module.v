module top_module(
input wire CLK,
input wire RST
);

//declare all the top module signals here

// Fetch stage signals
reg PCSrc;
reg [31:0] PCTarget;
reg [31:0] ALUResult;
reg [31:0] RD;
reg [31:0] PC;
reg [31:0] PCPlus4;

// Decode stage signals
reg WE3;
reg [4:0] A1;
reg [4:0] A2;
reg [4:0] A3;
reg [31:0] WD3;
reg [31:0] Imm;
reg [6:0] op;
reg [2:0] funct3;
reg [6:0] funct7;
reg [4:0] Rd11_7;

reg RegWriteD;
reg [1:0] ResultSrcD;
reg MemWriteD;
reg Cond_SrcD;
reg [3:0] ALUControlD;
reg ALUSrcD;
reg [31:0] RD1;
reg [31:0] RD2;
reg [31:0] ImmExtD;
reg [4:0] RdD;

// Execute stage signals
reg Cond_SrcE;
reg [3:0] ALUControlE;
reg ALUSrcE;
reg [31:0] RD1E;
reg [31:0] RD2E;
reg [31:0] PCE;
reg [31:0] ImmExtE;
reg [31:0] PCTargetE;
reg PCSrcE;
reg [31:0] ALUResultE;
reg [31:0] WriteDataE;

// Memory stage signals
reg MemWriteM;
reg [31:0] ALUResultM;
reg [31:0] WriteDataM;
reg [31:0] RD3;
reg [31:0] ALUResultM1;


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





	





endmodule
