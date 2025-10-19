module MainDecoder(
input wire [6:0] op,
output reg[1:0] ResultSrc,//result src will become 2 bits to accomodate jal instruction
output reg MemWrite,
output reg [1:0] ALUOp,
output reg ALUSrc,
output reg [1:0] ImmSrc,
output reg RegWrite,
output reg Branch

);

always@(*) begin
//main deocer just  depends on op
case (op)
        //lw
        7'b0000011 : begin
            RegWrite = 1'b1;
            ImmSrc = 2'b00;
            MemWrite = 1'b0;
            ALUOp = 2'b00;
            ALUSrc = 1'b1; //imm
            ResultSrc =2'b01; //write back
            Branch = 1'b0;
            //KING LORD WORD USES ALL THE CONTROLS :) hehe
        end

        //sw
        7'b0100011  : begin
            RegWrite = 1'b0;
            ImmSrc = 2'b01;
            MemWrite = 1'b1;
            ALUOp = 2'b00;
            ALUSrc = 1'b1; //imm
            Branch = 1'b0;
            ResultSrc=2'bxx;
            //ResultSrc = 2'bxx are we supposed to do like this or just leave
        end

        // R-Type - ADD,OR,AND,SUB,LST
        7'b0110011 : begin
            RegWrite = 1'b1;
            MemWrite = 1'b0;
            ALUOp = 2'b10;
            Branch = 1'b0;
            ALUSrc = 1'b0; //reg2
            ResultSrc = 2'b00; //alu_result
            ImmSrc=2'bxx;
            //ImmSrc = 2'bxx are we supposed to do like this or just leave
        end

        // I-Type ALU instructions
        7'b0010011: begin 
            RegWrite =1b'1;
            MemWrite =1'b0;
            ALUOp =2'b10; //doesnt matter becuase we modified the ALU decoder will see about this later
            Branch =1'b0;
            ALUSrc =1'b1;
            ResultSrc=2'b00;
            ImmSrc= 2'b00;
        end


        //jal instruction
        7'b1101111: begin
            RegWrite=1'b1;
            MemWrite=1'b0;
            ALUOp =2'b11 //doesnt matter because of the same reason
            Branch = 1'b1;
            ALUSrc= 1'b1;
            ResultSrc =2'b10;
        end

        //need to add jalr instruction //hardware modification needed


        //beq
        7'b1100011 : begin
            RegWrite = 1'b0;
            ImmSrc = 2'b10;
            ALUSrc = 1'b0;
            MemWrite = 1'b0;
            ALUOp = 2'b01;
            Branch = 1'b1;
            ResultSrc=2'bxx;
            //ResultSrc = 2'bxx are we supposed to do like this or just leave
        end

    endcase
end


endmodule
