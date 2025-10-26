module InstructionMemory(
    input wire [31:0] A,
    output reg [31:0] RD
);

always @(*) begin
    case (A[31:0])
        // Prepare base address: x2 = 16 (target address)
        32'd0:  RD = 32'b00000001000000000000000100010011; // addi x2, x0, 16   ; x2 = 16
        
        // JALR: Jump to x2 + 0 = 16, save return address (8) in x3
        32'd4:  RD = 32'b00000000000000010000000111100111; // jalr x3, 0(x2)    ; x3=8, PC=16
        
        // This should be skipped (not executed)
        32'd8:  RD = 32'b11111111111111111111010010010011; // addi x9, x15, -1  ; skipped
        
        // Jump target (PC=16): Verify x3 has return address (8) by adding to x4
        32'd16: RD = 32'b00000000000000011000001000110011; // add x4, x3, x0    ; x4 = 8 (verifies x3=8)
        
        default: RD = 32'h00000013; // NOP
    endcase
end

endmodule