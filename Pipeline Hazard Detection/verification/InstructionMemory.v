module InstructionMemory(
    input wire [31:0] A,
    output reg [31:0] RD
);

always @(*) begin
    case (A[31:0]) 
        32'd0: RD = 32'b00000000001000001000000110110011; // add x3, x1, x2
        32'd4: RD = 32'b01000000010000011000001010110011; // sub x5, x3, x4
        32'd8: RD = 32'b00000000011100011000001100110011; // add x6, x3, x7


    endcase
end

endmodule


//checked
