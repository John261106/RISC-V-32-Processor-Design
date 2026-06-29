// ============================================================
// WriteBack.v — Stage 5 : Write Back
// Contains: ResultMux
//
// Inputs come from the MW pipeline register.
// Selects between ALUResult (R-type / I-type arithmetic) and
// ReadData (LW) and drives the Result back to the register file
// in the Decode stage.
// RegWrite_W and RD_W are also output so the Decode stage can
// use them as write-enable and write-address for the RF.
// ============================================================
module WriteBack (
    // From MW pipeline register (control)
    input  wire        RegWrite_W,
    input  wire        ResultSrc_W,

    // From MW pipeline register (data)
    input  wire [31:0] ALUResult_W,
    input  wire [31:0] ReadData_W,
    input  wire [31:0] PCPlus4_W,  // reserved for future JAL support

    // Destination register address (passed straight through)
    input  wire [4:0]  RD_W,

    // ---- Outputs fed back to Decode stage ----
    output wire [31:0] Result_W,    // write-back data
    output wire        RegWriteOut, // = RegWrite_W (alias for clarity)
    output wire [4:0]  RDOut        // = RD_W
);

// ---- Result Mux : ALUResult or ReadData ----
ResultMux RMux_inst (
    .ALUResult(ALUResult_W),
    .ReadData (ReadData_W),
    .ResultSrc(ResultSrc_W),
    .Result   (Result_W)
);

// Pass-throughs
assign RegWriteOut = RegWrite_W;
assign RDOut       = RD_W;

endmodule