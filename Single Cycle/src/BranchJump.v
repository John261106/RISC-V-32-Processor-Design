module BranchJump(
input wire Branch,
input wire Zero,
output reg PCSrc
);

MainDecoder MDInst(
.Branch(Branch);
);

ALU ALUInst(
.Zero(Zero);
);

PCMux PCMuxInst(
.PCSrc(PCSrc)
);

always@(*) begin
PCSrc = Zero&Branch;
end


endmodule
