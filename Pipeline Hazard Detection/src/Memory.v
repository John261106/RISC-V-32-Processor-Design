// ============================================================
// Memory.v — Stage 4 : Data Memory Access
// Contains: DataMemory
//
// Inputs come from the EM pipeline register.
// For LW  : ALUResult_M is the address; ReadData is output.
// For SW  : ALUResult_M is the address; WriteData_M is stored.
// Control signals RegWrite, ResultSrc are passed straight
// through to the MW pipeline register unchanged.
// ============================================================
module Memory (
    input  wire        CLK,
    input  wire        RST,         // active-low synchronous reset

    // From EM pipeline register (control)
    input  wire        MemWrite_M,

    // From EM pipeline register (data)
    input  wire [31:0] ALUResult_M,
    input  wire [31:0] WriteData_M,

    // ---- Output to MW pipeline register ----
    output wire [31:0] ReadData_M   // DataMemory read output (for LW)
);

// ---- Data Memory ----
DataMemory DMem_inst (
    .CLK (CLK),
    .WE  (MemWrite_M),
    .A_DM(ALUResult_M),
    .WD  (WriteData_M),
    .RST (RST),
    .RD3 (ReadData_M)
);

endmodule