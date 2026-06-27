module RegisterFile(
    input wire CLK,
    input wire RST, //active-low reset synchronous
    input wire WE3,
    input wire [4:0] A1,
    input wire [4:0] A2,
    input wire [4:0] A3,
    input wire [31:0] WD3,
    output reg [31:0] RD1,
    output reg [31:0] RD2
);

    reg [31:0] x [31:0];
    integer i;

    //Only assigns if A1,A2 not equal to zero
    always @(*) begin
    	RD1 = (A1 == 5'd0) ? 32'b0 : x[A1];
    	RD2 = (A2 == 5'd0) ? 32'b0 : x[A2];
        x[9] <= 16'h2004;
    end

    
    always @ (posedge CLK) begin
        if (!RST) begin
            //On RST all register set to 32'b0
            for (i = 0; i < 32; i = i + 1) begin
            x[i] <= 32'b0;
            end
            x[9] = 16'h2004;
        end 
        else if (WE3 && (A3 != 5'd0)) begin
            //Write only if not register 0
            x[A3] <= WD3;
        end
    end

endmodule


//checked
