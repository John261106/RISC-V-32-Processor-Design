// ============================================================
// FD — Fetch / Decode Pipeline Register
// Captures outputs of the Fetch stage at the rising clock edge
// and presents them to the Decode stage.
// Signals held:
//   Instr   [31:0]  — raw instruction word from InstructionMemory
//   PC      [31:0]  — program counter of the fetched instruction
//   PCPlus4 [31:0]  — PC + 4 (passed through for later use)
// ============================================================
module FD (
    input  wire        CLK,
    input  wire        RST,         // active-low synchronous reset

    // --- from Fetch stage ---
    input  wire [31:0] Instr_F,
    input  wire [31:0] PC_F,
    input  wire [31:0] PCPlus4_F,

    // --- to Decode stage ---
    output reg  [31:0] Instr_D,
    output reg  [31:0] PC_D,
    output reg  [31:0] PCPlus4_D
);

always @(posedge CLK) begin
    if (!RST) begin
        Instr_D   <= 32'b0;
        PC_D      <= 32'b0;
        PCPlus4_D <= 32'b0;
    end else begin
        Instr_D   <= Instr_F;
        PC_D      <= PC_F;
        PCPlus4_D <= PCPlus4_F;
    end
end

endmodule