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

## ⚙️ Implemented Modules

| Module               | Description                                                                                 | Status |
| -------------------- | --------------------------------------------------------------------------------------------| ------ |
| Register File        | 32 64-Bit Registers for operands and intermediate results storage during program execution  | ✅     |


## 📜License
- Source code and HDL files are licensed under the MIT License.
- Documentation, diagrams, images, and PDFs are licensed under Creative Commons Attribution 4.0 (CC BY 4.0).
