module mem3port #(
    parameter DATA_WIDTH = 32
)
(
    input clk,
    input we,

    input [4:0] waddr,
    input [DATA_WIDTH-1:0] wdata,
    input [4:0] raddr0,
    input [4:0] raddr1,

    output [DATA_WIDTH-1:0]   rdata0,
    output [DATA_WIDTH-1:0]   rdata1
);

logic [DATA_WIDTH-1:0] memory [0:31];

always @ (posedge clk) begin
    if (we && waddr != 5'd0)
    memory[waddr] <= wdata;
end

assign rdata0 = (raddr0 == 5'd0) ?  {DATA_WIDTH{1'b0}} : memory[raddr0];
assign rdata1 = (raddr1 == 5'd0) ?  {DATA_WIDTH{1'b0}} : memory[raddr1];

endmodule