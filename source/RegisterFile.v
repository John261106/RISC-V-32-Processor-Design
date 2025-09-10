module RegisterFIle(
    input wire CLK,
    input wire WE3,
    input wire [4:0] A1,
    input wire [4:0] A2,
    input wire [4:0] A3,
    input wire [31:0] WD3,
    output reg [31:0] RD1,
    output reg [31:0] RD2
);//reset to be added

reg [31:0] x [31:0];
assign RD1=x[A1];
assign RD2=x[A2];

always @ (posedge CLK) begin
    if(WE3) begin
        x[A3]<=WD3;
    end
end
endmodule

