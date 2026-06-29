// ============================================================
// TopModule_Pipeline.v
// 5-stage pipelined RISC-V processor (no hazard detection)
// Supports: LW, SW, BEQ, ADD, SUB, SLT, OR, AND
//
// Pipeline stages
//   F  : Fetch
//   D  : Decode
//   E  : Execute
//   M  : Memory
//   W  : WriteBack
//
// Pipeline registers between stages
//   FD : Fetch    → Decode
//   DE : Decode   → Execute
//   EM : Execute  → Memory
//   MW : Memory   → WriteBack
//
// NOTE: No hazard detection/forwarding is included.
//       Software must insert NOPs to avoid hazards.
// ============================================================
module TopModule_Pipeline (
    input wire CLK,
    input wire RST    // active-low synchronous reset
);

// ===========================================================
// ---- Wires : Fetch stage outputs / FD register inputs ----
// ===========================================================
wire [31:0] PC_F, Instr_F, PCPlus4_F;

// PCSrc and PCTarget fed back from EM register
wire        PCSrc_M;
wire [31:0] PCTarget_M;

// ===========================================================
// ---- Wires : FD register outputs / Decode stage inputs ----
// ===========================================================
wire [31:0] Instr_D, PC_D, PCPlus4_D;

// ===========================================================
// ---- Wires : Decode stage outputs / DE register inputs ----
// ===========================================================
wire        RegWrite_D, ResultSrc_D, MemWrite_D, ALUSrc_D, Branch_D;
wire [1:0]  ALUOp_D;
wire [2:0]  ALUControl_D;
wire [31:0] RD1_D, RD2_D, ImmExt_D;
wire [4:0]  RS1_D, RS2_D, RD_D;

// ===========================================================
// ---- Wires : DE register outputs / Execute stage inputs ----
// ===========================================================
wire        RegWrite_E, ResultSrc_E, MemWrite_E, ALUSrc_E, Branch_E;
wire [1:0]  ALUOp_E;
wire [2:0]  ALUControl_E;
wire [31:0] RD1_E, RD2_E, ImmExt_E, PC_E, PCPlus4_E;
wire [4:0]  RS1_E, RS2_E, RD_E;

// ===========================================================
// ---- Wires : Execute stage outputs / EM register inputs ----
// ===========================================================
wire        PCSrc_E;
wire [31:0] ALUResult_E, WriteData_E, PCTarget_E, PCPlus4_EtoEM;

// ===========================================================
// ---- Wires : EM register outputs / Memory stage inputs ----
// ===========================================================
wire        RegWrite_M_reg, ResultSrc_M_reg, MemWrite_M_reg;
wire [31:0] ALUResult_M, WriteData_M, PCPlus4_M, PCTarget_M_reg;
wire [4:0]  RD_M;

// ===========================================================
// ---- Wires : Memory stage outputs / MW register inputs ----
// ===========================================================
wire [31:0] ReadData_M;

// ===========================================================
// ---- Wires : MW register outputs / WriteBack inputs ----
// ===========================================================
wire        RegWrite_W, ResultSrc_W;
wire [31:0] ALUResult_W, ReadData_W, PCPlus4_W;
wire [4:0]  RD_W;

// ===========================================================
// ---- Wires : WriteBack outputs (feedback to Decode) ----
// ===========================================================
wire [31:0] Result_W;
wire        RegWriteOut;
wire [4:0]  RDOut;

// ===========================================================
// ---- STAGE 1 : FETCH ----
// ===========================================================
Fetch Fetch_stage (
    .CLK      (CLK),
    .RST      (RST),
    .PCSrc    (PCSrc_M),         // from EM register
    .PCTarget (PCTarget_M),      // from EM register
    .PC_F     (PC_F),
    .Instr_F  (Instr_F),
    .PCPlus4_F(PCPlus4_F)
);

// ===========================================================
// ---- FD PIPELINE REGISTER ----
// ===========================================================
FD FD_reg (
    .CLK      (CLK),
    .RST      (RST),
    .Instr_F  (Instr_F),
    .PC_F     (PC_F),
    .PCPlus4_F(PCPlus4_F),
    .Instr_D  (Instr_D),
    .PC_D     (PC_D),
    .PCPlus4_D(PCPlus4_D)
);

// ===========================================================
// ---- STAGE 2 : DECODE ----
// ===========================================================
Decode Decode_stage (
    .CLK         (CLK),
    .RST         (RST),
    .Instr_D     (Instr_D),
    .PC_D        (PC_D),
    .PCPlus4_D   (PCPlus4_D),
    // WB feedback
    .RegWrite_W  (RegWriteOut),
    .RD_W        (RDOut),
    .Result_W    (Result_W),
    // Control outputs
    .RegWrite_D  (RegWrite_D),
    .ResultSrc_D (ResultSrc_D),
    .MemWrite_D  (MemWrite_D),
    .ALUSrc_D    (ALUSrc_D),
    .Branch_D    (Branch_D),
    .ALUOp_D     (ALUOp_D),
    .ALUControl_D(ALUControl_D),
    // Data outputs
    .RD1_D       (RD1_D),
    .RD2_D       (RD2_D),
    .ImmExt_D    (ImmExt_D),
    .RS1_D       (RS1_D),
    .RS2_D       (RS2_D),
    .RD_D        (RD_D)
);

