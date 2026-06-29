module HazardDetection (
    input wire ResultSrc_E,
    input wire [4:0] RD_E,
    input wire [4:0] RS1_D,
    input wire [4:0] RS2_D,

    output reg FlushE,
    output reg FDWrite,
    output reg PCWrite
);

always @(*) begin
    // Default: no hazard
    FlushE = 1'b0;
    FDWrite = 1'b1;
    PCWrite = 1'b1;

    // Load-use hazard
    if (ResultSrc_E &&
        (RD_E != 5'd0) &&
        ((RD_E == RS1_D) || (RD_E == RS2_D))) begin

        FlushE = 1'b1;
        FDWrite = 1'b0;
        PCWrite = 1'b0;
    end
end

endmodule