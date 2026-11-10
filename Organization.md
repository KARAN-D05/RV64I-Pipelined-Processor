# Computer Organization

The processor follows a **Harvard architecture** with separate instruction and data memory interfaces. It implements a 64-bit, five-stage, in-order pipeline based on a documented subset of the RV64I Base Integer ISA.

Instruction execution is divided into five stages: Instruction Fetch (IF), Instruction Decode (ID), Execute (EX), Memory Access (MEM), and Write Back (WB). Pipeline registers separate successive stages, allowing multiple instructions to execute concurrently. A dedicated forwarding network resolves data dependencies, while integrated hazard-handling logic manages pipeline stalls, bubbles, and control-flow changes.

## Architectural Overview

* Harvard Architecture
* 64-bit Datapath
* 32-bit Instruction Width
* Five-Stage In-Order Pipeline
* 32 × 64-bit Integer Register File
* 1 KiB Byte-Addressable Data Memory
* Little-Endian Memory Organization
* Four-Path Data Forwarding Network
* Load-Use Hazard Detection
* Branch and Jump Handling
* Pipeline Stalling, Bubble Insertion, and Flushing

## Instruction Path

Instruction fetching is handled by the dedicated Instruction Fetch (IF) stage.

The Program Counter supplies a 64-bit address to the instruction memory, which returns a 32-bit instruction. The instruction and its corresponding PC are captured by the IF/ID pipeline register and forwarded to the Instruction Decode (ID) stage.

```
Program Counter
      │
      ▼
Instruction Memory
      │
      ▼
   IF/ID Register
      │
      ▼
Instruction Decode
```

The IF stage also receives branch and jump redirection information from the EX stage. During normal execution, the PC advances to the next sequential instruction. When a branch or jump is taken, the target address is loaded into the PC.

## Register and Decode Path

The ID stage decodes the instruction and generates the corresponding control signals.

The register file contains 32 architectural integer registers, each 64 bits wide. It provides two asynchronous read ports and one synchronous write port. Register `x0` is hardwired to zero.

The ID stage extracts the source and destination register indices, generates the immediate operand, and reads the required register operands.

```
             IF/ID Register
                    │
                    ▼
              Instruction
                 Decode
                    │
          ┌─────────┴─────────┐
          ▼                   ▼
      Register File      Immediate
       Read Ports        Generator
          │                   │
          └─────────┬─────────┘
                    │
                    ▼
                ID/EX
             Pipeline Register
```

The decoded operands, immediate, PC, register indices, and control word are captured by the ID/EX pipeline register before entering the Execute stage.

## Data Forwarding Network

The processor implements a four-path forwarding network to resolve Read After Write (RAW) data dependencies between instructions in different pipeline stages.

Instead of waiting for an older instruction to update the register file, the forwarding network makes available results directly accessible to dependent instructions.

The four forwarding paths are:

* **EEF (EX/MEM → EX):** Forwards the result from EX/MEM to the Execute stage.
* **MEF (MEM/WB → EX):** Forwards the write-back result to the Execute stage.
* **WIF (MEM/WB → ID):** Forwards write-back data to the register-read path in ID.
* **MMF (MEM/WB → MEM):** Forwards write-back data to the store-data input in MEM.

The Execution Forwarding Unit (EFU) integrates EEF and MEF, selecting the appropriate EX-stage operands. WIF and MMF operate through their respective forwarding units.

```
EX/MEM ───────────────┐
                      ├──> EFU ───> EX
MEM/WB ───────────────┘

MEM/WB ───> WIF ───> ID

MEM/WB ───> MMF ───> MEM
```

The forwarding logic checks source and destination register indices along with register-write controls to determine whether forwarding is required. When multiple older instructions target the same source register, the more recent available result takes priority in the EX-stage forwarding logic.

## Hazard Handling

Pipeline dependencies that cannot be resolved through forwarding require explicit pipeline control.

The Hazard Handling Unit (HHU) integrates the Hazard Detection Unit (HDU) and Branch Handling Unit (BHU) to coordinate data and control hazard management.

