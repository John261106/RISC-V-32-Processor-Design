    module Extend(

        input wire [24:0] Imm,//Imm[31:7]
        input wire [1:0] ImmSrc,
        output reg [31:0] ImmExt
    );


    // For I type imm=Instr[31:20]
    // For S type imm=Instr[31:25,11:7]
    //For B type imm=Instr[31,30:25,11:8,7]

    always @(ImmSrc,Imm) begin
        case(ImmSrc)
        2'b00:ImmExt = {{20{Imm[24]}}, Imm[24:13]};//I 
        2'b01:ImmExt = {{20{Imm[24]}}, Imm[24:18], Imm[4:0]};//S
        2'b10:ImmExt = {{19{Imm[24]}}, Imm[24], Imm[0], Imm[23:18], Imm[4:1], 1'b0};//B
        default:ImmExt = 32'b0;
        endcase
    end
    endmodule
