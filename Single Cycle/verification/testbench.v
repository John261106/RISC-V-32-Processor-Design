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
        #100
        // Finish simulation
        $finish;
    end

    always @ (posedge CLK) begin
        $display("--------------------------------");
        $display("PC = %d", uut.PC);
        $display("Instruction = %h", uut.RD);
        $display("ALU Result = %d", uut.ALUResult);
        $display("Zero        = %b", uut.Zero);
        $display("RegWrite = %b", uut.RegWrite);
        $display("MemWrite    = %b", uut.MemWrite);
        if (uut.RegWrite) begin
            $display("WriteReg = x%0d", uut.RD[11:7]);
            $display("WriteData(Register) = %d", uut.WD3);
        end
        if (uut.MemWrite)
            $display("WriteData(Memory) = x%0d", uut.RD2);
        


    end

    initial begin
    $dumpfile("waveform.vcd");   // Name of the VCD file
    $dumpvars(0, uut);     // Dump all signals in TopModule
    end


endmodule
