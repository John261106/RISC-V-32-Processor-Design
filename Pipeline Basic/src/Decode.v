module Decode(
//INPUT wires
input wire [6:0] op,
input wire [2:0] funct3,
input wire [6:0] funct7,
input wire CLK,
input wire RST, //active-low reset synchronous
input wire WE3,
input wire [4:0] A1,
input wire [4:0] A2,
input wire [4:0] A3,//need to connect to RdW
input wire [24:0] Imm,
input wire [31:0] WD3, // need to connect it to ResultW
input wire [4:0] Rd11_7, // this will be Instr[11:7]
//OUTPUT registers
output reg RegWriteD,
output reg [1:0] ResultSrcD, //NOTE : WE NEED ONE BIT ONLY UNLIKE TB PIC BECUASE JUST 2 CASES IN MUX
output reg MemWriteD,
output reg [2:0]Cond_SrcD,
output reg [2:0] ALUControlD,
output reg ALUSrcD,
output reg [31:0] RD1,   //following book notation
output reg [31:0] RD2,	 //following book notation
output reg [31:0] ImmExtD,
output reg [4:0] RdD
);


reg [1:0]ImmSrcD;
reg [31:0] x [31:0];  // 32 registers, each 32 bits wide
integer i;


always@(*) begin
    //main decoder just depends on op
    case (op)
        //lw
        7'b0000011 : begin
            RegWriteD = 1'b1;
            ImmSrcD = 2'b00;
            MemWriteD = 1'b0;
            ALUSrcD = 1'b1; //imm
            ResultSrcD = 2'b01; //write back
            Cond_SrcD = 3'bxxx;
            //KING LORD WORD USES ALL THE CONTROLS :) hehe
        end
        //sw
        7'b0100011 : begin
            RegWriteD = 1'b0;
            ImmSrcD = 2'b01;
            MemWriteD = 1'b1;
            ALUSrcD = 1'b1; //imm
            ResultSrcD = 2'bxx;
            Cond_SrcD = 3'bxxx;
            //ResultSrc = 2'bxx are we supposed to do like this or just leave
        end
        // R-Type - ADD,OR,AND,SUB,SLT
        7'b0110011 : begin
            RegWriteD = 1'b1;
            MemWriteD = 1'b0;
            ALUSrcD = 1'b0; //reg2
            ResultSrcD = 2'b00; //alu_result
            ImmSrcD = 2'bxx;
            Cond_SrcD = 3'bxxx;
            //ImmSrc = 2'bxx are we supposed to do like this or just leave
        end
        // I-Type ALU instructions
        7'b0010011: begin 
            RegWriteD = 1'b1;
            MemWriteD = 1'b0;
            ALUSrcD = 1'b1;
            ResultSrcD = 2'b00;
            ImmSrcD = 2'b00;
            Cond_SrcD = 3'bxxx;
        end
        //jal instruction
        7'b1101111: begin
            RegWriteD = 1'b1;
            MemWriteD = 1'b0;
            ALUSrcD = 1'bx;
            ResultSrcD = 2'b10;
            ImmSrcD = 2'b11;
            Cond_SrcD = 3'b011;
        end
        //need to add jalr instruction //hardware modification needed
        //jalr instruction
        7'b1100111: begin
            RegWriteD = 1'b1;
            MemWriteD = 1'b0;
            ALUSrcD = 1'b1;
            ResultSrcD = 2'b10;
            ImmSrcD = 2'b00;
            Cond_SrcD = 3'b100;
        end
        //branch type
        7'b1100011 : begin
            RegWriteD = 1'b0;
            ImmSrcD = 2'b10;
            ALUSrcD = 1'b0;
            MemWriteD = 1'b0;
            ResultSrcD = 2'bxx;
            
            // Decode branch condition based on funct3
            case (funct3)
                3'b000: Cond_SrcD = 3'b000; // BEQ - branch if equal
                3'b100: Cond_SrcD = 3'b001; // BLT - branch if less than (signed)
                3'b101: Cond_SrcD = 3'b010; // BGE - branch if greater or equal (signed)
                default: Cond_SrcD = 3'bxxx;
            endcase
            //ResultSrc = 2'bxx are we supposed to do like this or just leave
        end
        
        default: begin
            RegWriteD = 1'bx;
            ImmSrcD = 2'bxx;
            MemWriteD = 1'bx;
            ALUSrcD = 1'bx;
            ResultSrcD = 2'bxx;
            Cond_SrcD = 3'bxxx;
        end
    endcase
