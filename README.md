# RV64I Pipelined Processor

## 🛠️ Tools & Technologies
![RISC-V](https://img.shields.io/badge/ISA-RISC_V_(RV64I)-3949AB?style=flat-square)
![5-Stage Pipeline](https://img.shields.io/badge/Design-5--Stage_Pipeline-D50000?style=flat-square)
![Icarus Verilog](https://img.shields.io/badge/Icarus_Verilog-Simulation-8E24AA?style=flat-square)
![Verilator](https://img.shields.io/badge/Verilator-Linting-00897B?style=flat-square)
![GTKWave](https://img.shields.io/badge/GTKWave-Waveforms-F57C00?style=flat-square)
![Yosys](https://img.shields.io/badge/Yosys-Logic_Synthesis-43A047?style=flat-square)

## 📚 Documentation
- [Instruction Set Architecture](ISA.md)
- [Computer Organization](Organization.md)

## 🔄 Implemented Pipeline Stages
| Stage | Description                                                                              | Status |
| ----- | ---------------------------------------------------------------------------------------- | ------ |
| IF    | Integrates PC and ROM to fetch instructions and their addresses                          | ✅     |
| ID    | Integrates RF, SE, and CU to read operands, generate immediates, and decode instructions | 🔄     |
| EX    | Integrates ALU and TAG to perform operations and calculate target addresses              | ✅     |
| MEM   | Integrates the data memory for load/store operations                                     | ✅     |
| WB    | Selects the appropriate result for register write-back                                   | 🔄     |

## ⚙️ Implemented Modules

| Module               | Description                                                       | Status |
| -------------------- | ------------------------------------------------------------------| ------ |
| RF | Stores operands and intermediate results during program execution | ✅     |
| SE | Extracts, reconstructs, and extends RV64I instruction immediates to 64 bits | ✅      |
| PC | Maintains the current address and selects sequential or branch addresses | ✅      |
| ROM | Stores and fetches 32-bit instructions using the PC's byte address | ✅ |
| ALU | Performs arithmetic, logical, shift operations and generates comparision signals | ✅ |
| TAG | Calculates branch and jump targets and generates return addresses | ✅      |
| RAM | implements byte-addressable memory with support for aligned and misaligned accesses | ✅ |
| CU | decodes 49 RV64I instructions and generates datapath control signals | ✅ |

## 📜License
- Source code and HDL files are licensed under the MIT License.
- Documentation, diagrams, images, and PDFs are licensed under Creative Commons Attribution 4.0 (CC BY 4.0).

Design and optimization of high-throughput arithmetic datapaths by taking proven arithmetic units and investigating how architectural techniques such as pipelining, parallelism and vectorization can improve their performance beyond their conventional implementations.
