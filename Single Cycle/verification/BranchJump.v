module BranchJump(
    input wire Branch,
    input wire Zero,
    output reg PCSrc
);

    PCSrc = Branch & Zero;

endmodule


//checked