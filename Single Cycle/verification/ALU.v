module ALU(
    input wire [31:0] SrcA,
    input wire [31:0] SrcB,
    input wire [2:0] ALUControl,
    output reg [31:0] ALUResult,
    output reg Zero
);

always @(*) begin
    case(ALUControl)
        3'b000 : ALUResult = SrcA + SrcB;
        3'b001 : ALUResult = SrcA - SrcB;
        3'b111 : ALUResult = SrcA & SrcB;
        3'b011 : ALUResult = SrcA | SrcB;
        3'b101 : ALUResult = (SrcA < SrcB) ? 1 : 0;
        default : ALUResult = 32'b0;
	// deafult case is zero
    endcase

    
    Zero = (ALUResult == 32'b0) ? 1 : 0;
end

endmodule

//checked
