module BranchDecoder(
    input wire [2:0] funct3,
    input wire [6:0] op,
    output reg [2:0] Cond_Src//made cond src 3bits since jalr and jal have differnt pc next
);

always @(*) begin
    if (op == 7'b1100011) begin  // B-type instructions (conditional branches)
        case (funct3)
            3'b000: Cond_Src = 3'b000;  // BEQ - branch if zero
            3'b100: Cond_Src = 3'b001;  // BLT - branch if negative
            3'b101: Cond_Src = 3'b010;  // BGE - branch if non-negative
            default: Cond_Src = 3'bxxX;
        endcase
    end else if (op == 7'b1101111) begin
        // JAL (1101111) 
        Cond_Src = 3'b011;  
    end else if (op == 7'b1100111) begin
        Cond_Src = 3'b100;//for jalr
    end else begin

        Cond_Src = 2'b00;
    end
end

endmodule