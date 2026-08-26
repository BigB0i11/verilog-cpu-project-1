typedef enum logic [1:0] {ADD, SUB} alu_t;

module ALU_CC(
    input [1:0] alu_op,
    input [0:0] funct7_bit,
    output alu_t alu_ctrl
);

always @(*) begin
    case(alu_op)
        2'b00: alu_ctrl = ADD;
        2'b01: alu_ctrl = SUB;
        2'b10: begin
            if(funct7_bit == 1'b0)
                alu_ctrl = ADD;
            else
                alu_ctrl = SUB;
        end
        default: ;
    endcase
end


endmodule
