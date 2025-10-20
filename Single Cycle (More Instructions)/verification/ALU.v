module ALU(
    input wire [31:0] SrcA,
    input wire [31:0] SrcB,
    input wire [2:0] ALUControl,
    output reg [31:0] ALUResult,
    output reg Zero,
    output reg Negative
);

always @(*) begin
    case(ALUControl)
        3'b000 : ALUResult = SrcA + SrcB; //DONE
        3'b001 : ALUResult = SrcA - SrcB; //DONE
        3'b111 : ALUResult = SrcA & SrcB; //DONE
        3'b011 : ALUResult = SrcA | SrcB; //DONE
        3'b101 : ALUResult = (SrcA < SrcB) ? 1 : 0; //DONE
        3'b100 : ALUResult = SrcA << SrcB; //DONE
        3'b110 : ALUResult = SrcA >> SrcB; //DONE
        3'b010 : ALUResult = SrcA ^ SrcB; //DONE
        default : ALUResult = 32'bx;
	// deafult case is zero
    endcase

    Negative = ~((SrcA - SrcB >= 0) ? 1 : 0);
    Zero = (ALUResult == 32'b0) ? 1 : 0;
    
end

endmodule

//checked
