//MUX module for PC
module PCMux(
input wire [1:0]PCSrc,
input wire [31:0] PCPlus4,
input wire [31:0] PCTarget,
input wire [31:0] ALUResult,
output reg [31:0] PCNext

);

//A simple if-else statement is used which will decide PCNext = PCTarget or PCPlus4
always@(*) begin
case(PCSrc)
    2'b00 : PCNext <= PCPlus4;
    2'b01 : PCNext <= PCTarget;
    2'b10: PCNext <=ALUResult;
    default : PCNext <= PCPlus4;
endcase
end


endmodule


//checked