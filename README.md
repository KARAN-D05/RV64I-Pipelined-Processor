# RV64I Pipelined Processor

## 🛠️ Tools & Technologies
![Icarus Verilog](https://img.shields.io/badge/Icarus_Verilog-Simulation-1E88E5?style=flat-square)
![Verilator](https://img.shields.io/badge/Verilator-Linting-00897B?style=flat-square)
![Cocotb](https://img.shields.io/badge/Cocotb-Verification-D81B60?style=flat-square)
![GTKWave](https://img.shields.io/badge/GTKWave-Waveforms-F57C00?style=flat-square)
![Yosys](https://img.shields.io/badge/Yosys-Synthesis-43A047?style=flat-square)
![OpenSTA](https://img.shields.io/badge/OpenSTA-Static_Timing_Analysis-8E24AA?style=flat-square)

## 📚 Documentation
- [Instruction Set Architecture](ISA.md)
- [Computer Organization](Organization.md)

## 🔬 Physical Characterization

The following table summarizes post-synthesis implementation results obtained using the Sky130 HD standard-cell library.
Timing results correspond to static timing analysis using a 10 ns clock period.

> Technology: Sky130HD

| Module              | Estimated Area | Critical Path | Estimated Fmax | Estimated Total Power |
| ------------------- | -------------  | ------------  | -------------  | --------------------  |
| [Register File](RF) | 89365.7088 µm² |       0.78 ns |      ~1.28 GHz |               12.1 mW |
| [Sign Extender](SE) | 670.6432 µm²   |       3.05 ns |       ~328 MHz |               77 µW |
| [Program Counter](PC) | 3727.3248 µm²  | 5.75 ns       | ~174 MHz       | 380 µW                |
| [ROM (1024x32)](ROM) | 24,908.8896 µm² | 10.66 ns | ~93.81 MHz | 11.6 mW |
| [Arithmetic and Logic Unit](ALU) | 15377.2480 µm² | 10.36 ns | ~96.5 MHz | 9.04 mW |
| [Target Address Generator](TAG) |  7124.3328 µm² |       4.18 ns |       ~239 MHz |               4.26 mW |

## ⚙️ Implemented Modules

| Module               | Description                                                       | Status |
| -------------------- | ------------------------------------------------------------------| ------ |
| Register File        | Stores operands and intermediate results during program execution | ✅     |
| Sign Extender | Extracts, reconstructs, and extends RV64I instruction immediates to 64 bits | ✅      |
| Program Counter | Maintains the current address and selects sequential or branch addresses | ✅      |
| ROM | Stores and fetches 32-bit instructions using the PC's byte address | ✅ |
| ALU | Performs arithmetic, logical, shift operations and generates comparision signals | ✅ |
| TAG | Calculates branch and jump targets and generates return addresses | ✅      |

## 📜License
- Source code and HDL files are licensed under the MIT License.
- Documentation, diagrams, images, and PDFs are licensed under Creative Commons Attribution 4.0 (CC BY 4.0).

Design and optimization of high-throughput arithmetic datapaths by taking proven arithmetic units and investigating how architectural techniques such as pipelining, parallelism and vectorization can improve their performance beyond their conventional implementations.
