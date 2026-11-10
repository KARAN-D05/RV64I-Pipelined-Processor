# RV64I Pipelined Processor (CORE)

The CORE integrates the processor datapath, control logic, pipeline registers, forwarding network, and hazard-handling units into a 64-bit, five-stage, in-order pipelined processor implementing a documented subset of the RISC-V RV64I Base Integer ISA.

The processor is organized into five stages: Instruction Fetch (IF), Instruction Decode (ID), Execute (EX), Memory Access (MEM), and Write Back (WB). Each stage performs a distinct part of instruction execution, with pipeline registers separating successive stages and allowing multiple instructions to be processed concurrently.

## Architecture

| Stage | Name | Function |
|---|---|---|
| IF | Instruction Fetch | Fetches instructions and maintains the program counter. |
| ID | Instruction Decode | Decodes instructions, reads source registers, and generates control signals. |
| EX | Execute | Performs ALU operations, evaluates branch conditions, and calculates target addresses. |
| MEM | Memory Access | Handles data memory read and write operations. |
| WB | Write Back | Selects the appropriate result and writes it into the register file. |

The datapath uses a 64-bit architecture with a 32-entry integer register file, separate instruction and data memory interfaces, and dedicated control and execution units.

## Data Forwarding Network

The processor implements a multi-path forwarding network to resolve data dependencies between instructions without unnecessarily waiting for register-file write-back.

Four forwarding paths are implemented:

| Forwarding Path | Source → Destination | Function |
|---|---|---|
| EEF | EX/MEM → EX | Forwards the result of the immediately preceding instruction to the EX-stage operand path. |
| MEF | MEM/WB → EX | Forwards a previously completed result to the EX-stage operand path. |
| WIF | WB → ID | Forwards write-back data to the instruction decode/register-read path. |
| MMF | WB → MEM | Forwards write-back data to the data-memory store-data path. |

The Execution Forwarding Unit (EFU) integrates the EX-stage forwarding mechanisms and selects the appropriate operand source. Forwarding priority ensures that when multiple older instructions target the same source register, the most recent available result is selected.

This network handles supported RAW (Read After Write) dependencies across different pipeline stages, reducing the need for pipeline stalls.

## Hazard Handling

The processor integrates data and control hazard management through the Hazard Handling Unit (HHU), which combines the Hazard Detection Unit (HDU) and Branch Handling Unit (BHU).

### Data Hazard Handling

The HDU detects load-use RAW dependencies between instructions in the ID and EX stages.

Since load data is not available early enough for the immediately following instruction's EX stage, the HDU:

- Detects dependencies between the load destination register and the dependent instruction's source registers.
- Stalls the program counter and IF/ID pipeline register.
- Suppresses the ID/EX control word to insert a bubble into the pipeline.

Other supported data dependencies are handled by the forwarding network.

### Control Hazard Handling

The processor resolves conditional branches and jumps in the EX stage.

- The Branch Control Unit (BCU) evaluates branch conditions.
- The Target Address Generator (TAG) calculates branch and jump target addresses.
- The BHU handles pipeline flushing when a branch or jump is taken.

On a taken branch or jump:

- The program counter is redirected to the calculated target address.
- The instruction entering IF/ID is replaced with a RISC-V NOP (`32'h00000013`).
- The ID/EX control word is zeroed, preventing the younger instruction from producing architectural side effects.

The HHU coordinates the HDU and BHU outputs, giving branch handling priority when control flow must be redirected.

## Pipeline Control

Pipeline registers carry instruction data, operands, control signals, and execution results between successive stages.

Valid-bit tracking is implemented in the ID/EX, EX/MEM, and MEM/WB pipeline registers. These bits distinguish valid instructions from bubbles and allow the pipeline to track instruction progression through execution and write-back.

The integrated pipeline control coordinates:

- Normal instruction advancement.
- Load-use stalls.
- Bubble insertion.
- Branch and jump flushing.
- Prevention of invalid instructions from committing architectural state changes.

## Memory Organization

The processor uses separate instruction and data memory interfaces.

- **Data width:** 64 bits.
- **Data memory capacity:** 1 KiB.
- **Addressing:** Byte-addressable.
- **Byte ordering:** Little-endian.
- **Register file:** 32 registers, each 64 bits wide.
- **Register x0:** Hardwired to zero.

## Verification

The integrated CORE is validated through RTL simulation, synthesis, and post-synthesis gate-level simulation (GLS).

Verification covers:

- Instruction execution and architectural register updates.
- Arithmetic and logical operations.
- Load and store instructions.
- Data forwarding paths.
- Load-use hazard detection and stalling.
- Conditional branch and jump execution.
- Pipeline flushing and wrong-path instruction suppression.
- Architectural state consistency between RTL and gate-level simulation.

Directed instruction programs are used to exercise individual architectural features and integrated processor behavior.
