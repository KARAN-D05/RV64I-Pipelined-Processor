# RV64I Pipelined Processor

## 🛠️ Tools & Technologies
![RISC-V](https://img.shields.io/badge/ISA-RISC_-_V_(RV64I)-3949AB?style=flat-square)
![Icarus Verilog](https://img.shields.io/badge/Icarus_Verilog-Simulation-8E24AA?style=flat-square)
![Verilator](https://img.shields.io/badge/Verilator-Linting-00897B?style=flat-square)
![GTKWave](https://img.shields.io/badge/GTKWave-Waveform-F57C00?style=flat-square)
![Yosys](https://img.shields.io/badge/Yosys-Synthesis-43A047?style=flat-square)
![5-Stage Pipeline](https://img.shields.io/badge/Design-5--Stage_Pipeline-D81B60?style=flat-square)

## 📚 Documentation
- [Instruction Set Architecture](ISA.md)
- [Computer Organization](Organization.md)

## ⚙️ Implemented Modules

| Module               | Description                                                       | Status |
| -------------------- | ------------------------------------------------------------------| ------ |
| RF | Stores operands and intermediate results during program execution | ✅     |
| SE | Extracts, reconstructs, and extends RV64I instruction immediates to 64 bits | ✅      |
| PC | Maintains the current address and selects sequential or branch addresses | ✅      |
| ROM | Stores and fetches 32-bit instructions using the PC's byte address | ✅ |
| ALU | Performs arithmetic, logical, shift operations and generates comparision signals | ✅ |
| TAG | Calculates branch and jump targets and generates return addresses | ✅      |

## 📜License
- Source code and HDL files are licensed under the MIT License.
- Documentation, diagrams, images, and PDFs are licensed under Creative Commons Attribution 4.0 (CC BY 4.0).

Design and optimization of high-throughput arithmetic datapaths by taking proven arithmetic units and investigating how architectural techniques such as pipelining, parallelism and vectorization can improve their performance beyond their conventional implementations.
