module MW (
    input wire CLK,
    input wire RST,
    input wire RegWriteM,
    input wire [1:0] ResultSrcM,
    input wire [31:0] ALUResultM,
    input wire [31:0] ReadDataM,
    input wire [4:0] RdM,
    input wire [31:0] PCPlus4M,
    
    output wire RegWriteW,
    output wire [1:0] ResultSrcW,
    output wire [31:0] ALUResultW,
    output wire [31:0] ReadDataW,
    output wire [4:0] RdW,
    output wire [31:0] PCPlus4W
);

// Intermediate pipeline registers
reg RegWrite;
reg [1:0] ResultSrc;
reg [31:0] ALUResult;
reg [31:0] ReadData;
reg [4:0] Rd;
reg [31:0] PCPlus4;

// Sequential logic (synchronous reset)
always @(posedge CLK) begin
    if (!RST) begin
        RegWrite  <= 1'bx;
        ResultSrc <= 2'bx;
        ALUResult <= 32'bx;
        ReadData  <= 32'bx;
        Rd        <= 5'bx;
        PCPlus4   <= 32'bx;
    end 
    else begin
        RegWrite  <= RegWriteM;
        ResultSrc <= ResultSrcM;
        ALUResult <= ALUResultM;
        ReadData  <= ReadDataM;
        Rd        <= RdM;
        PCPlus4   <= PCPlus4M;
    end
end

// Continuous assignments to outputs
assign RegWriteW  = RegWrite;
assign ResultSrcW = ResultSrc;
assign ALUResultW = ALUResult;
assign ReadDataW  = ReadData;
assign RdW        = Rd;
assign PCPlus4W   = PCPlus4;

endmodule

