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
        RegWrite  <= 1'b0;
        ResultSrc <= 2'b00;
        ALUResult <= 32'b0;
        ReadData  <= 32'b0;
        Rd        <= 5'b0;
        PCPlus4   <= 32'b0;
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

