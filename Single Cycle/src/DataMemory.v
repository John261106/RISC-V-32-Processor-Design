module DataMemory(
    input wire CLK,
    input wire WE,
    input wire [31:0] A,
    input wire [31:0] WD,
    input wire RST, //active low reset synchronous
    output reg [31:0] RD1
);
//32 32bit data memory
reg [31:0] x [31:0];


 RD=x[A];

always @ (posedge CLK) begin
    if (!RST) begin
        //On RST all register set to 32'b0
        integer i;
        for (i = 0; i < 32; i = i + 1) begin
            x[i] <= 32'b0;
        end
    end 
    else if (WE) begin
        x[A] <= WD;
    end
end


endmodule

