module Extend(
input wire [1:0] ImmSrc,
output reg [31:0] ImmExt
);


    // For I type imm=Instr[31:20]
    // For S type imm=Instr[31:25,11:7]
    //For B type imm=Instr[31,30:25,11:8,7]
    wire RD[31:0];

    InstructionMemory IMInst(
    .RD(RD)
    );

        always @(*) begin
        case(ImmSrc)
        2'b00:ImmExt = {{20{RD[31]}}, RD[31:20]};//I
        2'b01:ImmExt = {{20{RD[31]}}, RD[31:25], RD[11:7]};//S
        2'b10:ImmExt = {{20{RD[31]}}, RD[7],RD[30:25], RD[11:8], 1'b0};//B
        default:ImmExt = 32'b0;
        endcase
    end
    endmodule

//changed john's code by declaring RD instead of using Imm to avoid confusion in topmodule
