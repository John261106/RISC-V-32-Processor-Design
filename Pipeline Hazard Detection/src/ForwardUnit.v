module ForwardUnit(
    input wire [4:0] RD_M,
    input wire [4:0] RD_W,
    input wire RegWrite_M,
    input wire RegWrite_W,
    input wire [4:0] RS1_E,
    input wire [4:0] RS2_E,

    output reg [1:0] ForwardA,
    output reg [1:0] ForwardB
);

always @(*) begin

    ForwardA = 2'b00;
    ForwardB = 2'b00;

    // Highest priority: EX/MEM
    if (RegWrite_M && (RD_M != 5'd0)) begin
        if (RD_M == RS1_E)
            ForwardA = 2'b10;

        if (RD_M == RS2_E)
            ForwardB = 2'b10;
    end

    // Lower priority: MEM/WB
    if (RegWrite_W && (RD_W != 5'd0)) begin
        if ((ForwardA == 2'b00) && (RD_W == RS1_E))
            ForwardA = 2'b01;

        if ((ForwardB == 2'b00) && (RD_W == RS2_E))
            ForwardB = 2'b01;
    end

end


endmodule