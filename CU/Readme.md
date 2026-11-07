  # Control Unit (CU)

The Control Unit (CU) is a combinational instruction decoder responsible for generating the control signals required to execute supported RV64I instructions.

It operates in the Instruction Decode (ID) stage of the 5-stage pipeline. Based on the instruction opcode, `funct3`, and `funct7` fields, it generates the appropriate control signals.

For conditional branches, the CU identifies valid branch instructions and asserts `branch`. It also outputs the corresponding `funct3` field for branch-condition selection in the EX stage. **Branch resolution is handled separately by the Branch Control Unit (BCU)**, keeping instruction decoding independent of branch execution.

The CU supports 49 instructions across arithmetic, logical, memory, branch, and control-transfer operations.

<p align="center">
  <img src="images/CU_Waveform.png" width="1000"/>
  <br>
  <sub>Control Unit producing control signals for corresponding instructions</sub>
</p>

## Features

- Decodes R-type, I-type, S-type, B-type, U-type, and J-type instruction formats.
- Generates ALU operation selection and operand selection controls.
- Generates register-file and data-memory write controls.
- Selects the appropriate write-back result source.
- Identifies valid conditional branch instructions using opcode and `funct3`.
- Outputs the branch instruction's `funct3` for branch resolution in the EX stage.
- Handles unconditional jumps (JAL and JALR).
- Generates `uses_rs1` and `uses_rs2` metadata to identify source-register usage for forwarding and hazard detection.
- Generates `is_load` to identify load instructions for load-use hazard detection.
- Uses deterministic default control values for unsupported instructions and encodings.

## Supported Instructions

| Instruction Class | Supported Instructions                               | Count |
| ----------------- | ---------------------------------------------------- | ----- |
| OP                | ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND     | 10 |
| OP-IMM            | ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI | 9 |
| OP-32             | ADDW, SUBW, SLLW, SRLW, SRAW                         | 5 |
| OP-IMM-32         | ADDIW, SLLIW, SRLIW, SRAIW                           | 4 |
| LOAD              | LB, LH, LW, LD, LBU, LHU, LWU                        | 7 |
| STORE             | SB, SH, SW, SD                                       | 4 |
| BRANCH            | BEQ, BNE, BLT, BGE, BLTU, BGEU                       | 6 |
| U-type            | LUI, AUIPC                                           | 2 |
| JUMP              | JAL, JALR                                            | 2 |
| **Total**         |                                                      | **49** |

## Interface

### Inputs

| Signal | Width | Description |
| ------ | ----- | ----------- |
| `instr` | 32 bits | Instruction supplied by the IF/ID pipeline register |

### Outputs

| Signal | Width | Description |
| ------ | ----- | ----------- |
| `write_rf` | 1 bit | Register-file write enable |
| `alu_op` | 4 bits | ALU operation selection |
| `alu_src` | 1 bit | Selects ALU operand 2: register or immediate |
| `is_jalr` | 1 bit | Selects JALR target-address calculation |
| `op_width` | 3 bits | Memory operation width and signedness selection |
| `write_ram` | 1 bit | Data-memory write enable |
| `res` | 2 bits | Write-back result source selection |
| `branch` | 1 bit | Identifies a valid conditional branch instruction |
| `uses_rs1` | 1 bit | Indicates whether the instruction uses `rs1` |
| `uses_rs2` | 1 bit | Indicates whether the instruction uses `rs2` |
| `is_load` | 1 bit | Identifies a load instruction for hazard detection |
| `funct3` | 3 bits | Branch-condition encoding passed to the EX stage |

## Branch Decoding

The CU asserts `branch` only when the opcode identifies a conditional branch and `funct3` contains a supported branch encoding.

| funct3 | Instruction |
| ------ | ----------- |
| 000 | BEQ |
| 001 | BNE |
| 100 | BLT |
| 101 | BGE |
| 110 | BLTU |
| 111 | BGEU |

For valid branch instructions, `funct3` is passed to the output. For non-branch instructions and unsupported branch encodings, `funct3` defaults to `3'b000`.

The `branch` signal indicates that the instruction is a valid conditional branch; it does **not** indicate whether the branch is taken. The BCU uses the registered branch information and comparison results in EX to determine `branch_taken`.

## Control Word Format

The CU generates a **20-bit control word**:

```text
{uses_rs1, uses_rs2, branch, write_rf, alu_op[3:0], alu_src, is_jalr, op_width[2:0], write_ram, is_load, res[1:0], funct3[2:0]}
```

The control word contains two categories of information:

**Datapath control — 13 bits**

- `write_rf`
- `alu_op[3:0]`
- `alu_src`
- `is_jalr`
- `op_width[2:0]`
- `write_ram`
- `res[1:0]`

These signals directly control datapath operations, operand selection, memory access, and write-back selection.

**Pipeline and module metadata — 7 bits**

- `uses_rs1`
- `uses_rs2`
- `branch`
- `is_load`
- `funct3[2:0]`

These signals are consumed by other processor units:

- `uses_rs1` and `uses_rs2` support forwarding and hazard detection.
- `branch` identifies branch instructions for branch resolution.
- `is_load` supports load-use hazard detection.
- `funct3` identifies the branch condition for the BCU.

The complete 20-bit control word is carried through the pipeline as required by the individual stages and modules.

## Verification

The Control Unit was verified using a self-checking SystemVerilog testbench.

**Verification coverage:**

- All 49 supported instruction decodings.
- All six conditional branch instruction encodings.
- Valid branch identification and corresponding `funct3` output.
- Invalid branch encodings (`funct3` 010 and 011).
- Representative invalid opcodes and unsupported instruction encodings.
- Invalid `funct3` and `funct7` combinations.
- Invalid shift-immediate encodings.
- Individual verification of all output control signals, including source-usage metadata, `is_load`, and `funct3`.

| Verification Stage | Result |
| ------------------- | ------ |
| RTL Simulation | 71/71 PASS |
| Gate-Level Simulation (GLS) | 71/71 PASS |
| Synthesis | Completed |

All 71 directed test cases passed in both RTL simulation and gate-level simulation.
