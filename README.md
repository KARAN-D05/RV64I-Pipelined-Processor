# RV64I Pipelined Processor
The processor follows a **five-stage, in-order pipeline architecture** (IF, ID, EX, MEM, WB), implementing a documented subset of the **RV64I Base Integer ISA**. It incorporates dedicated hazard handling, data forwarding paths, pipeline stalling, and control-flow redirection to manage instruction dependencies and execution flow.

## 🛠️ Tools & Technologies
![RISC-V](https://img.shields.io/badge/ISA-RISC_V_(RV64I)-3949AB?style=flat-square)
![5-Stage Pipeline](https://img.shields.io/badge/Design-5--Stage_Pipeline-D50000?style=flat-square)
![Icarus Verilog](https://img.shields.io/badge/Icarus_Verilog-Simulation-8E24AA?style=flat-square)
![Verilator](https://img.shields.io/badge/Verilator-Linting-00897B?style=flat-square)
![GTKWave](https://img.shields.io/badge/GTKWave-Waveforms-F57C00?style=flat-square)
![Yosys](https://img.shields.io/badge/Yosys-Logic_Synthesis-43A047?style=flat-square)

## 📚 Documentation
- [Instruction Set Architecture](ISA.md)

## ↗️ EX/MEM → EX Forwarding

This test verifies EX/MEM-to-EX data forwarding by executing consecutive dependent instructions, handling RAW dependencies with a dependency distance of 1, where the second instruction consumes the result produced by the preceding instruction.

`EX_MEM-EX.asm`

```asm
        ADDI x1, x0, 5      ; Initialize x1 = 5
        ADD  x2, x1, x1     ; x2 = x1 + x1
```

**Program Source:** [EX_MEM-EX.hex](CORE/Programs/EX_MEM-EX.hex)

> The waveform captures the forwarding operation, where the result (`5`) from the EX/MEM pipeline register is routed to both ALU operands of the dependent ADD instruction, producing the expected result (`10`) without stalling the pipeline.

`[x1 = 5, x2 = 10]`

<p align="center">
  <img src="CORE/images/EX_MEM-EX_Waveform.png" width="1000"/>
  <br>
  <sub>RTL simulation demonstrating EX/MEM-to-EX forwarding through the ALU operand selection and execution datapath.</sub>
</p>

## ↗️ MEM/WB → EX Forwarding

This test verifies MEM/WB-to-EX data forwarding by executing dependent instructions separated by one independent instruction, handling RAW dependencies with a dependency distance of 2.

`MEM_WB-EX.asm`

```asm
        ADDI x1, x0, 5      ; Initialize x1 = 5
        ADDI x6, x0, 7      ; Independent instruction
        ADD  x2, x1, x1     ; x2 = x1 + x1
```

**Program Source:** [MEM_WB-EX.hex](CORE/Programs/MEM_WB-EX.hex)

> The waveform captures the MEM/WB-to-EX forwarding operation, where the result (`5`) produced by the first ADDI instruction is forwarded to both ALU operands of the dependent ADD instruction, producing `10`.

`[x1 = 5, x2 = 10, x6 = 7]`

<p align="center">
  <img src="CORE/images/MEM_WB-EX_Waveform.png" width="1000"/>
  <br>
  <sub>RTL simulation demonstrating MEM/WB-to-EX forwarding through the ALU operand selection and execution datapath.</sub>
</p>

## ⚙️ Implemented Modules

| Module               | Description                                                       | Status |
| -------------------- | ------------------------------------------------------------------| ------ |
| [RF](RF) | Stores operands and intermediate results during program execution | ✅     |
| [SE](SE) | Extracts, reconstructs, and extends RV64I instruction immediates to 64 bits | ✅      |
| [PC](PC) | Maintains the current address and selects sequential or branch addresses | ✅      |
| [ROM](ROM) | Stores and fetches 32-bit instructions using the PC's byte address | ✅ |
| [ALU](ALU) | Performs arithmetic, logical, shift operations and generates comparision signals | ✅ |
| [TAG](TAG) | Calculates branch and jump targets and generates return addresses | ✅      |
| [RAM](MEM) | implements byte-addressable memory with support for aligned and misaligned accesses | ✅ |
| [CU](CU) | decodes 49 RV64I instructions and generates datapath control signals | ✅ |
| [EEF](EEF) | Detects EX/MEM-to-EX RAW dependencies and forwards results to ALU operands | ✅ |
| [MEF](MEF) | Detects MEM/WB-to-EX RAW dependencies and forwards results to ALU operands | ✅ |
| [EFU](EFU) | Integrates EEF and MEF, forwarding ALU operands with EX/MEM priority over MEM/WB | ✅ |
| [MMF](MMF) | Detects MEM/WB-to-MEM RAW dependencies and forwards results to RAM data input | ✅ |
| [WIF](WIF) | Detects MEM/WB-to-ID RAW dependencies and forwards results to IF/ID data input | ✅ |
| [HDU](HDU) | Detects load-use RAW hazards, stalls the pipeline, and inserts bubbles | ✅ |
| [BCU](BCU) | Determines whether branches and unconditional jumps should redirect program execution | ✅ |
| [BHU](BHU) | Handles pipeline flushing by injecting NOPs when branches or jumps are taken | ✅ |
| [HHU](HHU) | Integrates HDU and BHU to handle load-use and control hazards through stalls and flushes | ✅ |
| [IFID](IFID) | 96-bit pipeline register carrying PC and instruction between IF and ID | ✅ |
| [IDEX](IDEX) | 291-bit pipeline register carrying operands, control signals, metadata between ID and EX | ✅ |
| [EXMEM](EXMEM) | 274-bit pipeline register carrying execution results, forwarding data between EX and MEM | ✅ |
| [MEMWB](MEMWB) | 264-bit pipeline register carrying memory, execution, writeback data between MEM and WB | ✅ |
| [CORE](CORE) | Integrated 64-bit pipelined processor with forwarding and hazard handling | ✅ |

## 🔄 Implemented Pipeline Stages
| Stage | Description                                                                              | Status |
| ----- | ---------------------------------------------------------------------------------------- | ------ |
| [IF](IF)    | Integrates PC and ROM to fetch instructions and their addresses                          | ✅     |
| [ID](ID)    | Integrates RF, SE, and CU to read operands, generate immediates, and decode instructions | ✅     |
| [EX](EX)    | Integrates ALU and TAG to perform operations and calculate target addresses              | ✅     |
| [MEM](MEM)  | Integrates the data memory for load/store operations                                     | ✅     |
| [WB](WB)    | Selects the appropriate result for register write-back                                   | ✅     |

## ⚙️ Supported Instructions

> 49 of 52 RV64I Base ISA instructions implemented

| Category | Instructions |
|---|---|
| Upper Immediate | `LUI`, `AUIPC` |
| Control Transfer | `JAL`, `JALR` |
| Conditional Branch | `BEQ`, `BNE`, `BLT`, `BGE`, `BLTU`, `BGEU` |
| Loads | `LB`, `LH`, `LW`, `LD`, `LBU`, `LHU`, `LWU` |
| Stores | `SB`, `SH`, `SW`, `SD` |
| Immediate Arithmetic & Logic | `ADDI`, `SLTI`, `SLTIU`, `XORI`, `ORI`, `ANDI` |
| Immediate Shifts | `SLLI`, `SRLI`, `SRAI` |
| Register Arithmetic & Logic | `ADD`, `SUB`, `SLL`, `SLT`, `SLTU`, `XOR`, `SRL`, `SRA`, `OR`, `AND` |
| Word Immediate Operations | `ADDIW`, `SLLIW`, `SRLIW`, `SRAIW` |
| Word Register Operations | `ADDW`, `SUBW`, `SLLW`, `SRLW`, `SRAW` |

## 📜License
- Source code and HDL files are licensed under the MIT License.
- Documentation, diagrams, images, and PDFs are licensed under Creative Commons Attribution 4.0 (CC BY 4.0).
