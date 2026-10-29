# Sign Extender (SE)

The Sign Extender is a combinational RTL module that extracts and reconstructs immediates from RV64I instruction encodings. It supports I-type, S-type, B-type, U-type, and J-type immediates, including the special handling required for 64-bit shift instructions.

## Features

- Supports I, S, B, U, and J instruction formats.
- Reconstructs immediate values from their encoded instruction bit positions.
- Sign-extends immediates to 64 bits where required.
- Zero-extends shift amounts for SLLI, SRLI, SRAI, SLLIW, SRLIW, and SRAIW (6-bit amounts for RV64I shifts and 5-bit amounts for word shifts).
- Supports OP-IMM-32 decoding for ADDIW and immediate word shifts.
- Outputs zero for unsupported instruction opcodes.
- Verified using 40 directed test cases covering positive and negative immediates, boundary values, instruction formats, and word-immediate decoding.

<p align="center">
  <img src="images/SE_Waveform.png" width="1000" alt="Sign Extender RTL Simulation Waveform">
  <br>
  <em>RTL simulation waveform showing immediate reconstruction and sign/zero extension.</em>
</p>
