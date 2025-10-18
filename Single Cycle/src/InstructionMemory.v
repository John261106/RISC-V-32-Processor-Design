module InstructionMemory(
    input wire [31:0] A,
    output reg [31:0] RD
);

always @(*) begin
    case (A[31:0]) 
        32'd0: RD = 32'b00000000010000000010000010000011; // lw x1 x0(4)
        32'd4: RD = 32'b00000000100000000010000100000011; // lw x2 x0(8)
        32'd8: RD = 32'b00000000000100010000000110110011; //add x3, x2 x1
        32'd12: RD = 32'b00000000001100000010011000100011; //sw x3, (12)x0
        32'd16: RD = 32'b00000000001000001000001001100011; //BEQ x1, x2, +8
        32'd24: RD = 32'b00000000010000000010000010000011; // lw x1 x0(4)

        //branch to 24th instruction at the 16th instr

    endcase
end

endmodule


//checked
