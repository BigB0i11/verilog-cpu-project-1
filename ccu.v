// OPcodes Definitions
`define R_TYPE   7'b0110011
`define STORE    7'b0100011
`define BRANCH   7'b1100011
`define JUMP     7'b1101111
`define U_TYPE   7'b0110111
`define LOAD     7'b0000011
`define ADDI     7'b0010011

module control_unit 
(
    input [6:0] opcode,
    input [2:0] funct3,
    output reg [1:0] alu_op,
    output reg reg_write, mem_write, mem_to_reg, alu_src, branch, is_bne, jump, lui_sel
);

always @(*) begin
    reg_write = 0; mem_write = 0; mem_to_reg = 0; alu_src = 0; branch = 0; is_bne = 0; jump = 0; lui_sel = 0; alu_op = 2'b00;

    case(opcode) 
        `R_TYPE: begin
            reg_write = 1;
            alu_op = 2'b10;
            is_bne = 1'bx;
        end

        `STORE: begin
            mem_write = 1;
            alu_src = 1;
            mem_to_reg = 1'bx;
            is_bne = 1'bx;
            alu_op = 2'b00;
        end

        `BRANCH: begin
            branch = 1;
            mem_to_reg = 1'bx;
            alu_op = 2'b01;

            if(funct3 == 3'b000) 
                is_bne = 0;
            else if(funct3 == 3'b001)
                is_bne = 1;
            
        end

        `LOAD: begin
            reg_write = 1;
            mem_to_reg = 1;
            alu_src = 1;
            is_bne = 1'bx;
            alu_op = 2'b00;
        end

        `ADDI: begin
            reg_write = 1;
            alu_src = 1;
            is_bne = 1'bx;
            alu_op = 2'b00;
        end

        `JUMP: begin
            reg_write = 1;
            jump = 1;
            alu_src = 1'bx;
            is_bne = 1'bx;
            alu_op = 2'bx;
        end

        `U_TYPE: begin
            reg_write = 1;
            lui_sel = 1;
            alu_src = 1'bx;
            is_bne = 1'bx;
            alu_op = 2'bx;
        end

        default:  ;

    endcase
end

endmodule