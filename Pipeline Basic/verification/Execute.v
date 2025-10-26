module Execute(
input wire BranchE,
input wire [2:0] ALUControlE,
input wire ALUSrcE,
input wire [31:0] RD1E,
input wire [31:0] RD2E,
input wire [31:0] PCE,
input wire [31:0] ImmExtE,

output reg [31:0] PCTargetE,
output reg [31:0] PCSrcE,
output reg [31:0] ALUResult, //pay attention name not there in book ka picture
output reg [31:0] WriteDataE
);

wire [31:0] SrcAE;
wire [31:0] SrcBE;
reg ZeroE;

always @(*) begin
    case(ALUControlE)
        3'b000 : ALUResult = SrcAE + SrcBE;
        3'b001 : ALUResult = SrcAE - SrcBE;
        3'b111 : ALUResult = SrcAE & SrcBE;
        3'b011 : ALUResult = SrcAE | SrcBE;
        3'b101 : ALUResult = (SrcAE < SrcBE) ? 1 : 0;
        default : ALUResult = 32'b0;
	// deafult case is zero
    endcase 
    ZeroE = (ALUResult == 32'b0) ? 1 : 0;
end

always@(*) begin
PCTarget=PCE+ImmExtE;
end

always@(*) begin
case(ALUSrcE)
    1'b0 : SrcBE <= RD2;
    1'b1 : SrcBE <= ImmExt;
    default : SrcBE <=RD2; //deafult RD2
endcase
end 


always @(*) begin
    PCSrcE = BranchE & ZeroE;
end

endmodule

endmodule





