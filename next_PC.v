module next_pc_logic 
(
    input [31:0] pc,
    input [31:0] imm,
    input branch,
    input jump,
    input is_bne,
    input zero,
    output reg [31:0] next_pc
);

logic branch_taken;

assign branch_taken = branch & (is_bne ^ zero);

always @(*) begin
    if (jump)
        next_pc = pc + imm;
    else if(branch_taken)
        next_pc = pc + imm;
    else
        next_pc = pc + 4;
end

endmodule

