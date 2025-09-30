//verilog code for instruction memory
module InstructionMemory(
input wire [31:0] A,
output reg [31:0] RD
);

//hardcode case statements to write the instructions
/*
always @(*) begin
    case (A)
        4'b0000 : RD <= 32'b10010010;
        4'b0100 : RD <= INSTR1;
        4'b0010 : RD <= INSTR2;
        4'b0011 : RD <= INSTR3;
        4'b0100 : RD <= INSTR4;
        4'b0101 : RD <= INSTR5;
        4'b0110 : RD <= INSTR6;
        4'b0111 : RD <= INSTR7;
        4'b1000 : RD <= INSTR8;
        4'b1001 : RD <= INSTR9;
        4'b1010 : RD <= INSTR10;
        4'b1011 : RD <= INSTR11;
        4'b1100 : RD <= INSTR12;
        4'b1101 : RD <= INSTR13;
        4'b1110 : RD <= INSTR14;
        4'b1111 : RD <= INSTR15;
        default : RD <= 0;
    endcase
end
*/

//the above always black assumes that the user writes the program instructions in this module in the place of INSTR0, INSTR1,...


endmodule
