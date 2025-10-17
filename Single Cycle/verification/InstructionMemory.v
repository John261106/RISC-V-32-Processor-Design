module InstructionMemory(
    input wire [31:0] A,
    output reg [31:0] RD
);

always @(*) begin
    case (A[31:2])  // Use upper 30 bits (ignore lower 2 bits for word alignment)
        30'h0: RD = 32'h00108133; // add x2, x1, x1
        30'h1: RD = 32'h0020A023; // sw x2, 0(x1)
        default: RD = 32'h00000013;
    endcase
end

endmodule


//checked