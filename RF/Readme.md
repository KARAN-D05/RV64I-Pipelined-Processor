# Register File (RF)

A parameterized 64-bit register file containing 32 registers with two asynchronous read ports and one synchronous write port. Register `x0` is hardwired to zero, and writes to it are discarded.

## Features

- Parameterized register width and number of registers
- Two independent combinational read ports
- Synchronous writes on the active clock edge
- Hardwired zero register (`x0`)
- Holds stored values when no write occurs
- Supports simultaneous reads from two registers

<p align="center">
  <img src="images/RF_waveform.png" width="1000"/>
  <br>
  <sub>Register File</sub>
</p>

## Synthesis Results

**Technology:** Sky130 HD
**Synthesis Tool:** Yosys

| Metric         |           Value |
| -------------- | -------------- |
| Standard Cells |           8,811 |
| Flip-Flops     |           1,984 |
| Area           | 89,365.7088 µm² |

## Static Timing Analysis (OpenSTA)

Clock period constraint:

```
10 ns
```

| Metric                  |     Value |
| ----------------------- | -------- |
| Clock Period            |     10 ns |
| Worst Slack             |   9.22 ns |
| Estimated Critical Path |   0.78 ns |
| Estimated Fmax          | ~1.28 GHz |

## Power Analysis

Operating Frequency: **100 MHz** (10 ns clock period)

| Metric      | Value |
| ----------- | ---- |
| Total Power | 12.1 mW  |
