module BranchJump(
    input wire Branch,
    input wire Zero,
    input wire Negative,
    input wire[1:0] Cond_Src,
    output reg PCSrc
);

always @(*) begin
    case(Cond_Src)
        2'b00: PCSrc=Branch & Zero;//beq
        2'b01: PCSrc=Branch & Negative;//blt
        2'b10: PCSrc=Branch & (~Negative);//bge
        2'b11: PCSrc=1;// for jalr and jal its always 1
    endcase
end

endmodule
