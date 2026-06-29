module InstructionMemory(
    input wire [31:0] A,
    output reg [31:0] RD
);

always @(*) begin
    case (A[31:0]) 
        32'd0: RD = 32'b00000000000000001010000100000011; // lw x2, 0(x1)
        32'd4: RD = 32'b00000000010000010000000110110011; // add x3, x2, x4
        32'd8: RD = 32'b01000000011000011000001010110011; // sub x5, x3, x6
        32'd12: RD = 32'b00000000010000101111001110110011; // and x7, x5, x4
        


    endcase
end

endmodule


//checked
