module Extend(
    input wire [24:0] Imm,
    input wire [1:0] ImmSrc,
    output reg [31:0] ImmExt
);

    // For I type: imm = Instr[31:20]
    // For S type: imm = Instr[31:25,11:7]
    // For B type: imm = Instr[31,7,30:25,11:8]

    always @(*) begin
        case (ImmSrc)
            // I-type: {sign bits, bits[31:20]}
            2'b00: ImmExt = {{20{Imm[24]}}, Imm[24:13]}; 

            // S-type: {sign bits, bits[31:25], bits[11:7]}
            2'b01: ImmExt = {{20{Imm[24]}}, Imm[24:18], Imm[4:0]};

            // B-type: {sign bits, bits[31], bits[7], bits[30:25], bits[11:8], 0}
            2'b10: ImmExt = {{19{Imm[24]}}, Imm[0], Imm[23:18], Imm[4:1], 1'b0};

            default: ImmExt = 32'b0;
        endcase
    end
endmodule

//changed john's code by declaring RD instead of using Imm to avoid confusion in topmodule
// declaration of instruction memory instantiation causing problems 
// so made an wire Imm which is Instr[31:7]


//checked