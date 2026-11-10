# IF/ID Pipeline Register

The IF/ID pipeline register stores the program counter and fetched instruction between the Instruction Fetch (IF) and Instruction Decode (ID) stages. It captures both values synchronously on the rising edge of the clock and supports asynchronous reset and stall control.

<p align="center">
  <img src="images/IFID_Waveform.png" width="1000">
</p>

## Features

- Parameterized instruction and program counter widths.
- Stores a 32-bit instruction and 64-bit program counter by default.
- Synchronous data capture on the rising clock edge.
- Asynchronous active-high reset.
- Stall control to hold the registered instruction and PC.
- Reset takes priority over stall.
- Independent instruction and PC input/output interfaces.

## Interface

| Signal | Direction | Width | Description |
|---|---|---|---|
| `instr_in` | Input | 32 | Instruction from the BHU output |
| `pc_in` | Input | 64 | Program counter from the IF stage |
| `clk` | Input | 1 | Clock signal |
| `rst` | Input | 1 | Asynchronous active-high reset |
| `stall` | Input | 1 | Holds the current instruction and PC when asserted |
| `instr_out` | Output | 32 | Registered instruction delivered to ID |
| `pc_out` | Output | 64 | Registered program counter delivered to ID |

## Operation

The register captures the instruction and corresponding program counter together on every rising clock edge when stall is deasserted.

During reset, both outputs are asynchronously cleared to zero. When stall is asserted, the register retains its current instruction and PC, ignoring changes at its inputs.

The control priority is:

**Reset > Stall > Capture**

The instruction input is connected to the BHU's `if_id_out` signal, allowing the register to receive either the fetched instruction or an injected NOP when a branch or jump is taken.

The stall input is driven by the HHU's `stall` output. During a load-use hazard, this holds the current IF/ID instruction while the PC is stalled and a bubble is inserted into ID/EX.

## Verification

- Directed test scenarios covering normal operation, stall behavior, and reset priority.
- Verified asynchronous reset assertion and deassertion.
- Verified simultaneous PC and instruction capture.
- Verified sequential instruction capture.
- Verified that both outputs hold their values while stall is asserted, even when inputs change.
- Verified capture resumes after stall deassertion.
- Verified reset priority when reset and stall are asserted simultaneously.
- RTL simulation and Gate-Level Simulation (GLS) completed successfully.
