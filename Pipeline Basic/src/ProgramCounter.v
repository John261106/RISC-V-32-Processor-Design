//program counter module --Rishi
module PC(
input wire CLK,
input wire RST,//active low reset synchronous
input wire [31:0] PCNext,
output reg [31:0] PC
);

//A clock triggered block is used which will keep updating PC with PC_Next if reset is not active, if reset is active PC <= 0

always@(posedge CLK) begin 
if(!RST) begin 
PC <= 0;
end

else begin
PC <= PCNext;
end

end
endmodule
