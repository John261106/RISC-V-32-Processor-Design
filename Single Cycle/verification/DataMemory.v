module DataMemory(
    input wire CLK,
    input wire WE,
    input wire [31:0] A_DM,//2 A were there changed it 
    input wire [31:0] WD,
    input wire RST, //active low reset synchronous
    output reg [31:0] RD3
);
//32 32bit data memory
reg [31:0] x [31:0];

always@(*) begin
RD3=x[A_DM];
end

integer i;

always @ (posedge CLK) begin
    if (!RST) begin
        //On RST all register set to 32'b0
        for (i = 0; i < 32; i = i + 1) begin
            x[i] <= 32'b00000000000000000000000000001010;
        end
    end 
    else if (WE) begin
        x[A_DM] <= WD;
    end
end


endmodule

//checked

