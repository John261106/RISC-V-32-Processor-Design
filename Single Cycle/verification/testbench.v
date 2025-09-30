`timescale 1ns/1ps

module TopModule_tb;

    // Inputs
    reg CLK;
    reg RST;

    // Instantiate the TopModule
    TopModule uut (
        .CLK(CLK),
        .RST(RST)
    );

    // Clock generation: 10ns period
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

    // Test stimulus
    initial begin
        // Initialize inputs
        RST = 0;
        #30;

        // Apply reset
        RST = 1;
        #100

        RST = 0
        #20
        // Finish simulation
        $stop;
    end

    initial begin
    $dumpfile("waveform.vcd");   // Name of the VCD file
    $dumpvars(0, TopModule);     // Dump all signals in TopModule
    end


endmodule
