module BranchDecoder(
    input wire [2:0] funct3,
    input wire [6:0] op,
    output reg [1:0] Cond_Src
);

always @(*) begin
    if (op == 7'b1100011) begin  // B-type instructions (conditional branches)
        case (funct3)
            3'b000: Cond_Src = 2'b00;  // BEQ - branch if zero
            3'b100: Cond_Src = 2'b01;  // BLT - branch if negative
            3'b101: Cond_Src = 2'b10;  // BGE - branch if non-negative
            default: Cond_Src = 2'bxx;
        endcase
    end else if (op == 7'b1101111 || op == 7'b1100111) begin
        // JAL (1101111) or JALR (1100111) - unconditional jumps
        Cond_Src = 2'b11;  // Encoding for unconditional jumps
    end else begin
        Cond_Src = 2'b00;
    end
end

endmodule