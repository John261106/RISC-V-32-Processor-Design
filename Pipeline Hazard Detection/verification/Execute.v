// ============================================================
// Execute.v — Stage 3 : Execute
// Contains: SrcBMux, ALU, BranchJump, PCPlusImm
//
// Inputs come from the DE pipeline register.
// Computes:
//   ALUResult  — arithmetic / logic result or memory address
//   PCSrc      — branch taken signal (passed into EM register)
//   PCTarget   — branch target address (passed into EM register)
//   WriteData  — RD2 passed through to EM for memory writes
// ============================================================
module Execute (
    // From DE pipeline register (control)
    input  wire        RegWrite_E,
    input  wire        ResultSrc_E,
    input  wire        MemWrite_E,
    input  wire        ALUSrc_E,
    input  wire        Branch_E,
    input  wire [2:0]  ALUControl_E,

    // From DE pipeline register (data)
    input  wire [31:0] RD1_E,       // SrcA
    input  wire [31:0] RD2_E,       // potential SrcB or WriteData
    input  wire [31:0] ImmExt_E,
    input  wire [31:0] PC_E,
    input  wire [31:0] PCPlus4_E,

    // ---- Outputs (to EM pipeline register) ----
    output wire        PCSrc_E,
    output wire [31:0] ALUResult_E,
    output wire [31:0] WriteData_E, // = RD2, forwarded for SW
    output wire [31:0] PCTarget_E,
    output wire [31:0] PCPlus4_out  // passed straight through
);

// ---- SrcB Mux : RD2 or ImmExt ----
wire [31:0] SrcB;

SrcBMux SrcB_inst (
    .RD2   (RD2_E),
    .ImmExt(ImmExt_E),
    .ALUSrc(ALUSrc_E),
    .SrcB  (SrcB)
);

// ---- ALU ----
wire Zero;

ALU ALU_inst (
    .SrcA      (RD1_E),
    .SrcB      (SrcB),
    .ALUControl(ALUControl_E),
    .ALUResult (ALUResult_E),
    .Zero      (Zero)
);

// ---- Branch decision ----
BranchJump BJ_inst (
    .Branch(Branch_E),
    .Zero  (Zero),
    .PCSrc (PCSrc_E)
);

// ---- Branch target : PC_E + ImmExt_E ----
PCPlusImm PCImm_inst (
    .PC      (PC_E),
    .ImmExt  (ImmExt_E),
    .PCTarget(PCTarget_E)
);

// WriteData just passes RD2 through to the EM register
assign WriteData_E  = RD2_E;
assign PCPlus4_out  = PCPlus4_E;

endmodule