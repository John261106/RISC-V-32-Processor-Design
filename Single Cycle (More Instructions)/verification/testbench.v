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
        #10;

        // Apply reset
        RST = 1;
        #150;

       
        // Finish simulation
        $finish;
    end

    initial begin
    $dumpfile("waveform.vcd");   // Name of the VCD file
    $dumpvars(0, uut);     // Dump all signals in TopModule
    end
    always @(posedge CLK) begin
        $display("-----------------------------------------------------");
        $display("PC          = %0d", uut.PC);
        $display("Instruction = %h", uut.RD);

        $display("PCNext      = %0d", uut.PCNext);
        $display("PCSrc       = %b", uut.PCSrc);

        $display("RD1         = %0d", uut.RD1);
        $display("RD2         = %0d", uut.RD2);
        $display("ImmExt      = %0d", uut.ImmExt);

        $display("ALUResult   = %0d", uut.ALUResult);

        $display("Zero        = %b", uut.Zero);
        $display("Negative    = %b", uut.Negative);

        $display("RegWrite    = %b", uut.RegWrite);
        $display("MemWrite    = %b", uut.MemWrite);

        if(uut.RegWrite)
            $display("x%0d <- %0d", uut.RD[11:7], uut.WD3);

        if(uut.MemWrite)
            $display("MEM[%0d] <- %0d", uut.ALUResult, uut.RD2);
    end


endmodule
