module pc_reg
(
    input clk,
    input rst,
    output reg [31:0] pc,
    input [31:0] next_pc
);

always @ (posedge clk) begin
    if(rst)
        pc <= 0;
    else 
        pc <= next_pc;
end

endmodule