// ===========================================================
// ---- DE PIPELINE REGISTER ----
// ===========================================================
DE DE_reg (
    .CLK          (CLK),
    .RST          (RST),
    // Control in
    .RegWrite_D   (RegWrite_D),
    .ResultSrc_D  (ResultSrc_D),
    .MemWrite_D   (MemWrite_D),
    .ALUSrc_D     (ALUSrc_D),
    .Branch_D     (Branch_D),
    .ALUOp_D      (ALUOp_D),
    .ALUControl_D (ALUControl_D),
    // Data in
    .RD1_D        (RD1_D),
    .RD2_D        (RD2_D),
    .ImmExt_D     (ImmExt_D),
    .PC_D         (PC_D),
    .PCPlus4_D    (PCPlus4_D),
    .RS1_D        (RS1_D),
    .RS2_D        (RS2_D),
    .RD_D         (RD_D),
    // Control out
    .RegWrite_E   (RegWrite_E),
    .ResultSrc_E  (ResultSrc_E),
    .MemWrite_E   (MemWrite_E),
    .ALUSrc_E     (ALUSrc_E),
    .Branch_E     (Branch_E),
    .ALUOp_E      (ALUOp_E),
    .ALUControl_E (ALUControl_E),
    // Data out
    .RD1_E        (RD1_E),
    .RD2_E        (RD2_E),
    .ImmExt_E     (ImmExt_E),
    .PC_E         (PC_E),
    .PCPlus4_E    (PCPlus4_E),
    .RS1_E        (RS1_E),
    .RS2_E        (RS2_E),
    .RD_E         (RD_E)
);

// ===========================================================
// ---- STAGE 3 : EXECUTE ----
// ===========================================================
Execute Execute_stage (
    .RegWrite_E   (RegWrite_E),
    .ResultSrc_E  (ResultSrc_E),
    .MemWrite_E   (MemWrite_E),
    .ALUSrc_E     (ALUSrc_E),
    .Branch_E     (Branch_E),
    .ALUControl_E (ALUControl_E),
    .RD1_E        (RD1_E),
    .RD2_E        (RD2_E),
    .ImmExt_E     (ImmExt_E),
    .PC_E         (PC_E),
    .PCPlus4_E    (PCPlus4_E),
    .PCSrc_E      (PCSrc_E),
    .ALUResult_E  (ALUResult_E),
    .WriteData_E  (WriteData_E),
    .PCTarget_E   (PCTarget_E),
    .PCPlus4_out  (PCPlus4_EtoEM)
);

// ===========================================================
// ---- EM PIPELINE REGISTER ----
// ===========================================================
EM EM_reg (
    .CLK          (CLK),
    .RST          (RST),
    // Control in
    .RegWrite_E   (RegWrite_E),
    .ResultSrc_E  (ResultSrc_E),
    .MemWrite_E   (MemWrite_E),
    .PCSrc_E      (PCSrc_E),
    // Data in
    .ALUResult_E  (ALUResult_E),
    .WriteData_E  (WriteData_E),
    .PCPlus4_E    (PCPlus4_EtoEM),
    .PCTarget_E   (PCTarget_E),
    .RD_E         (RD_E),
    // Control out
    .RegWrite_M   (RegWrite_M_reg),
    .ResultSrc_M  (ResultSrc_M_reg),
    .MemWrite_M   (MemWrite_M_reg),
    .PCSrc_M      (PCSrc_M),        // → Fetch stage
    // Data out
    .ALUResult_M  (ALUResult_M),
    .WriteData_M  (WriteData_M),
    .PCPlus4_M    (PCPlus4_M),
    .PCTarget_M   (PCTarget_M),     // → Fetch stage
    .RD_M         (RD_M)
);

// ===========================================================
// ---- STAGE 4 : MEMORY ----
// ===========================================================
Memory Memory_stage (
    .CLK         (CLK),
    .RST         (RST),
    .MemWrite_M  (MemWrite_M_reg),
    .ALUResult_M (ALUResult_M),
    .WriteData_M (WriteData_M),
    .ReadData_M  (ReadData_M)
);

// ===========================================================
// ---- MW PIPELINE REGISTER ----
// ===========================================================
MW MW_reg (
    .CLK          (CLK),
    .RST          (RST),
    // Control in
    .RegWrite_M   (RegWrite_M_reg),
    .ResultSrc_M  (ResultSrc_M_reg),
    // Data in
    .ALUResult_M  (ALUResult_M),
    .ReadData_M   (ReadData_M),
    .PCPlus4_M    (PCPlus4_M),
    .RD_M         (RD_M),
    // Control out
    .RegWrite_W   (RegWrite_W),
    .ResultSrc_W  (ResultSrc_W),
    // Data out
    .ALUResult_W  (ALUResult_W),
    .ReadData_W   (ReadData_W),
    .PCPlus4_W    (PCPlus4_W),
    .RD_W         (RD_W)
);

// ===========================================================
// ---- STAGE 5 : WRITEBACK ----
// ===========================================================
WriteBack WB_stage (
    .RegWrite_W  (RegWrite_W),
    .ResultSrc_W (ResultSrc_W),
    .ALUResult_W (ALUResult_W),
    .ReadData_W  (ReadData_W),
    .PCPlus4_W   (PCPlus4_W),
    .RD_W        (RD_W),
    .Result_W    (Result_W),
    .RegWriteOut (RegWriteOut),
    .RDOut       (RDOut)
);

endmodule