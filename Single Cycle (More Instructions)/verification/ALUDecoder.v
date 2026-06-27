module ALUDecoder(

    input [1:0] ALUOp,
    input [6:0] opcode,
    input [2:0] funct3,
    input [6:0] funct7,
    output reg [2:0] ALUControl

);

always @(*) begin
    case(ALUOp)
    // lw, sw, addi
    2'b00:
        ALUControl = 3'b000;
    // beq, blt, bge
    2'b01:
        ALUControl = 3'b001;
    // R-type / I-type
    2'b10:
    begin
        case(funct3)
        3'b000:
        begin
            if(opcode == 7'b0010011)
                ALUControl = 3'b000;      // ADDI
            else if(funct7[5])
                ALUControl = 3'b001;      // SUB
            else
                ALUControl = 3'b000;      // ADD
        end
        3'b111:
            ALUControl = 3'b010;          // AND/ANDI
        3'b110:
            ALUControl = 3'b011;          // OR/ORI
        3'b100:
            ALUControl = 3'b100;          // XOR/XORI
        3'b001:
            ALUControl = 3'b101;          // SLL
        3'b101:
            ALUControl = 3'b110;          // SRL
        3'b010:
            ALUControl = 3'b111;          // SLT
        default:
            ALUControl = 3'b000;

        endcase

    end

    default:
        ALUControl = 3'b000;

    endcase

end

endmodule