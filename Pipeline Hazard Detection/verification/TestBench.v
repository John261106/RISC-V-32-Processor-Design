`timescale 1ns/1ps

module TopModule_tb;

    // Inputs
    reg CLK;
    reg RST;

    // Instantiate the TopModule
    TopModule_Pipeline uut (
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
        #10;

        // Apply reset
        RST = 1;
        #100
        // Finish simulation
        $finish;
    end

    always @ (posedge CLK) begin
        $display("--------------------------------");
        $display("PC = %d", uut.PC_F);
        $display("ALUResult = %d", uut.ALUResult_E);
        


    end

    initial begin
    $dumpfile("waveform.vcd");   // Name of the VCD file
    $dumpvars(0, uut);     // Dump all signals in TopModule
    end


endmodule
