module Extend(
    input wire [24:0] Imm,
    input wire [1:0] ImmSrc,
    output reg [31:0] ImmExt
);

    // For I type: imm = Instr[31:20]
    // For S type: imm = Instr[31:25,11:7]
    // For B type: imm = Instr[31,7,30:25,11:8]
    // For J type: imm = Instr[31,19:12,20,30:21,0]

    always @(*) begin
        case (ImmSrc)
            // I-type
            2'b00: ImmExt = {{20{Imm[24]}}, Imm[24:13]}; 

            // S-type
            2'b01: ImmExt = {{20{Imm[24]}}, Imm[24:18], Imm[4:0]};

            // B-type
            2'b10: ImmExt = {{19{Imm[24]}}, Imm[0], Imm[23:18], Imm[4:1], 1'b0};

            // J-type 
            2'b11: ImmExt = {{11{Imm[24]}}, Imm[24], Imm[12:5], Imm[13], Imm[23:14], 1'b0};


            default: ImmExt = 32'bx;
        endcase
    end
endmodule

//changed john's code by declaring RD instead of using Imm to avoid confusion in topmodule
// declaration of instruction memory instantiation causing problems 
// so made an wire Imm which is Instr[31:7]


//checked