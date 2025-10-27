module Decode(
//INPUT wires
input wire [6:0] op
input wire [2:0] funct3,
input wire [6:0] funct7,
input wire CLK,
input wire RST, //active-low reset synchronous
input wire WE3,
input wire [4:0] A1,
input wire [4:0] A2,
input wire [4:0] A3,//need to connect to RdW
input wire [31:0] WD3,
input wire [24:0] Imm,
input wire [31:0] WD3 // need to connect it to ResultW
input wire [4:0] Rd11_7 // this will be Instr[11:7]
//OUTPUT registers
output reg RegWriteD,
output reg ResultSrcD, //NOTE : WE NEED ONE BIT ONLY UNLIKE TB PIC BECUASE JUST 2 CASES IN MUX
output reg MemWriteD,
output reg BranchD,
output reg [2:0] ALUControlD;
output reg ALUSrcD,
output reg [31:0] RD1,   //following book notation
output reg [31:0] RD2,	 //following book notation
output reg [31:0] ImmExtD,
output reg [4:0] RdD
);


//DECLARE WHATEVER INTERMEDIATE WIRES ARE INVOLVED IN THE MODULE HERE
reg [1:0] ImmSrcD;
reg [1:0] ALUOp;

always@(*) begin
//note : main decoder is designed to implemment lw,sw,beq
//main deocer just  depends on op
case (op)
        //lw
        7'b0000011 : begin
            RegWriteD = 1'b1;
            ImmSrcD = 2'b00;
            MemWriteD = 1'b0;
            ALUOp = 2'b00;
            ALUSrcD = 1'b1; //imm
            ResultSrcD =1'b1; //write back
            BranchD = 1'b0;           
        end

        //sw
        7'b0100011  : begin
            RegWriteD = 1'b0;
            ImmSrcD = 2'b01;
            MemWriteD = 1'b1;
            ALUOp = 2'b00;
            ALUSrcD = 1'b1; //imm
            BranchD = 1'b0;
            ResultSrcD = 1'bx;
        end

        // R-Type - ADD,OR,AND,SUB,LST
        7'b0110011 : begin
            RegWriteD = 1'b1;
            MemWriteD = 1'b0;
            ALUOp = 2'b10;
            BranchD = 1'b0;
            ALUSrcD 1'b0; //reg2
            ResultSrcD = 1'b0; //alu_result
            ImmSrcD = 2'bxx;
        end

        //beq
        7'b1100011 : begin
            RegWriteD = 1'b0;
            ImmSrcD = 2'b10;
            ALUSrcD = 1'b0;
            MemWriteD = 1'b0;
            ALUOp = 2'b01;
            BranchD = 1'b1;
            ResultSrcD = 1'bx;
        end

    endcase
end

always @(*) begin
    case (ALUOp)
        2'b00: ALUControlD = 3'b000; //add
        2'b01: ALUControlD = 3'b001; //sub
        2'b10: begin
            case (funct3)
                3'b000: begin
                //shall we use casex or casez ? casex is not synthesizable; casez is synthesizable
                case ({op[5], funct7[5]}) //check if it is funct7[5] or is it otherway
                    2'b00 : ALUControlD = 3'b000; //add
                    2'b01 : ALUControlD = 3'b000; //add
                    2'b10 : ALUControlD = 3'b000; //add
                    2'b11 : ALUControlD = 3'b001; //sub
                endcase
                end

                3'b010: ALUControlD = 3'b101; //set less than
                3'b110: ALUControlD = 3'b011; //or
                3'b111: ALUControlD = 3'b010; //and
                default: ALUControlD = 3'b000;
            endcase
        end
        default: ALUControlD = 3'bxxx;
    endcase
end

    // For I type: imm = Instr[31:20]
    // For S type: imm = Instr[31:25,11:7]
    // For B type: imm = Instr[31,7,30:25,11:8]

    always @(*) begin
        case (ImmSrcD)
            // I-type: {sign bits, bits[31:20]}
            2'b00: ImmExtD = {{20{Imm[24]}}, Imm[24:13]}; 

            // S-type: {sign bits, bits[31:25], bits[11:7]}
            2'b01: ImmExtD = {{20{Imm[24]}}, Imm[24:18], Imm[4:0]};

            // B-type: {sign bits, bits[31], bits[7], bits[30:25], bits[11:8], 0}
            2'b10: ImmExtD = {{19{Imm[24]}}, Imm[0], Imm[23:18], Imm[4:1], 1'b0};

            default: ImmExtD = 32'bx;
        endcase
    end

    reg [31:0] x [31:0];
    integer i;

    //Only assigns if A1,A2 not equal to zero
    always @(*) begin
	RD1 = (A1 == 5'd0) ? 32'b0 : x[A1];
	RD2 = (A2 == 5'd0) ? 32'b0 : x[A2];
        x[9] <= 16'h2004;
    end

    
    always @ (posedge CLK) begin
        if (!RST) begin
            //On RST all register set to 32'b0
            for (i = 0; i < 32; i = i + 1) begin
            x[i] <= 32'b0;
            end
            x[9] = 16'h2004;
        end 
        else if (WE3 && (A3 != 5'd0)) begin
            //Write only if not register 0
            x[A3] <= WD3;
        end
    end

    always @ (*) begin
        RdD=Rd11_7; 
    end

endmodule

//***NOTE****
//Pipelined processor implementing lw,sw,beq,add,sub,slt,or,and
//blindly followed DDCA Harris and Harris pg444 expcept for jump
