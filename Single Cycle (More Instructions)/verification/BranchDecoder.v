module BranchDecoder(
    input wire [2:0] funct3,
    input wire [6:0] op,
    output reg [1:0] Cond_Src
);

always @(*) begin
    if (op == 7'b1100011) begin  // B-type instructions
        case (funct3)
            3'b000: BranchOp = 2'b00;  // BEQ - branch if zero
            3'b100: BranchOp = 2'b01;  // BLT - branch if negative
            3'b101: BranchOp = 2'b10;  // BGE - branch if non-negative
            default: BranchOp = 2'bxx;
        endcase
    end else begin
        BranchOp = 2'b00;  // Non-branch or unconditional (JAL/JALR)
    end
end

endmodule