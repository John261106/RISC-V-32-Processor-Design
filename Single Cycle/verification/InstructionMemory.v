module InstructionMemory(
    input wire [31:0] A,
    output reg [31:0] RD
);

always @(*) begin
    case (A[31:0]) 
        32'h0: RD = 32'b11111111110001001010001100000011; // add x2, x1, x1
    endcase
end

endmodule


//checked
