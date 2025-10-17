module BranchJump(
    input wire Branch,
    input wire Zero,
    output wire PCSrc
);

    assign PCSrc = Branch & Zero;

endmodule


//checked