### Data Hazard Handling

The HDU detects load-use RAW dependencies between the instruction in ID and a load instruction in ID/EX.

Since load data is not available in time for the immediately dependent instruction's Execute stage, the processor inserts a pipeline bubble.

When a load-use hazard is detected:

* The Program Counter is stalled.
* The IF/ID pipeline register is held.
* The ID/EX control word is suppressed, preventing the dependent instruction from performing an operation prematurely.

Execution resumes after the required stall cycle, allowing the dependent instruction to proceed with the loaded data.

### Control Hazard Handling

Conditional branches and jumps are resolved in the EX stage.

The Branch Control Unit (BCU) evaluates branch conditions using the comparison results generated by the Execute stage. Branch and jump target addresses are calculated through the target-generation logic in the EX module.

When a branch or jump is taken:

* The Program Counter is redirected to the calculated target address.
* The instruction entering IF/ID is replaced with a RISC-V NOP (`32'h00000013`).
* The ID/EX control word is zeroed, preventing the younger instruction from producing architectural side effects.

The BHU implements the flushing mechanism, while the HHU coordinates it with the HDU. Branch handling takes precedence over the normal HDU control-word output when a redirect is required.

## Execute Datapath

The EX stage performs arithmetic, logical, and comparison operations using the 64-bit ALU.

Its operands are selected from the values carried by ID/EX or the forwarding network. The immediate generator supplies the required sign-extended immediate operand.

The EX stage also produces branch comparison results and calculates branch and jump target addresses.

```
 ID/EX Register
       │
       ▼
  Forwarding Network
       │
       ▼
      ALU
       │
       ├──────────> ALU Result
       │
       ├──────────> Branch Comparison
       │
       └──────────> Target Address
                         │
                         ▼
                    Program Counter
```

The execution results, store data, destination register index, and relevant control signals are captured by the EX/MEM pipeline register.

## Memory Path

The MEM stage handles load and store instructions through a dedicated 1 KiB, byte-addressable, little-endian data memory.

The ALU result from EX/MEM supplies the memory address. Store operations use the forwarded or registered store-data operand, while load operations return the requested memory data.

```
              EX/MEM Register
                     │
             ┌───────┴───────┐
             ▼               ▼
        ALU Result       Store Data
             │               ▲
             ▼               │
          Data RAM          MMF
             │
             ▼
        Load Data
             │
             ▼
         MEM/WB
```

The memory operation width and read/write controls are carried through the pipeline alongside the corresponding instruction data.

## Write-Back Path

The WB stage selects the result that will be written into the architectural register file.

The Write-Back unit (WB) selects between the available result sources:

* ALU result.
* Data memory result.
* PC-related result.
* Target-related result.

The selected 64-bit result is written into the destination register through the register file's synchronous write port.

```
             MEM/WB Register
                    │
          ┌─────────┼─────────┐
          ▼         ▼         ▼
       ALU Data  Memory Data  PC / Target Data
          │         │         │
          └─────────┼─────────┘
                    ▼
               WB Selection
                    │
                    ▼
               Register File
```

The same write-back result is also made available to the forwarding network for dependent instructions in earlier pipeline stages.

## Pipeline Organization and Control

Pipeline registers carry instruction information, operands, execution results, and control signals between successive stages.

The processor uses four pipeline registers:

* **IF/ID:** Carries the fetched instruction and its PC.
* **ID/EX:** Carries decoded operands, immediate, PC, register indices, and control word.
* **EX/MEM:** Carries ALU results, store data, target information, and memory/write-back controls.
* **MEM/WB:** Carries memory and execution results, destination register index, and write-back controls.

Valid-bit tracking is implemented in ID/EX, EX/MEM, and MEM/WB to distinguish valid instructions from bubbles.

Pipeline control coordinates normal instruction advancement, load-use stalls, bubble insertion, and branch/jump flushing while maintaining correct in-order architectural execution.
