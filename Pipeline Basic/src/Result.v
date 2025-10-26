module ResultMux(
    input wire [31:0] ALUResultW,
    input wire [31:0] ReadDataW,
    input wire ResultSrcW,
    output reg [31:0] ResultW
);

always @(*) begin
    case(ResultSrcW)
        1'b0: ResultW = ALUResultW;    // R-type instructions
        1'b1: ResultW = ReadDataW;     // Load instructions
        default: ResultW = ALUResultW;
    endcase
end

endmodule

