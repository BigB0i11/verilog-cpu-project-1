module data_mem #(
    parameter DATA_WIDTH = 32,
    parameter DEPTH = 256
)
(
    input clk,
    input we,
    input [DATA_WIDTH-1:0]    wdata,
    input [$clog2(DEPTH)-1:0] addr,
    output [DATA_WIDTH-1:0]   rdata
);

logic [DATA_WIDTH-1:0] dmem [0:DEPTH-1];

always @ (posedge clk) begin
    if (we)
        dmem[addr] <= wdata;
end

assign rdata = dmem[addr];
endmodule