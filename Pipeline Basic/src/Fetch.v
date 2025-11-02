// following name from diagram

module Fetch(
input wire [1:0] PCSrcE,
input wire CLK,
input wire RST,
input wire[31:0] PCTargetE,
input wire[31:0] ALUResultE,
output reg [31:0] RD,
output reg [31:0] PCF,
output reg [31:0] PCPlus4F
);

reg [31:0] PCNextF;//reg since used in always block

always @(*) begin
    case (PCF[31:0])
            // Initialize registers
        32'd0:  RD = 32'b00000000010100000000000100010011; // addi x2, x0, 5    ; x2 = 5
        
        32'd4:  RD = 32'b00000000101000000000000110010011; // addi x3, x0, 10   ; x3 = 10
        // ADD test
        32'd8:  RD = 32'b00000000001100010000001000110011; // add x4, x2, x3    ; x4 = 15
        
        
        32'd12:  RD = 32'b00000000001100010000001000110011; // add x4, x2, x3    ; x4 = 15
        
        32'd16:  RD = 32'b00000000001100010000001000110011; // add x4, x2, x3    ; x4 = 15
         
        // BLT test (x2 < x3 → branch taken)
        32'd20: RD = 32'b00000000001100010100110001100011; // blt x2, x3, +12   ; PC -> PC + 24
        // Not executed if branch taken

	 default: RD = 32'bx;
    endcase

end

always@(posedge CLK) begin 
if(!RST) begin 
PCF <= 0;
end

else begin
PCF <= PCNextF;
end
end

//A simple if-else statement is used which will decide PCNext = PCTarget or PCPlus4
always@(*) begin
case(PCSrcE)
    2'b00 : PCNextF <= PCPlus4F;
    2'b01 : PCNextF <= PCTargetE;
    2'b10 : PCNextF <= ALUResultE;
    default : PCNextF <= PCPlus4F;
endcase
end

always@(*) begin
PCPlus4F = PCF + 4;
end


endmodule 
