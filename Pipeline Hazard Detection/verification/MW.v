// ============================================================
// MW — Memory / WriteBack Pipeline Register
// Captures outputs of the Memory stage at the rising clock edge
// and presents them to the WriteBack stage.
// Signals held:
//   RegWrite   — enables register write in WB
//   ResultSrc  — selects ALUResult vs ReadData for WB
//   ALUResult  — passed through for R/I-type writeback
//   ReadData   — data read from DataMemory (for LW)
//   PCPlus4    — passed through (if needed for JAL-type later)
//   RD         — destination register address
// ============================================================
module MW (
    input  wire        CLK,
    input  wire        RST,         // active-low synchronous reset

    // --- from Memory stage (control) ---
    input  wire        RegWrite_M,
    input  wire        ResultSrc_M,

    // --- from Memory stage (data) ---
    input  wire [31:0] ALUResult_M,
    input  wire [31:0] ReadData_M,  // from DataMemory RD3
    input  wire [31:0] PCPlus4_M,

    // --- destination register ---
    input  wire [4:0]  RD_M,

    // --- to WriteBack stage (control) ---
    output reg         RegWrite_W,
    output reg         ResultSrc_W,

    // --- to WriteBack stage (data) ---
    output reg  [31:0] ALUResult_W,
    output reg  [31:0] ReadData_W,
    output reg  [31:0] PCPlus4_W,

    // --- destination register ---
    output reg  [4:0]  RD_W
);

always @(posedge CLK) begin
    if (!RST) begin
        RegWrite_W   <= 1'b0;
        ResultSrc_W  <= 1'b0;

        ALUResult_W  <= 32'b0;
        ReadData_W   <= 32'b0;
        PCPlus4_W    <= 32'b0;

        RD_W         <= 5'b0;
    end else begin
        RegWrite_W   <= RegWrite_M;
        ResultSrc_W  <= ResultSrc_M;

        ALUResult_W  <= ALUResult_M;
        ReadData_W   <= ReadData_M;
        PCPlus4_W    <= PCPlus4_M;

        RD_W         <= RD_M;
    end
end

endmodule