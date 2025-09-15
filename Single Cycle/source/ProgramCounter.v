//program counter module --Rishi
module pc(
input wire CLK,
input wire RST,
input wire [31:0] PCNext,
output reg [31:0] PC
);

//A clock triggered block is used which will keep updating PC with PC_Next if reset is not active, if reset is active PC <= 0

always@(posedge CLK or posedge RST) begin //should we use synchronous or asynchronous reset
if(RST) begin //doubt -- should we use nRST or RST ?
PC <= 0;
end

else begin
PC <= PCNext;
end

end
endmodule
