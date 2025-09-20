`timescale 1ns/1ps

module tb_ALU;

    reg [31:0] SrcA, SrcB;
    reg [2:0] ALUControl;
    wire [31:0] ALUResult;
    wire Zero;

    // Instantiate ALU
    ALU uut (
        .SrcA(SrcA),
        .SrcB(SrcB),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult),
        .Zero(Zero)
    );

    initial begin
        // Test ADD
        SrcA = 32'd10; SrcB = 32'd5; ALUControl = 3'b000;
        #10;
        $display("ADD: %d + %d = %d, Zero=%b", SrcA, SrcB, ALUResult, Zero);

        // Test SUB (non-zero)
        ALUControl = 3'b001;
        #10;
        $display("SUB: %d - %d = %d, Zero=%b", SrcA, SrcB, ALUResult, Zero);

        // Test SUB (zero)
        SrcA = 32'd7; SrcB = 32'd7; ALUControl = 3'b001;
        #10;
        $display("SUB: %d - %d = %d, Zero=%b", SrcA, SrcB, ALUResult, Zero);

        // Test AND
        SrcA = 32'hF0F0_F0F0; SrcB = 32'h0F0F_0F0F; ALUControl = 3'b111;
        #10;
        $display("AND: %h & %h = %h, Zero=%b", SrcA, SrcB, ALUResult, Zero);

        // Test OR
        ALUControl = 3'b011;
        #10;
        $display("OR: %h | %h = %h, Zero=%b", SrcA, SrcB, ALUResult, Zero);

        // Test SLT
        SrcA = 5; SrcB = 10; ALUControl = 3'b101;
        #10;
        $display("SLT: %d < %d = %d, Zero=%b", SrcA, SrcB, ALUResult, Zero);

        // Test custom instruction {SrcA[31:16], SrcB[15:0]}
        SrcA = 32'hAAAA_BBBB; SrcB = 32'hCCCC_DDDD; ALUControl = 3'b100;
        #10;
        $display("CUSTOM: {SrcA[31:16], SrcB[15:0]} = %h, Zero=%b", ALUResult, Zero);

        $finish;
    end

endmodule

