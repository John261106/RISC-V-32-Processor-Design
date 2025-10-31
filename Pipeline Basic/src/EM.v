module EM (
    input wire CLK,
    input wire RST,
    input wire RegWriteE,
    input wire [1:0] ResultSrcE,
    input wire MemWriteE,
    input wire [31:0] ALUResultE,
    input wire [31:0] PCPlus4E,
    input wire [4:0] RdE,
    input wire [31:0] WriteDataE,

    output wire RegWriteM,
    output wire [1:0] ResultSrcM,
    output wire MemWriteM,
    output wire [31:0] ALUResultM,
    output wire [5:0] RdM,
    output wire [31:0] PCPlus4M,
    output wire [31:0] WriteDataM
);

    // Pipeline registers
    reg RegWrite;
    reg [1:0] ResultSrc;
    reg MemWrite;
    reg [4:0] Rd;
    reg [31:0] PCPlus4;
    reg [31:0] WriteData;
    reg [31:0] ALUResult;

        // Synchronous reset + data latching
    always @(posedge CLK) begin
        if (RST) begin
            RegWrite <= 0;
            ResultSrc <= 0;
            MemWrite <= 0;
            Rd <= 0;
            PCPlus4 <= 0;
            WriteData <= 0;
	    ALUResult <= 0;
        end else begin
            RegWrite <= RegWriteE;
            ResultSrc <= ResultSrcE;
            MemWrite <= MemWriteE;
            Rd <= RdE;
            PCPlus4 <= PCPlus4E;
            WriteData <= WriteDataE;
	    ALUResult <= ALUResultE
        end
    end

    // Output connections to M stage
    assign RegWriteM = RegWrite;
    assign ResultSrcM = ResultSrc;
    assign MemWriteM = MemWrite;
    assign RdM = Rd;
    assign PCPlus4M = PCPlus4;
    assign WriteDataM = WriteData;
    assign ALUResultM = ALUResult;


    endmodule
 
