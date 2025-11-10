//solving data hazards with Forwarding/bypassing

//key point : Forwarding is necessary when an instruction in the Execute stage has a source register matching the destination register of an instruction in the Memory or Writeback stage.

module HazardUnit(
input wire [31:0] Rs1EH,
input wire [31:0] Rs2EH,
input wire [31:0] RdMH,
input wire [31:0] RdWH,
input wire [31:0] RegWriteMH,
input wire [31:0] RegWriteWH,

output reg [1:0] ForwardAE,
output reg [1:0] ForwardBE
);

if ((Rs1EH == RdMH) & RegWriteMH) & (Rs1EH != 0) ForwardAE = 2'b10;
else if ((Rs1EH == RdMH) & RegWriteMH) & (Rs1EH != 0) ForwardAE = 2'b01;else ForwardAE

if ((Rs2EH == RdMH) & RegWriteMH) & (Rs2EH != 0) ForwardBE = 2'b10;
else if ((Rs2EH == RdMH) & RegWriteMH) & (Rs2EH != 0) ForwardBE = 2'b01;else ForwardBE

endmodule
