module ALUDecoder(
input wire [2:0] funct3,
input wire [6:0] funct7,
input wire [6:0] op,
input wire [1:0] ALUOp,
output reg [2:0] ALUControl
);

//supports lw,sw,beq,add,sub,slt,or,and
//followed the official RISC V card and did this, may seem use of huge hardware but fine

always @(*) begin
    casez ({op, funct3, funct7}) // casez allows ?/x as wildcards

        // ---------------- R-type Instructions ----------------
        17'b0110011_000_0000000: ALUControl = 3'b000; // ADD
        17'b0110011_000_0100000: ALUControl = 3'b001; // SUB
        17'b0110011_100_0000000: ALUControl = 3'b010; // XOR
        17'b0110011_110_0000000: ALUControl = 3'b011; // OR
        17'b0110011_111_0000000: ALUControl = 3'b111; // AND
        17'b0110011_001_0000000: ALUControl = 3'b100; // SLL
        17'b0110011_101_0000000: ALUControl = 3'b110; // SRL
	    17'b0110011_010_0000000: ALUControl = 3'b101;  // SLT
	
        // ---------------- B-type Instructions ----------------
        17'b1100011_000_???????: ALUControl = 3'b001; // SUB used for beq
        17'b1100011_100_???????: ALUControl = 3'b001; // SUB used for blt
        17'b1100011_101_???????: ALUControl = 3'b001; // SUB used for bge
        
        // ---------------- I-type Instructions ----------------
        17'b0010011_000_???????: ALUControl = 3'b000; // ADDI
        17'b0010011_100_???????: ALUControl = 3'b010; // XORI
        17'b0010011_110_???????: ALUControl = 3'b011; // ORI
        17'b0010011_111_???????: ALUControl = 3'b100; // ANDI
        17'b1100111_000_???????: ALUControl = 3'b000; // ADD used for jalr

        //------------------lw and sw-----------------------------------
        17'b0000011_010_???????: ALUControl = 3'b000; // ADD used for LW
        17'b0100011_010_???????: ALUControl = 3'b000; // ADD used for SW
        // ------------------------------------------------------
        default: ALUControl = 3'bxxx; // Undefined operation

    endcase
end


endmodule
