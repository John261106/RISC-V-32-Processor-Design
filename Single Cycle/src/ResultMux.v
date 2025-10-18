module ResultMux(
    input wire [31:0] ALUResult,
    input wire [31:0] ReadData,
    input wire  ResultSrc,
    output reg [31:0] Result
);

always @(*) begin
    case(ResultSrc)
        1'b0: Result = ALUResult;    // R-type instructions
        1'b1: Result = ReadData;     // Load instructions
        default: Result = ALUResult;
    endcase
end

endmodule

//checked