// ============================================================
// DE — Decode / Execute Pipeline Register
// Captures outputs of the Decode stage at the rising clock edge
// and presents them to the Execute stage.
// Signals held:
//   Control signals decoded from the instruction
//   RD1, RD2   — register-file read data
//   ImmExt     — sign-extended immediate
//   RS1, RS2, RD — register addresses (forwarding / WB use)
//   PC, PCPlus4 — passed through
//   Funct3     — passed for ALU decoder in Execute
// ============================================================
module DE (
    input  wire        CLK,
    input  wire        RST,         // active-low synchronous reset

    // --- from Decode stage (control) ---
    input  wire        RegWrite_D,
    input  wire        ResultSrc_D,
    input  wire        MemWrite_D,
    input  wire        ALUSrc_D,
    input  wire        Branch_D,
    input  wire [1:0]  ALUOp_D,
    input  wire [2:0]  ALUControl_D,

    // --- from Decode stage (data) ---
    input  wire [31:0] RD1_D,
    input  wire [31:0] RD2_D,
    input  wire [31:0] ImmExt_D,
    input  wire [31:0] PC_D,
    input  wire [31:0] PCPlus4_D,

    // --- register addresses (for forwarding / writeback) ---
    input  wire [4:0]  RS1_D,
    input  wire [4:0]  RS2_D,
    input  wire [4:0]  RD_D,       // destination register

    input wire FlushE, // form hazard detection unit

    // --- to Execute stage (control) ---
    output reg         RegWrite_E,
    output reg         ResultSrc_E,
    output reg         MemWrite_E,
    output reg         ALUSrc_E,
    output reg         Branch_E,
    output reg  [1:0]  ALUOp_E,
    output reg  [2:0]  ALUControl_E,

    // --- to Execute stage (data) ---
    output reg  [31:0] RD1_E,
    output reg  [31:0] RD2_E,
    output reg  [31:0] ImmExt_E,
    output reg  [31:0] PC_E,
    output reg  [31:0] PCPlus4_E,

    // --- register addresses ---
    output reg  [4:0]  RS1_E,
    output reg  [4:0]  RS2_E,
    output reg  [4:0]  RD_E
);

always @(posedge CLK) begin
    if (!RST) begin
        RegWrite_E   <= 1'b0;
        ResultSrc_E  <= 1'b0;
        MemWrite_E   <= 1'b0;
        ALUSrc_E     <= 1'b0;
        Branch_E     <= 1'b0;
        ALUOp_E      <= 2'b0;
        ALUControl_E <= 3'b0;

        RD1_E        <= 32'b0;
        RD2_E        <= 32'b0;
        ImmExt_E     <= 32'b0;
        PC_E         <= 32'b0;
        PCPlus4_E    <= 32'b0;

        RS1_E        <= 5'b0;
        RS2_E        <= 5'b0;
        RD_E         <= 5'b0;
    end
    else if (FlushE) begin
        RegWrite_E   <= 0;
        ResultSrc_E  <= 0;
        MemWrite_E   <= 0;
        ALUSrc_E     <= 0;
        Branch_E     <= 0;
        ALUOp_E      <= 0;
        ALUControl_E <= 0;

        RD1_E     <= 32'b0;
        RD2_E     <= 32'b0;
        ImmExt_E  <= 32'b0;
        PC_E      <= 32'b0;
        PCPlus4_E <= 32'b0;

        RS1_E <= 5'b0;
        RS2_E <= 5'b0;
        RD_E  <= 5'b0;
    end

    else begin 
        RegWrite_E   <= RegWrite_D;
        ResultSrc_E  <= ResultSrc_D;
        MemWrite_E   <= MemWrite_D;
        ALUSrc_E     <= ALUSrc_D;
        Branch_E     <= Branch_D;
        ALUOp_E      <= ALUOp_D;
        ALUControl_E <= ALUControl_D;

        RD1_E        <= RD1_D;
        RD2_E        <= RD2_D;
        ImmExt_E     <= ImmExt_D;
        PC_E         <= PC_D;
        PCPlus4_E    <= PCPlus4_D;

        RS1_E        <= RS1_D;
        RS2_E        <= RS2_D;
        RD_E         <= RD_D;

    end


end

endmodule