module Execute(
input wire [2:0] Cond_SrcE,
input wire [2:0] ALUControlE,
input wire ALUSrcE,
input wire [31:0] RD1E,
input wire [31:0] RD2E,
input wire [31:0] PCE,
input wire [31:0] ImmExtE,

output reg [31:0] PCTargetE,
output reg [1:0] PCSrcE,
output reg [31:0] ALUResultE, //pay attention name not there in book ka picture
output reg [31:0] WriteDataE
);

reg Zero;
reg Negative;
reg[31:0] SrcB;
always @(*) begin
    case(ALUSrcE)
    1'b0:SrcB = RD2E;
    1'b1:SrcB = ImmExtE;
    endcase

end


always @(*) begin
    case(ALUControlE)
        3'b000 : ALUResultE = RD1E + SrcB;                              // ADD
        3'b001 : ALUResultE = RD1E - SrcB;                              // SUB
        3'b111 : ALUResultE = RD1E & SrcB;                              // AND
        3'b011 : ALUResultE = RD1E | SrcB;                              // OR
        3'b101 : ALUResultE = ($signed(RD1E) < $signed(SrcB)) ? 1 : 0;  // SLT (signed)
        3'b100 : ALUResultE = RD1E << SrcB[4:0];                        // SLL(only need to take 4:) since there are only 32 bits
        3'b110 : ALUResultE = RD1E >> SrcB[4:0];                        // SRL (logical)
        3'b010 : ALUResultE = RD1E ^ SrcB;                              // XOR
        default : ALUResultE = 32'bx;
    endcase

    Zero = (ALUResultE == 32'b0);
    Negative = ALUResultE[31];
end

always @(*) begin
WriteDataE = RD2E;
end


always @(*) begin
    case(Cond_SrcE)
        3'b000: PCSrcE=(Zero==1)?2'b01:2'b00;//beq
        3'b001: PCSrcE=(Negative == 1) ? 2'b01:2'b00;//blt
        3'b010: PCSrcE=(Negative==0) ? 2'b01:2'b00;//bge
        3'b011: PCSrcE=2'b01;// for jal
        3'b100: PCSrcE=2'b10;//for jalr
        default: PCSrcE=2'b00;
    endcase
end

always @ (*) begin
    PCTargetE=PCE+ImmExtE;
end



endmodule





