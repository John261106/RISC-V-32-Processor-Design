module BranchDecoder(
    input wire [2:0] funct3,
    input wire [6:0] op,
    output reg [1:0] Cond_Src
);

always @(*) begin
    if (op == 7'b1100011) begin  // B-type instructions
        case (funct3)
            3'b000: Cond_Src = 2'b00;  // BEQ - branch if zero
            3'b100: Cond_Src = 2'b01;  // BLT - branch if negative
            3'b101: Cond_Src = 2'b10;  // BGE - branch if non-negative
            default: Cond_Src = 2'bxx;
        endcase
    end else begin
        Cond_Src = 2'b00;  // Non-branch or unconditional (JAL/JALR)
    end
end

endmodule