module InstructionMemory(
    input wire [31:0] A,
    output reg [31:0] RD
);

always @(*) begin
    case (A)

        // x1 = 5
        32'd0  : RD = 32'b00000000010100000000000010010011; // addi x1,x0,5
                                 
        // x2 = 10
        32'd4  : RD = 32'b00000000101000000000000100010011; // addi x2,x0,10

        // if(x1<x2) jump to PC=16
        32'd8  : RD = 32'b00000000001000001100010001100011; // blt x1,x2,+8

        // should be skipped
        32'd12 : RD = 32'b00000110001100000000000110010011; // addi x3,x0,99

        // if(x2>=x1) jump to PC=24
        32'd16 : RD = 32'b00000000000100010101010001100011; // bge x2,x1,+8

        // should be skipped
        32'd20 : RD = 32'b00000101100000000000001000010011; // addi x4,x0,88

        // always taken
        32'd24 : RD = 32'b00000000000100001000010001100011; // beq x1,x1,+8

        // should be skipped
        32'd28 : RD = 32'b00000100110100000000001010010011; // addi x5,x0,77

        // jump to PC=40, x6 = 36
        32'd32 : RD = 32'b00000000100000000000001101101111; // jal x6,+8

        // skipped
        32'd36 : RD = 32'b00000100001000000000001110010011; // addi x7,x0,66

        // x8 = 48
        32'd40 : RD = 32'b00000011000000000000010000010011; // addi x8,x0,48

        // jump to x8+0 (=48), x9=48
        32'd44 : RD = 32'b00000000000001000000010011100111; // jalr x9,0(x8)

        // final instruction
        32'd48 : RD = 32'b00000111101100000000010100010011; // addi x10,x0,123


        default : RD = 32'h00000013; // nop

    endcase
end

endmodule