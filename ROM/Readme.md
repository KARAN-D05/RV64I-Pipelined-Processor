# Instruction Memory (ROM)

A parameterized, combinational instruction memory for the RV64I pipelined processor. The ROM stores 32-bit instructions and accepts a 64-bit byte address from the Program Counter (PC). The byte address is converted to a word index by shifting right by two bits, allowing each aligned address to select one instruction.

The functional implementation initializes the memory to zero and loads instruction contents from `Program.hex` using `$readmemh`. A separate hardcoded ROM implementation is used for synthesis, timing, and power characterization.

## Features

- Parameterized memory depth, instruction width, and PC address width
- 32-bit instruction output
- 64-bit byte-address input
- Word-index mapping using `addr >> 2`
- Asynchronous combinational instruction reads
- Instruction initialization using `$readmemh`
- Separate hardcoded implementation for hardware characterization
- Supports 1,024 instruction words (4 KiB) by default

<p align="center">
  <img src="images/ROM_waveform.png" width="1000"/>
  <br>
  <sub>Instruction Memory RTL Simulation</sub>
</p>

## Synthesis Results

**Technology:** Sky130 HD
**Synthesis Tool:** Yosys
**Characterized Implementation:** Hardcoded ROM (`ROM_analysis.sv`)

| Metric               |           Value |
| -------------------- | --------------  |
| Standard Cells       |           3,565 |
| Flip-Flops           |               0 |
| Synthesized Memories |               0 |
| Area                 | 24,908.8896 µm² |

The hardcoded ROM was synthesized into combinational standard-cell logic rather than a dedicated memory macro.

## Static Timing Analysis (OpenSTA)

## Static Timing Analysis (OpenSTA)

| Metric                        |                    Value |
| ----------------------------- | -----------------------  |
| Clock Period                  |        10 ns (reference) |
| Critical Path                 |    `addr[5]` → `out[15]` |
| Estimated Critical Path Delay |                 10.66 ns |
| Estimated Fmax                |               ~93.81 MHz |

## Power Analysis

**Analysis Conditions:** As configured in the characterization flow

| Metric          |       Power |
| --------------- | ----------  |
| Internal Power  |     6.79 mW |
| Switching Power |     4.79 mW |
| Leakage Power   |     7.84 nW |
| **Total Power** | **11.6 mW** |
