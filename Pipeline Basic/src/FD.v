module FD(
input wire [31:0] RD,
input wire [31:0] PCF,
input wire [31:0] PCPlus4F,
input wire RST,
input wire CLK,
output wire [31:0] InstrD,
output wire [31:0] PCD,
output wire [31:0] PCPlus4D
);

reg [31:0] Instr;
reg [31:0] PC;
reg [31:0] PCPlus4;


    // Sequential logic 
always @(posedge CLK) begin
    if (!RST) begin  // Active-low reset
        Instr <= 0;
        PC <= 0;
        PCPlus4 <= 0;
    end
    else begin
        Instr <= RD;
        PC <= PCPlus4F;
        PCPlus4 <= PCPlus4F;
    end
end

    // Continuous assignments to outputs
assign InstrD = Instr;
assign PCD= PC;
assign PCPlus4D = PCPlus4;

endmodule
