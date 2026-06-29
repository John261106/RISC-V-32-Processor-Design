// ============================================================
// Fetch.v — Stage 1 : Instruction Fetch
// Contains: PC, PCPlus4, PCMux, InstructionMemory
//
// PCSrc and PCTarget come from the EM pipeline register
// (branch decision resolved in Execute, propagated through EM).
// PCNext is chosen combinationally; PC advances on each clock.
// ============================================================
module Fetch (
    input  wire        CLK,
    input  wire        RST,         // active-low synchronous reset

    // Branch / Jump feedback (from EM register)
    input  wire        PCSrc,       // 1 → take branch/jump
    input  wire [31:0] PCTarget,    // branch target

    input wire PCWrite, //HAZARD DETECTION UNIT

    // Outputs to FD pipeline register
    output wire [31:0] PC_F,
    output wire [31:0] Instr_F,
    output wire [31:0] PCPlus4_F
);

// ---- Internal wires ----
wire [31:0] PCNext;

// ---- PC Mux : choose between PC+4 and branch target ----
PCMux PCMux_inst (
    .PCSrc   (PCSrc),
    .PCPlus4 (PCPlus4_F),
    .PCTarget(PCTarget),
    .PCNext  (PCNext)
);

// ---- Program Counter register ----
PC PC_inst (
    .CLK   (CLK),
    .RST   (RST),
    .PCNext(PCNext),
    .PCWrite(PCWrite),
    .PC    (PC_F)
);

// ---- PC + 4 adder ----
PCPlus4 PCPlus4_inst (
    .PC     (PC_F),
    .PCPlus4(PCPlus4_F)
);

// ---- Instruction Memory ----
InstructionMemory IMem_inst (
    .A (PC_F),
    .RD(Instr_F)
);

endmodule