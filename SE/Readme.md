# Sign Extender (SE)

The Sign Extender is a combinational RTL module that extracts and reconstructs immediates from RV64I instruction encodings. It supports I-type, S-type, B-type, U-type, and J-type immediates, including the special handling required for 64-bit shift instructions.

## Features

- Supports I, S, B, U, and J instruction formats.
- Reconstructs immediate values from their encoded instruction bit positions.
- Sign-extends immediates to 64 bits where required.
- Zero-extends the 6-bit shift amount for SLLI, SRLI, and SRAI.
- Outputs zero for unsupported instruction opcodes.
- Verified using directed test cases covering positive and negative immediates, boundary values, and immediate-field reconstruction.

<p align="center">
  <img src="images/SE_waveform.png" width="800" alt="Sign Extender RTL Simulation Waveform">
  <br>
  <em>RTL simulation waveform showing immediate reconstruction and sign/zero extension.</em>
</p>

## Synthesis Results

**Technology:** Sky130HD Standard Cell Library
**Synthesis Tool:** Yosys

| Metric               |       Result |
| -------------------- | -----------  |
| Total Standard Cells |           89 |
| Cell Area            | 670.6432 µm² |

## Static Timing Analysis (STA)

| Metric                    |   Result |
| ------------------------- | -------  |
| Worst Reported Path Delay |  3.05 ns |
| Estimated Fmax Equivalent | ~328 MHz |

## Power Analysis

**Analysis Corner:** Sky130HD
**Clock Period Reference:** 10 ns (100 MHz)

| Power Component |        Power |
| --------------- | -----------  |
| Internal Power  |      54.3 µW |
| Switching Power |      22.7 µW |
| Leakage Power   | ~0.000637 µW |
| **Total Power** |   77.0 µW   |
