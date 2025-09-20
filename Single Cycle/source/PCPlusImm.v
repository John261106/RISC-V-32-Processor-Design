module PCPlusImm(
input wire [31:0] PC,
input wire [31:0]ImmExt,
output reg [31:0] PCTarget
);
always@(*) begin
 	PCTarget=PC+ImmExt;
end
endmodule
