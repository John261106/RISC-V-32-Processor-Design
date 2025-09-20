`timescale 1ns/1ps

module tb_RegisterFile;

    // Testbench signals
    reg CLK;
    reg RST;
    reg WE3;
    reg [4:0] A1, A2, A3;
    reg [31:0] WD3;
    wire [31:0] RD1, RD2;

    // Instantiate the RegisterFile
    RegisterFile uut (
        .CLK(CLK),
        .RST(RST),
        .WE3(WE3),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .WD3(WD3),
        .RD1(RD1),
        .RD2(RD2)
    );

    // Clock generation
    initial CLK = 0;
    always #5 CLK = ~CLK; // 10ns period

    initial begin
        // Initialize signals
        RST = 0; WE3 = 0; A1 = 0; A2 = 0; A3 = 0; WD3 = 0;
        #10;
        
        // Release reset
        RST = 1;

        // Test case 1: Write to register 1
        A3 = 5'd1; WD3 = 32'hAAAA_BBBB; WE3 = 1;
        #10; // Wait for one clock edge
        WE3 = 0;

        // Read back values
        A1 = 5'd1; A2 = 5'd0; // RD1 should show written value, RD2 should be 0
        #10;

        // Test case 2: Attempt write to register 0 (should not change)
        A3 = 5'd0; WD3 = 32'hFFFF_FFFF; WE3 = 1;
        #10;
        WE3 = 0;
        A1 = 5'd0; A2 = 5'd1; // RD1 should be 0, RD2 should retain previous value
        #10;

        // Test case 3: Synchronous reset
        RST = 0; // Assert reset
        #10;
        RST = 1; // Deassert reset
        A1 = 5'd1; A2 = 5'd0; // RD1 and RD2 should now be 0
        #10;

        $finish;
    end

endmodule

