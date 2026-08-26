`include "PC_Reg.v"
`include "next_PC.v"
`include "register.v"
`include "instr_mem.v"
`include "i_gen.v"
`include "ccu.v"
`include "alu_ctrl.v"
`include "alu.v"
`include "data_mem.v"


module toplvl_datapath(
    input clk,
    input rst
);

wire [31:0] rs1, rs2, rd1, instr_out, imm_gen, next_pc_val, alr, pc_plus_4, pc_val, alu_b, write_data;
wire [1:0] alu_op_out;
wire [0:0] alu_z, reg_write_ctl, mem_write_ctl, mem_to_reg_ctl, alu_src_ctl, branch_ctl, is_bne_ctl, jump_ctl, lui_sel_ctl,act;

pc_reg pc (
    .clk(clk),
    .rst(rst),
    .pc(pc_val),
    .next_pc(next_pc_val)
);

next_pc npc(
    .pc(pc_val),
    .imm(imm_gen),
    .branch(branch_ctl),
    .jump(jump_ctl),
    .is_bne(is_bne_ctl),
    .zero(alu_z),
    .next_pc(next_pc_val)
);

mem3port regfile(
    .clk(clk),
    .we(reg_write_ctl),
    .wdata(write_data),
    .waddr(instr_out[11:7]),
    .raddr0(instr_out[19:15]),
    .raddr1(instr_out[24:20]),
    .rdata0(rs1),
    .rdata1(rs2)
);

instr_mem imem0(
    .addr(pc_val[9:2]),
    .instr(instr_out)
);

i_gen ig(
    .instr(instr_out),
    .imm(imm_gen)
);

control_unit ccu(
    .opcode(instr_out[6:0]),
    .funct3(instr_out[14:12]),
    .alu_op(alu_op_out),
    .reg_write(reg_write_ctl),
    .mem_write(mem_write_ctl),
    .mem_to_reg(mem_to_reg_ctl),
    .alu_src(alu_src_ctl),
    .branch(branch_ctl),
    .is_bne(is_bne_ctl),
    .jump(jump_ctl),
    .lui_sel(lui_sel_ctl)
);

ALU_CC cca(
    .alu_op(alu_op_out),
    .funct7_bit(instr_out[30]),
    .alu_ctrl(act)
);

ALU a0(
    .a(rs1),
    .b(alu_b),
    .result(alr),
    .zero(alu_z),
    .alu_ctrl(act)
);

data_mem dm0(
    .clk(clk),
    .we(mem_write_ctl),
    .wdata(rs2),
    .addr(alr[9:2]),
    .rdata(rd1)
);

function [31:0] alu_b_mux;
    input [31:0] rdata1;
    input [31:0] imm;
    input alu_src;
begin
    alu_b_mux = alu_src ? imm : rs2;
end
endfunction

function [31:0] write_mux;
    input [31:0] result;
    input [31:0] imm;
    input [31:0] rdata;
    input [31:0] pc_plus_4;
    input jump;
    input lui_sel;
    input mem_to_reg;

begin
    if(jump)
        write_mux = pc_plus_4;
    else if(lui_sel)
        write_mux = imm;
    else if(mem_to_reg)
        write_mux = rdata;
    else
        write_mux = result;
end
endfunction

assign pc_plus_4 = pc_val + 4;
assign alu_b = alu_b_mux(rs2, imm_gen, alu_src_ctl);
assign write_data = write_mux(alr, imm_gen, rd1, pc_plus_4, jump_ctl, lui_sel_ctl, mem_to_reg_ctl);


















