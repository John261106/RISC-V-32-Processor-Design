// following name from diagram

module Fetch(
input wire PCSrcE,
input wire CLK,
input wire RST,
input wire[31:0] PCTargetE,
output reg [31:0] RD,
output reg [31:0] PCF,
output reg [31:0] PCPlus4F
);
wire [31:0] PCPlus4F;
wire [31:0] A;
reg [31:0] PCF';//reg since used in always block

assign A = PCF;

case (A[31:0]) 
    32'd0: RD = 32'b00000000010000000010000010000011; // lw x1 x0(4)
    32'd4: RD = 32'b00000000100000000010000100000011; // lw x2 x0(8)
    32'd8: RD = 32'b00000000000100010000000110110011; //add x3, x2 x1
    32'd12: RD = 32'b00000000001100000010011000100011; //sw x3, (12)x0
    32'd16: RD = 32'b00000000001000001000001001100011; //BEQ x1, x2, +8
    32'd24: RD = 32'b00000000010000000010000010000011; // lw x1 x0(4)
//branch to 24th instruction at the 16th instr
endcase



always@(posedge CLK) begin 
if(!RST) begin 
PCF <= 0;
end

else begin
PCF <= PCF';
end
end

//A simple if-else statement is used which will decide PCNext = PCTarget or PCPlus4
always@(*) begin
case(PCSrcE)
    1'b0 : PCF' <= PCPlus4F;
    1'b1 : PCF' <= PCTargetE;
    default : PCF' <= PCPlus4F;
endcase
end

always@(*) begin
PCPlus4F = PCF + 4;
end


endmodule 
