module ALUDecoder(
input wire [2:0] funct3,
input wire [6:0] funct7,
input wire [6:0] op,
input wire [1:0] ALUOp,
output reg [2:0] ALUControl
);

//supports lw,sw,beq,add,sub,slt,or,and
//blindly followed DDCA Harris and Harris

always @(*) begin
    case (ALUOp)
        2'b00: ALUControl = 3'b000; //add
        2'b01: ALUControl = 3'b001; //sub
        2'b10: begin
            case (funct3)
                3'b000: begin
                //shall we use casex or casez ? casex is not synthesizable; casez is synthesizable
                case ({op[5], funct7[5]}) //check if it is funct7[5] or is it otherway
                    2'b00 : ALUControl = 3'b000; //add
                    2'b01 : ALUControl = 3'b000; //add
                    2'b10 : ALUControl = 3'b000; //add
                    2'b11 : ALUControl = 3'b001; //sub
                endcase
                end

                3'b010: ALUControl = 3'b101; //set less than
                3'b110: ALUControl = 3'b011; //or
                3'b111: ALUControl = 3'b010; //and
                default: ALUControl = 3'b000;
            endcase
        end
        default: ALUControl = 3'b000;
    endcase
end
endmodule
