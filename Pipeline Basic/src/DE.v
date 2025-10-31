module DE(
input wire CLK,

input wire RegWriteD, 
input wire [1:0] ResultSrcD, 
input wire MemWriteD, 
input wire [2:0] ALUControlD, 
input wire ALUSrcD, 
input wire PCD, 
input wire [4:0] RdD, 
input wire [31:0] ImmExtD
input wire [31:0] RD1D,
input wire [31:0] RD2D,
input wire RST,
input wire [31:0] PCPlus4D,
input wire [2:0] Cond_SrcD,
output wire RegWriteE,
output wire [1:0] ResultSrcE,
output wire MemWriteE,
output wire BranchE,
output wire [2:0] ALUControlE,
output wire  ALUSrcE,
output wire [31:0] RD1E,
output wire [31:0] RD2E,
output wire [31:0] PCE,
output wire [4:0]  RdE,
output wire [31:0] ImmExtE,
output wire [31:0] PCPlus4E,
output wire [31:0] Cond_SrcE
);

reg RegWrite;
reg [1:0] ResultSrc;
reg MemWrite;
reg Branch;
reg [2:0] ALUControl;
reg ALUSrc;
reg [31:0] RD1;
reg [31:0] RD2;
reg [31:0] PC;
reg [4:0]  Rd;
reg [31:0] ImmExt;

    // Sequential logic (pipeline register update)
always @(posedge CLK) begin
    if (!RST) begin  // Active-low reset
        RegWrite <= 0;
        ResultSrc <= 0;
        MemWrite <= 0;
        Cond_Src <= 0;
	ALUControl <= 0;
        ALUSrc <= 0;
        RD1 <= 0;
        RD2 <= 0;
        PC <= 0;
        Rd <= 0;
        ImmExt <= 0;
    end
    else begin
        RegWrite <= RegWriteD;
        ResultSrc <= ResultSrcD;
        MemWrite <= MemWriteD;
        Cond_Src <=Cond_SrcD;
        ALUControl <= ALUControlD;
        ALUSrc <= ALUSrcD;
        RD1 <= RD1D;
        RD2 <= RD2D;
        PC <= PCD;
        Rd <= RdD;
        ImmExt <= ImmExtD;
    end
end

    // Continuous assignments to outputs
    assign RegWriteE = RegWrite;
    assign ResultSrcE = ResultSrc;
    assign MemWriteE = MemWrite;
    assign ALUControlE = ALUControl;
    assign Cond_SrcE = Cond_SrcD;
    assign ALUSrcE = ALUSrc;
    assign RD1E = RD1;
    assign RD2E = RD2;
    assign PCE = PC;
    assign RdE = Rd;
    assign ImmExtE = ImmExt;

endmodule
