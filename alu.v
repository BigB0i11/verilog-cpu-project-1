typedef enum logic [1:0] {ADD, SUB} alu_t;

module ALU(
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] result,
    output reg zero,
    input alu_t alu_ctrl
);


always @(*) begin
    case(alu_ctrl)
        ADD: result = a + b;
        SUB: result = a - b;
        default : result = 0;
    endcase

    if(result == 0)
        zero = 1;
    else
        zero = 0;
end

endmodule