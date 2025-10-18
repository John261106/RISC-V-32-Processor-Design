module BranchJump(
    input wire Branch,
    input wire Zero,
    output reg PCSrc
);

always @(*) begin
    PCSrc = Branch & Zero;
end

endmodule
