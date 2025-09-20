//ALU
module ALU(
input wire [31:0] SrcA,
input wire [31:0] SrcB,
input wire [2:0] ALUControl,
output reg [31:0] ALUResult,
output reg Zero
);

always@(*) begin
//for ALU control unit
if(ALUResult == 32'b0 ) begin
Zero = 1;
end

else begin
Zero = 0;
end

case(ALUControl)
    3'b000 : ALUResult = SrcA + SrcB;
    3'b001 : ALUResult = SrcA - SrcB;
    3'b111 : ALUResult = SrcA & SrcB;
    3'b011 : ALUResult = SrcA | SrcB;
    3'b101 : ALUResult = (SrcA < SrcB) ? 1 : 0
    //credits to vighnesh for this mind blowing ass instruction
    default : ALUResult = SrcA + SrcB;
    //should we put default as zero ?
endcase


end



endmodule
