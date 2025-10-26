module FD(
input wire [31:0] RD,
input wire [31:0] PCF,
input wire [31:0] PCPlus4F,
output wire [31:0] InstrD,
output wire [31:0] PCD,
output wire [31:0] PCPlus4D
);

reg [31:0] Instr;
reg [31:0] PC;
reg [31:0] PCPlus4;


    // Sequential logic (pipeline register update)
    always @(posedge CLK) begin
        Instr = RD;
        PC=PCPlus4F;
        PCPlus4=PCPlus4F
    end

    // Continuous assignments to outputs
    assign InstrD = Instr;
    assign  PCD= PCF;
    assign PCPlus4D = PCPlus4F;

endmodule
