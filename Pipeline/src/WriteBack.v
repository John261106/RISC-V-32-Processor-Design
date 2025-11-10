module WriteBack(
    input wire [31:0] ALUResultW,
    input wire [31:0] ReadDataW,
    input wire [1:0]ResultSrcW,
    input wire [31:0] PCPlus4W,
    output reg [31:0] ResultW
);

always @(*) begin
    case(ResultSrcW)
        2'b00: ResultW = ALUResultW;    // R-type instructions
        2'b01: ResultW = ReadDataW;     // Load instructions
        2'b10: ResultW = PCPlus4W;      // J TYPE 
        default: ResultW = ALUResultW;
    endcase
end

endmodule

