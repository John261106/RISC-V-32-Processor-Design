module DE(
input wire CLK,

input wire RegWriteD, 
input wire [1:0] ResultSrcD, 
input wire MemWriteD, 
input wire [2:0] ALUControlD, 
input wire ALUSrcD, 
input wire [31:0] PCD, 
input wire [4:0] RdD, 
input wire [31:0] ImmExtD,
input wire [31:0] RD1D,
input wire [31:0] RD2D,
input wire RST,
input wire [31:0] PCPlus4D,
input wire [2:0] Cond_SrcD,
output wire RegWriteE,
output wire [1:0] ResultSrcE,
output wire MemWriteE,
output wire [2:0] ALUControlE,
output wire  ALUSrcE,
output wire [31:0] RD1E,
output wire [31:0] RD2E,
output wire [31:0] PCE,
output wire [4:0]  RdE,
output wire [31:0] ImmExtE,
output wire [31:0] PCPlus4E,
output wire [2:0] Cond_SrcE
);

reg RegWrite;
reg [1:0] ResultSrc;
reg MemWrite;
reg [2:0] ALUControl;
reg ALUSrc;
reg [31:0] RD1;
reg [31:0] RD2;
reg [31:0] PC;
reg [4:0]  Rd;
reg [31:0] ImmExt;
reg [2:0] Cond_Src;
reg [31:0] PCPlus4;
    // Sequential logic (pipeline register update)
always @(posedge CLK) begin
    if (!RST) begin  // Active-low reset
        RegWrite <= 1'bx;
        ResultSrc <= 2'bx;
        MemWrite <= 1'bx;
        Cond_Src <= 3'bx;
	    ALUControl <= 3'bx;
        ALUSrc <= 1'bx;
        RD1 <= 32'bx;
        RD2 <= 32'bx;
        PC <= 32'bx;
        Rd <= 5'bx;
        ImmExt <= 32'bx;
        PCPlus4 <=32'bx;
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
        PCPlus4 <= PCPlus4D;
    end
end

    // Continuous assignments to outputs
    assign RegWriteE = RegWrite;
    assign ResultSrcE = ResultSrc;
    assign MemWriteE = MemWrite;
    assign ALUControlE = ALUControl;
    assign Cond_SrcE = Cond_Src;
    assign ALUSrcE = ALUSrc;
    assign RD1E = RD1;
    assign RD2E = RD2;
    assign PCE = PC;
    assign RdE = Rd;
    assign ImmExtE = ImmExt;
    assign PCPlus4E =PCPlus4;


endmodule
