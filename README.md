# RV32I Single-Cycle CPU (Verilog + cocotb)

A from-scratch single-cycle RISC-V (RV32I subset) CPU implemented in Verilog, verified with a Python testbench using [cocotb](https://www.cocotb.org/).

## Overview

This project implements the classic fetch → decode → execute → writeback datapath for a subset of the RV32I instruction set, and proves it works end-to-end by loading a small machine-code program into instruction memory and checking the register file's contents after simulation.

## Instruction Set Supported

**Phase 1 (core 6):** `add`, `addi`, `lw`, `sw`, `beq`, `jal`
**Phase 2 (additions):** `sub`, `bne`, `lui`

| Instr | Format | opcode | funct3 | funct7 |
|---|---|---|---|---|
| `add` | R | 0110011 | 000 | 0000000 |
| `sub` | R | 0110011 | 000 | 0100000 |
| `addi` | I | 0010011 | 000 | — |
| `lw` | I | 0000011 | 010 | — |
| `sw` | S | 0100011 | 010 | — |
| `beq` | B | 1100011 | 000 | — |
| `bne` | B | 1100011 | 001 | — |
| `lui` | U | 0110111 | — | — |
| `jal` | J | 1101111 | — | — |

## Project Structure

```
.
├── cpu_datapath.v      # Top-level module — wires all submodules together
├── PC_Reg.v             # Program counter register       (module: pc_reg)
├── next_PC.v            # Next-PC / branch-target logic   (module: next_pc_logic)
├── register.v           # Register file, 2R/1W            (module: mem3port)
├── instr_mem.v          # Instruction memory, $readmemh    (module: intr_mem)
├── i_gen.v               # Immediate generator             (module: i_gen)
├── ccu.v                 # Control unit                    (module: control_unit)
├── alu_ctrl.v            # ALU control decode + alu_t enum (module: ALU_CC)
├── alu.v                 # Arithmetic Logic Unit           (module: ALU)
├── data_mem.v            # Data memory                     (module: data_mem)
├── program.hex           # Test program loaded into instruction memory
├── testbench.py          # cocotb testbench (Python)
└── makefile              # cocotb build/run configuration
```

## Requirements

- [Icarus Verilog](http://iverilog.icarus.com/) (`iverilog`, `vvp`)
- Python 3.12+
- [cocotb](https://docs.cocotb.org/) (`pip install cocotb`)

## Running the Testbench

```bash
make
```

This compiles all Verilog sources with Icarus Verilog, loads `program.hex` into instruction memory, and runs `testbench.py` under cocotb. Results are written to `results.xml`; pass/fail summary prints to the terminal.

To clean build artifacts between runs:

```bash
make clean
```

## Test Program (`program.hex`)

A minimal program that loads two immediate values into registers and adds them, to verify the full fetch–decode–execute–writeback cycle:

| Addr | Instruction | Encoding | Effect |
|---|---|---|---|
| 0 | `addi x1, x0, 5` | `00500093` | x1 = 5 |
| 4 | `addi x2, x0, 10` | `00A00113` | x2 = 10 |
| 8 | `add x3, x1, x2` | `002081B3` | x3 = 15 |
| 12 | `jal x0, 0` | `0000006F` | infinite loop (halt) |

**Expected result:** `x3 == 15` in the register file after the program runs.

## Testbench (`testbench.py`)

The cocotb test:
1. Starts a free-running clock and applies reset.
2. Steps the clock for several cycles, logging `x3`'s value from the register file (`dut.regfile.memory[3]`) each cycle — including while it's still undefined (`X`), before the `add` instruction reaches writeback.
3. Asserts that `x3` resolves to `15` by the end of the run.

Sample passing output:

```
cycle 0: x3 = XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX (not written yet)
...
testbench.test_add passed
TESTS=1 PASS=1 FAIL=0 SKIP=0
```

## Notes / Known Limitations

- `instr_mem` is sized for 256 words; `program.hex` only fills the first 4 — the rest reads as `X`, which is fine as long as the program halts (via the trailing `jal x0, 0` self-loop) before reaching uninitialized memory.
- Only a minimal add-only program is exercised in `testbench.py` currently. A more thorough program (exercising `sw`/`lw`, both branch outcomes, `lui`, and `jal` with a real jump target) was prototyped during development and can be swapped in as `program.hex` to stress-test more of the datapath.
- Immediate encodings for S/B/J formats are non-contiguous by the RV32I spec — see `i_gen.v` for the sign-extension/bit-reassembly logic.

## Author's Notes

Built and debugged as a learning project covering: sequential/combinational Verilog design, single-cycle CPU datapath construction, RV32I instruction encoding, and Python-based hardware verification with cocotb.
