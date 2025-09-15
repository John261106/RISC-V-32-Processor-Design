module ControlUnit(
input wire [6:0] op,
input wire [14:12] funct3
input wire [30:30] funct7,
output reg ResultSrc,
output reg MemWrite,
output reg [1:0] ALUOp,
output reg ALUSrc,
output reg Branch,
output reg Jump,
output reg [1:0] ImmSrc,
output reg RegWrite
);






endmodule
