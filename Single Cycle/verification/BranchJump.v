module BranchJump(
output reg PCSrc
);

wire Branch;
wire Zero;

MainDecoder MDInst(
.Branch(Branch)
);

ALU ALUInst(
.Zero(Zero)
);

PCMux PCMuxInst(
.PCSrc(PCSrc)
);

always@(*) begin
PCSrc = Zero&Branch;
end


endmodule
