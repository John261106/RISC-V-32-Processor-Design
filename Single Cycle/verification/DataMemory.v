module DataMemory(
    input wire CLK,
    input wire WE,
    input wire [31:0] A_DM,
    input wire [31:0] WD,
    input wire RST,
    output reg [31:0] RD3
);

reg [31:0] x [31:0];

// Read logic - use only lower 5 bits for addressing 32 words
always@(*) begin
    RD3 = x[A_DM[4:0]];  // ✓ Uses bits [4:0] for 32 entries (0-31)
end

integer i;
always @ (posedge CLK) begin
    if (!RST) begin
        for (i = 0; i < 32; i = i + 1) begin
            x[i] <= 32'd0;  // ✓ Set to 0 (or keep 32'd10 if that's intended)
        end
    end 
    else if (WE) begin
        x[A_DM[4:0]] <= WD;  // ✓ Uses bits [4:0]
    end
end
endmodule

//CHANGED THE THING TO 4:0 (gpt suggested, not sure what was earlier issue)
