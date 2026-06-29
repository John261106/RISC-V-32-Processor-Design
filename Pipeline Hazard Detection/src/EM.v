// ============================================================
// EM — Execute / Memory Pipeline Register
// Captures outputs of the Execute stage at the rising clock edge
// and presents them to the Memory stage.
// Signals held:
//   RegWrite, ResultSrc, MemWrite — control signals surviving to WB/MEM
//   PCSrc     — branch/jump decision
//   PCTarget  — branch target address
//   ALUResult — computed address or arithmetic result
//   WriteData — RD2 value to be written to data memory (for SW)
//   RD        — destination register address
// ============================================================
module EM (
    input  wire        CLK,
    input  wire        RST,         // active-low synchronous reset

    // --- from Execute stage (control) ---
    input  wire        RegWrite_E,
    input  wire        ResultSrc_E,
    input  wire        MemWrite_E,
    input  wire        PCSrc_E,

    // --- from Execute stage (data) ---
    input  wire [31:0] ALUResult_E,
    input  wire [31:0] WriteData_E, // = RD2 from Execute
    input  wire [31:0] PCPlus4_E,
    input  wire [31:0] PCTarget_E,

    // --- destination register ---
    input  wire [4:0]  RD_E,

    // --- to Memory stage (control) ---
    output reg         RegWrite_M,
    output reg         ResultSrc_M,
    output reg         MemWrite_M,
    output reg         PCSrc_M,

    // --- to Memory stage (data) ---
    output reg  [31:0] ALUResult_M,
    output reg  [31:0] WriteData_M,
    output reg  [31:0] PCPlus4_M,
    output reg  [31:0] PCTarget_M,

    // --- destination register ---
    output reg  [4:0]  RD_M
);

always @(posedge CLK) begin
    if (!RST) begin
        RegWrite_M   <= 1'b0;
        ResultSrc_M  <= 1'b0;
        MemWrite_M   <= 1'b0;
        PCSrc_M      <= 1'b0;

        ALUResult_M  <= 32'b0;
        WriteData_M  <= 32'b0;
        PCPlus4_M    <= 32'b0;
        PCTarget_M   <= 32'b0;

        RD_M         <= 5'b0;
    end else begin
        RegWrite_M   <= RegWrite_E;
        ResultSrc_M  <= ResultSrc_E;
        MemWrite_M   <= MemWrite_E;
        PCSrc_M      <= PCSrc_E;

        ALUResult_M  <= ALUResult_E;
        WriteData_M  <= WriteData_E;
        PCPlus4_M    <= PCPlus4_E;
        PCTarget_M   <= PCTarget_E;

        RD_M         <= RD_E;
    end
end

endmodule