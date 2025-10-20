module InstructionMemory(
    input wire [31:0] A,
    output reg [31:0] RD
);

always @(*) begin
    case (A[31:0])
        // Initialize registers
        32'd0:  RD = 32'b00000000010100000000000100010011; // addi x2, x0, 5    ; x2 = 5
        32'd4:  RD = 32'b00000000101000000000000110010011; // addi x3, x0, 10   ; x3 = 10
        // ADD test
        32'd8:  RD = 32'b00000000001100010000001000110011; // add x4, x2, x3    ; x4 = 15
        // BLT test (x2 < x3 → branch taken)
        // branch from PC=12 to PC=24 (+12 offset)
        32'd12: RD = 32'b00000000001100010100011001100011; // blt x2, x3, +12   ; if taken → PC=24
        // Not executed if branch taken
        32'd16: RD = 32'b00000000000100100000001010010011; // addi x5, x4, 1    ; skipped if blt works
        // Branch target (PC=24)
        32'd24: RD = 32'b00000000001000100000001100010011; // addi x6, x4, 2    ; executes after branch
        // JAL test (jump to PC=40)
        32'd28: RD = 32'b00000000110000000000010011101111; // jal x9, +12       ; x9 = PC+4, PC=40
        // Not executed if jump works
        32'd32: RD = 32'b00000000111100110000010100010011; // addi x10, x6, 15  ; skipped if jal works
        // Jump target (PC=40)
        32'd40: RD = 32'b00000000001001000000010110010011; // addi x11, x8, 2   ; executes after jal
        // ADD final test
        32'd44: RD = 32'b00000000101101000000011000110011; // add x12, x8, x11  ; final add
        default: RD = 32'bx;
    endcase

end

endmodule