// ============================================================
// Decode.v — Stage 2 : Instruction Decode / Register Read
// Contains: MainDecoder, ALUDecoder, RegisterFile, Extend
//
// Inputs come from the FD pipeline register.
// Writeback (WD3, WE3, A3) comes from the WriteBack stage
// and is fed back asynchronously into the register file.
// All decoded signals feed into the DE pipeline register.
// ============================================================
module Decode (
    input  wire        CLK,
    input  wire        RST,         // active-low synchronous reset

    // From FD pipeline register
    input  wire [31:0] Instr_D,     // instruction word
    input  wire [31:0] PC_D,
    input  wire [31:0] PCPlus4_D,

    // Writeback feedback (from WriteBack stage)
    input  wire        RegWrite_W,
    input  wire [4:0]  RD_W,
    input  wire [31:0] Result_W,

    // ---- Decoded control signals (to DE register) ----
    output wire        RegWrite_D,
    output wire        ResultSrc_D,
    output wire        MemWrite_D,
    output wire        ALUSrc_D,
    output wire        Branch_D,
    output wire [1:0]  ALUOp_D,
    output wire [2:0]  ALUControl_D,

    // ---- Data outputs (to DE register) ----
    output wire [31:0] RD1_D,
    output wire [31:0] RD2_D,
    output wire [31:0] ImmExt_D,

    // ---- Register addresses (to DE register for forwarding / WB) ----
    output wire [4:0]  RS1_D,       // = Instr_D[19:15]
    output wire [4:0]  RS2_D,       // = Instr_D[24:20]
    output wire [4:0]  RD_D         // = Instr_D[11:7]
);

// ---- Control signals from MainDecoder ----
wire [1:0] ImmSrc;

MainDecoder MainDec_inst (
    .op       (Instr_D[6:0]),
    .ResultSrc(ResultSrc_D),
    .MemWrite (MemWrite_D),
    .ALUOp    (ALUOp_D),
    .ALUSrc   (ALUSrc_D),
    .ImmSrc   (ImmSrc),
    .RegWrite (RegWrite_D),
    .Branch   (Branch_D)
);

// ---- ALU Control from ALUDecoder ----
ALUDecoder ALUDec_inst (
    .funct3    (Instr_D[14:12]),
    .funct7    (Instr_D[31:25]),
    .op        (Instr_D[6:0]),
    .ALUOp     (ALUOp_D),
    .ALUControl(ALUControl_D)
);

// ---- Register File ----
// Reads are combinational; write happens at posedge CLK in the RF itself.
assign RS1_D = Instr_D[19:15];
assign RS2_D = Instr_D[24:20];
assign RD_D  = Instr_D[11:7];

RegisterFile RF_inst (
    .CLK(CLK),
    .RST(RST),
    .WE3(RegWrite_W),
    .A1 (RS1_D),
    .A2 (RS2_D),
    .A3 (RD_W),
    .WD3(Result_W),
    .RD1(RD1_D),
    .RD2(RD2_D)
);

// ---- Immediate Extender ----
// Instr_D[31:7] are the 25 bits passed to Extend (same as single-cycle)
Extend Ext_inst (
    .Imm   (Instr_D[31:7]),
    .ImmSrc(ImmSrc),
    .ImmExt(ImmExt_D)
);

endmodule