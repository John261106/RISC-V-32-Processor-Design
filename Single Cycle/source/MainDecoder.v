module MainDecoder(
input wire [6:0] op,
output reg ResultSrc,
output reg MemWrite,
output reg [1:0] ALUOp,
output reg ALUSrc,
output reg [1:0] ImmSrc,
output reg RegWrite
);

always@(*) begin

case (op)
        // I-type (normal I-type)
        7'b0000011 : begin
            RegWrite = 1'b1;
            ImmSrc = 2'b00;
            MemWrite = 1'b0;
            ALUOp = 2'b00;
            ALUSrc = 1'b1; //imm
            ResultSrc =1'b1; //write back
        end

        // ALU I-type
        7'b0010011 : begin
            ImmSrc = 3'b000;
            ALUSrc = 1'b1; //imm
            MemWrite = 1'b0;
            ALUOp = 2'b10;
            ResultSrc = 2'b00; //alu_result

            // If we have a shift with a constant to handle, we have to invalidate writes for
            // instructions that does not have a well-formated immediate with "f7" and a 5bits shamt
            // ie :
            // - 7 upper bits are interpreted as a "f7", ony valid for a restricted slection tested below
            // - 5 lower as shamt (because max shift is 32bits and 2^5 = 32).
            if(func3 == F3_SLL)begin
                // slli only accept f7 7'b0000000
                RegWrite = (func7 == F7_SLL_SRL) ? 1'b1 : 1'b0;
            end
            else if(func3 == F3_SRL_SRA)begin
                // srli only accept f7 7'b0000000
                // srai only accept f7 7'b0100000
                RegWrite = (func7 == F7_SLL_SRL | func7 == F7_SRA) ? 1'b1 : 1'b0;
            end else begin
                RegWrite = 1'b1;
            end
        end
        // S-Type
        OPCODE_S_TYPE : begin
            RegWrite = 1'b0;
            ImmSrc = 3'b001;
            MemWrite = 1'b1;
            ALUOp = 2'b00;
            ALUSrc = 1'b1; //imm


        end
        // R-Type
        OPCODE_R_TYPE : begin
            RegWrite = 1'b1;
            MemWrite = 1'b0;
            ALUOp = 2'b10;
            ALUSrc = 1'b0; //reg2
            ResultSrc = 2'b00; //alu_result


        end
        // B-type
        OPCODE_B_TYPE : begin
            RegWrite = 1'b0;
            ImmSrc = 3'b010;
            ALUSrc = 1'b0;
            MemWrite = 1'b0;
            ALUOp = 2'b01;


            second_add_source = 2'b00;
        end
        // J-type + JALR weird Hybrib
        OPCODE_J_TYPE, OPCODE_J_TYPE_JALR : begin
            RegWrite = 1'b1;
            ImmSrc = 3'b011;
            MemWrite = 1'b0;
            ResultSrc = 2'b10; //pc_+4


            if(op[3]) begin// jal
                second_add_source = 2'b00;
                ImmSrc = 3'b011;
            end
            else if (~op[3]) begin // jalr
                second_add_source = 2'b10;
                ImmSrc = 3'b000;
            end
        end
        // U-type
        OPCODE_U_TYPE_LUI, OPCODE_U_TYPE_AUIPC : begin
            ImmSrc = 3'b100;
            MemWrite = 1'b0;
            RegWrite = 1'b1;
            ResultSrc = 2'b11;


            case(op[5])
                1'b1 : second_add_source = 2'b01; // lui
                1'b0 : second_add_source = 2'b00; // auipc
            endcase
        end
        // EVERYTHING ELSE
        default: begin
            // Don't touch the CPU nor MEMORY state
            RegWrite = 1'b0;
            MemWrite = 1'b0;
        end
    endcase
end






endmodule
