# RV64I Pipelined Processor (CORE)

The CORE integrates the processor's datapath, control logic, pipeline registers, forwarding network, and hazard handling units into a five-stage, 64-bit scalar processor implementing a documented subset of the RISC-V RV64I Base Integer ISA.

The processor follows an in-order execution model with separate instruction-fetch, decode, execute, memory-access, and write-back stages.

## Architecture

The processor implements a conventional five-stage pipeline:

| Stage | Name | Description |
|---|---|---|
| IF | Instruction Fetch | Fetches instructions and maintains the program counter. |
| ID | Instruction Decode | Decodes instructions, reads source registers, and generates control signals. |
| EX | Execute | Performs ALU operations, evaluates branches, and calculates target addresses. |
| MEM | Memory Access | Performs load and store operations. |
| WB | Write Back | Selects and writes the execution or memory result into the register file. |

## Features

- 64-bit datapath implementing a subset of RV64I.
- Five-stage, in-order pipelined architecture.
- 32-entry, 64-bit integer register file with `x0` hardwired to zero.
- Byte-addressable, little-endian data memory.
- Pipeline registers between successive stages.
- Valid-bit tracking across ID/EX, EX/MEM, and MEM/WB.
- Separate instruction and data memory interfaces.

## Data Forwarding Network

The forwarding network resolves data dependencies between instructions in different pipeline stages by selecting the most recent available operand without unnecessarily waiting for register-file write-back.

Four forwarding paths are implemented:

| Forwarding Unit | Data Path | Description |
|---|---|---|
| EEF | EX/MEM → EX | Forwards the result from EX/MEM to the EX-stage operand path. |
| MEF | MEM/WB → EX | Forwards the write-back result to the EX-stage operand path. |
| WIF | WB → ID | Forwards write-back data to the instruction decode/register-read path. |
| MMF | WB → MEM | Forwards write-back data to the data-memory store-data path. |

The Execution Forwarding Unit (EFU) integrates the EX-stage forwarding paths and handles forwarding priority, selecting the appropriate operand source.

## Hazard Handling

The processor integrates data and control hazard management through the Hazard Handling Unit (HHU).

### Data Hazards

The Hazard Detection Unit (HDU) detects load-use RAW dependencies between instructions in the pipeline.

When a load-use hazard is detected:

- The PC is stalled.
- The IF/ID pipeline register is stalled.
- A bubble is inserted into ID/EX by suppressing the corresponding control signals.

Forwarding handles other supported data dependencies through the forwarding network.

### Control Hazards

The Branch Control Unit (BCU) evaluates conditional branch instructions in the EX stage.

The Target Address Generator (TAG) calculates branch and jump target addresses.

When a branch or jump is taken:

- The program counter is redirected to the target address.
- The instruction entering IF/ID is replaced with a RISC-V NOP (`32'h00000013`).
- The ID/EX control word is zeroed to prevent the younger instruction from producing architectural side effects.

The Branch Handling Unit (BHU) implements the flushing mechanism, while the HHU integrates branch handling with load-use hazard detection.

## Pipeline Control

Pipeline registers maintain the instruction state and associated information as instructions advance through the datapath.

Valid bits are implemented in:

- ID/EX
- EX/MEM
- MEM/WB

These signals track valid instructions through the later pipeline stages and distinguish active instructions from bubbles.

The pipeline control logic coordinates stalling, bubble insertion, and flushing to maintain correct in-order execution.

## Verification

The CORE is verified through RTL simulation and post-synthesis gate-level simulation.

Verification focuses on:

- Instruction execution and architectural register updates.
- Arithmetic and logical operations.
- Load and store operations.
- Data forwarding across the implemented forwarding paths.
- Load-use hazard detection and pipeline stalling.
- Conditional branch execution.
- Taken-branch flushing and wrong-path instruction suppression.
- Correct architectural state after program execution.
