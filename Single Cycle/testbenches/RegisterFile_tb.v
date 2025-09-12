`timescale 1ns/1ps

module tb_RegisterFile;

  // Testbench signals
  reg CLK;
  reg WE3;
  reg [4:0] A1, A2, A3;
  reg [31:0] WD3;
  wire [31:0] RD1, RD2;

  // Instantiate DUT
  RegisterFIle dut (
    .CLK(CLK),
    .WE3(WE3),
    .A1(A1),
    .A2(A2),
    .A3(A3),
    .WD3(WD3),
    .RD1(RD1),
    .RD2(RD2)
  );

  // Clock generation (10ns period)
  always #5 CLK = ~CLK;

  initial begin
    // Dump for GTKWave
    $dumpfile("RegisterFile_tb.vcd");
    $dumpvars(0, tb_RegisterFile);

    // Initialize
    CLK = 0;
    WE3 = 0;
    A1 = 0; A2 = 0; A3 = 0; WD3 = 0;

    // --- Test sequence ---
    // Write 42 into register 5
    #10 WE3 = 1; A3 = 5; WD3 = 32'd42;
    #10 WE3 = 0;

    // Write 100 into register 10
    #10 WE3 = 1; A3 = 10; WD3 = 32'd100;
    #10 WE3 = 0;

    // Read back from register 5 and 10
    #10 A1 = 5; A2 = 10;

    // Write 77 into register 5 again
    #10 WE3 = 1; A3 = 5; WD3 = 32'd77;
    #10 WE3 = 0;

    // Read updated register 5 and old register 10
    #10 A1 = 5; A2 = 10;

    // Finish
    #20 $finish;
  end

  // Monitor values
  initial begin
    $monitor("t=%0t CLK=%b WE3=%b A1=%d A2=%d A3=%d WD3=%d | RD1=%d RD2=%d",
             $time, CLK, WE3, A1, A2, A3, WD3, RD1, RD2);
  end

endmodule
