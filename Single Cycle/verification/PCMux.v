//MUX module for PC
module PCMux(
input wire PCSrc,
input wire [31:0] PCPlus4,
input wire [31:0] PCTarget,
output reg [31:0] PCNext

);

//A simple if-else statement is used which will decide PCNext = PCTarget or PCPlus4
always@(*) begin
case(PCSrc)
    1'b0 : PCNext <= PCPlus4;
    1'b1 : PCNext <= PCTarget;
    default : PCNext <= PCPlus4;
endcase
end


endmodule


