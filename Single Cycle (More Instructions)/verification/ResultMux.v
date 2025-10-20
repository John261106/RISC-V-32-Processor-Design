module ResultMux(
    input wire [31:0] ALUResult,
    input wire [31:0] ReadData,
    input wire [31:0] PCPlus4,
    input wire  [1:0]ResultSrc,
    output reg [31:0] Result
);

always @(*) begin
    case(ResultSrc)
        2'b00: Result = ALUResult;    // R-type instructions
        2'b01: Result = ReadData; 
        2'b10: Result = PCPlus4;// for jal instruction 
        default: Result = ALUResult;
    endcase
end

endmodule

//checked