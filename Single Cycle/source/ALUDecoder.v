module ALUDecoder(
input wire[2:0] funct3,
input wire[5:5] funct7,
input wire [5:5] op,
input wire [1:0] ALUOp,
output reg [2:0] ALUControl
);

always @(*) begin
    case (ALUOp)
        2'b00: ALUControl = 3'b010;
        2'b01: ALUControl = 3'b110;
        2'b10: begin
            case (funct3)
                3'b000: ALUControl = (funct7b5 ? 3'b110 : 3'b010);
                3'b111: ALUControl = 3'b000;
                3'b110: ALUControl = 3'b001;
                3'b100: ALUControl = 3'b011;
                3'b010: ALUControl = 3'b111;
                3'b001: ALUControl = 3'b100;
                3'b101: ALUControl = (funct7b5 ? 3'b111 : 3'b101);
                default: ALUControl = 3'b000;
            endcase
        end
        default: ALUControl = 3'b000;
    endcase
end
endmodule
