module BranchJump(
    input wire Branch,
    input wire Zero,
    input wire Negative,
    input wire[2:0] Cond_Src,
    output reg [1:0]PCSrc
);

always @(*) begin
    case(Cond_Src)
        3'b000: PCSrc=(Branch & Zero)? 2'b01:2'b00;//beq
        3'b001: PCSrc=(Branch & Negative) ? 2'b01:2'b00;//blt
        3'b010: PCSrc=(Branch & (~Negative)) ? 2'b01:2'b00;//bge
        3'b011: PCSrc=2'b01;// for jal
        3'b100: PCSrc=2'b10;//for jalr
        default: PCSrc=2'b00;
    endcase
end

endmodule
