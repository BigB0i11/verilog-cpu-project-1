SIM ?= icarus
TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES = $(PWD)/cpu_datapath.v $(PWD)/PC_Reg.v $(PWD)/next_PC.v $(PWD)/register.v $(PWD)/instr_mem.v $(PWD)/i_gen.v $(PWD)/ccu.v $(PWD)/alu_ctrl.v $(PWD)/alu.v $(PWD)/data_mem.v
MODULE = testbench

include $(shell cocotb-config --makefiles)/Makefile.sim

