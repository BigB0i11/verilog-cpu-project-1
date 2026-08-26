module intr_mem #(
    parameter DATA_WIDTH = 32,
    parameter DEPTH = 256
)
(
    input [$clog2(DEPTH)-1:0] addr,
    output [DATA_WIDTH-1:0] instr
);

reg [DATA_WIDTH-1:0] imem [0:DEPTH-1];

initial begin
    $readmemh("program.hex", imem);
end

assign instr = imem[addr];

endmodule