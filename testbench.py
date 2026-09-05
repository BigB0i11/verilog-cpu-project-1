import cocotb
from cocotb.triggers import RisingEdge, ClockCycles, ReadOnly
from cocotb.clock import Clock

@cocotb.test()
async def test_add(dut):

    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())

    dut.rst.value = 1
    await ClockCycles(dut.clk, 2)
    dut.rst.value = 0
    await RisingEdge(dut.clk)

    for i in range(6):
        await RisingEdge(dut.clk)
        await ReadOnly()

        raw = dut.regfile.memory[3].value

        if raw.is_resolvable:
            result = int(raw)
        else:
            dut._log.info(f"cycle {i}: x3 = {raw} (not written yet)")

    
    final = dut.regfile.memory[3].value
    assert final.is_resolvable, "x3 was never written — check writeback logic"
    result = int(final)
    assert result == 15, f"add failed   x3 = {result}, expected 15"