end


always @(*) begin
    casez ({op, funct3, funct7}) // casez allows ?/x as wildcards

        // ---------------- R-type Instructions ----------------
        17'b0110011_000_0000000: ALUControlD = 3'b000; // ADD
        17'b0110011_000_0100000: ALUControlD = 3'b001; // SUB
        17'b0110011_100_0000000: ALUControlD = 3'b010; // XOR
        17'b0110011_110_0000000: ALUControlD = 3'b011; // OR
        17'b0110011_111_0000000: ALUControlD = 3'b111; // AND
        17'b0110011_001_0000000: ALUControlD = 3'b100; // SLL
        17'b0110011_101_0000000: ALUControlD = 3'b110; // SRL
	    17'b0110011_010_0000000: ALUControlD = 3'b101;  // SLT
	
        // ---------------- B-type Instructions ----------------
        17'b1100011_000_???????: ALUControlD = 3'b001; // SUB used for beq
        17'b1100011_100_???????: ALUControlD = 3'b001; // SUB used for blt
        17'b1100011_101_???????: ALUControlD = 3'b001; // SUB used for bge
        
        // ---------------- I-type Instructions ----------------
        17'b0010011_000_???????: ALUControlD = 3'b000; // ADDI
        17'b0010011_100_???????: ALUControlD = 3'b010; // XORI
        17'b0010011_110_???????: ALUControlD = 3'b011; // ORI
        17'b0010011_111_???????: ALUControlD = 3'b111; // ANDI
        17'b1100111_000_???????: ALUControlD = 3'b000; // ADD used for jalr

        //------------------lw and sw-----------------------------------
        17'b0000011_010_???????: ALUControlD = 3'b000; // ADD used for LW
        17'b0100011_010_???????: ALUControlD = 3'b000; // ADD used for SW
        // ------------------------------------------------------

        //------------------jalr------------------------------------------
        17'b1100111_000_???????: ALUControlD = 3'b000;//add used for pc=rs1+imm;
        default: ALUControlD = 3'bxxx; // Undefined operation

    endcase
end


 always @(*) begin
    	RD1 = (A1 == 5'd0) ? 32'b0 : x[A1];
    	RD2 = (A2 == 5'd0) ? 32'b0 : x[A2];
    end

    
    always @ (posedge CLK) begin
        if (!RST) begin
            //On RST all register set to 32'b0
            for (i = 0; i < 32; i = i + 1) begin
            x[i] <= 32'b0;
            end
        end 
        else if (WE3 && (A3 != 5'd0)) begin
            //Write only if not register 0
            x[A3] <= WD3;
        end
    end




    always @(*) begin
        case (ImmSrcD)
            // I-type
            2'b00: ImmExtD = {{20{Imm[24]}}, Imm[24:13]}; 

            // S-type
            2'b01: ImmExtD = {{20{Imm[24]}}, Imm[24:18], Imm[4:0]};

            // B-type
            2'b10: ImmExtD = {{19{Imm[24]}}, Imm[0], Imm[23:18], Imm[4:1], 1'b0};

            // J-type 
            2'b11: ImmExtD = {{11{Imm[24]}}, Imm[24], Imm[12:5], Imm[13], Imm[23:14], 1'b0};


            default: ImmExtD = 32'bx;
        endcase
    end
always @(*) begin
 RdD=Rd11_7;

end


endmodule


