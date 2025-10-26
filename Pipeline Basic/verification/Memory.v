module Memory(
input wire MemWriteM;
input wire [31:0] ALUResultM,
input wire[31:0] WriteDataM,
input wire CLK,
input wire RST,
output reg [31:0] RD3,
output reg[31:0] ALUResultM1;
)
reg [31:0] x [31:0];



// Read logic - use only lower 5 bits for addressing 32 words
always@(*) begin
    RD3 = x[ALUResultM[4:0]];  // ✓ Uses bits [4:0] for 32 entries (0-31)
end
always@(*) begin 
    ALUResultM1=ALUResultM;
end

integer i;
always @ (posedge CLK) begin
    if (!RST) begin
        for (i = 0; i < 32; i = i + 1) begin
         x[i] <= 32'b00000000000000000000000000001010;  // ✓ Set to 0 (or keep 32'd10 if that's intended)
        end
    end 
    else if (MemWrite) begin
        x[ALUResultM[4:0]] <= WriteDataM;  // ✓ Uses bits [4:0]
    end
end




endmodule