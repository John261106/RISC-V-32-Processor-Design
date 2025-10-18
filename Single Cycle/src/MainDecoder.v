module MainDecoder(
input wire [6:0] op,
output reg [1:0] ResultSrc,
output reg MemWrite,
output reg [1:0] ALUOp,
output reg ALUSrc,
output reg [1:0] ImmSrc,
output reg RegWrite,
output reg Branch

);

always@(*) begin
//note : main decoder is designed to implemment lw,sw,beq
//main deocer just  depends on op
case (op)
        //lw
        7'b0000011 : begin
            RegWrite = 1'b1;
            ImmSrc = 2'b00;
            MemWrite = 1'b0;
            ALUOp = 2'b00;
            ALUSrc = 1'b1; //imm
            ResultSrc =1'b1; //write back
            Branch = 1'b0;
        end

        //sw
        7'b0100011  : begin
            RegWrite = 1'b0;
            ImmSrc = 2'b01;
            MemWrite = 1'b1;
            ALUOp = 2'b00;
            ALUSrc = 1'b1; //imm
            Branch = 1'b0;
        end

        // R-Type - ADD,OR,AND,SUB,LST
        7'b0110011 : begin
            RegWrite = 1'b1;
            MemWrite = 1'b0;
            ALUOp = 2'b10;
            Branch = 1'b0;
            ALUSrc = 1'b0; //reg2
            ResultSrc = 1'b0; //alu_result
        end

        //beq
        7'b1100011 : begin
            RegWrite = 1'b0;
            ImmSrc = 2'b10;
            ALUSrc = 1'b0;
            MemWrite = 1'b0;
            ALUOp = 2'b01;
            Branch = 1'b1;
        end

        end
    endcase
end


endmodule
