module SrcBMux (
    input wire [31:0] RD2,
    input wire [31:0] ImmExt,
    input wire ALUSrc,
    output reg [31:0] SrcB
);
always@(*) begin
case(ALUSrc)
    1'b0 : SrcB <= ImmExt;
    1'b1 : SrcB <= RD2;
    default : SrcB <=RD2; //deafult RD2
endcase
end 
endmodule
