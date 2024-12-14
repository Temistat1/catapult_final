# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.triggers import RisingEdge
from cocotb.regression import TestFactory
import random

@cocotb.test()
async def test_fir_filter(dut):
    """
    Testbench for the FIR Filter module.
    """
    # Initialize signals
    dut.clk <= 0
    dut.rst <= 1
    dut.valid_in <= 0
    dut.data_in <= 0

    # Reset the DUT
    await cocotb.triggers.Timer(20, units="ns")
    dut.rst <= 0
    await cocotb.triggers.Timer(20, units="ns")

    # Input stimulus
    input_sequence = [random.randint(0, 255) for _ in range(16)]
    expected_outputs = []  # Replace with actual expected outputs based on your coefficients

    dut.valid_in <= 1

    for value in input_sequence:
        dut.data_in <= value
        await RisingEdge(dut.clk)
        expected_outputs.append(0)  # Populate with actual expected values

    dut.valid_in <= 0

    # Wait for output to stabilize
    for i, expected in enumerate(expected_outputs):
        await RisingEdge(dut.clk)
        if dut.valid_out.value:
            assert dut.data_out.value == expected, f"Mismatch at index {i}: got {dut.data_out.value}, expected {expected}"

@cocotb.coroutine
async def clock_gen(signal, period=10):
    """
    Clock generator for the testbench.
    """
    while True:
        signal <= 0
        await cocotb.triggers.Timer(period // 2, units="ns")
        signal <= 1
        await cocotb.triggers.Timer(period // 2, units="ns")

# Setup clock
@cocotb.test()
async def setup_clock(dut):
    cocotb.fork(clock_gen(dut.clk))
