module ALU(
    input wire [31:0] SrcA,
    input wire [31:0] SrcB,
    input wire [2:0] ALUControl,
    output reg [31:0] ALUResult,
    output reg Zero,
    output reg Negative
);

always @(*) begin
    case(ALUControl)
        3'b000 : ALUResult = SrcA + SrcB;                              // ADD
        3'b001 : ALUResult = SrcA - SrcB;                              // SUB
        3'b111 : ALUResult = SrcA & SrcB;                              // AND
        3'b011 : ALUResult = SrcA | SrcB;                              // OR
        3'b101 : ALUResult = ($signed(SrcA) < $signed(SrcB)) ? 1 : 0;  // SLT (signed)
        3'b100 : ALUResult = SrcA << SrcB[4:0];                        // SLL(only need to take 4:) since there are only 32 bits
        3'b110 : ALUResult = SrcA >> SrcB[4:0];                        // SRL (logical)
        3'b010 : ALUResult = SrcA ^ SrcB;                              // XOR
        default : ALUResult = 32'bx;
    endcase

    Zero = (ALUResult == 32'b0);
    Negative = ALUResult[31];
end

endmodule