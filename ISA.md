# Instruction Set Specification
This document defines the supported instructions, instruction encodings, ALU operation encoding, control word format, and instruction-to-control mapping for the processor.

## Supported Instructions

| Instruction | Addressing Mode   | Operation                                                    |
| ----------- | ----------------- | ------------------------------------------------------------ |
| ADD         | Register          | `rd ← rs1 + rs2`                                             |
| SUB         | Register          | `rd ← rs1 - rs2`                                             |
| SLL         | Register          | `rd ← rs1 << rs2[5:0]`                                       |
| SRL         | Register          | `rd ← rs1 >> rs2[5:0]`                                       |
| SRA         | Register          | `rd ← rs1 >>> rs2[5:0]`                                      |
| AND         | Register          | `rd ← rs1 & rs2`                                             |
| OR          | Register          | `rd ← rs1 \| rs2`                                            |
| XOR         | Register          | `rd ← rs1 ^ rs2`                                             |
| SLT         | Register          | `rd ← signed(rs1) < signed(rs2)`                             |
| SLTU        | Register          | `rd ← unsigned(rs1) < unsigned(rs2)`                         |
| ADDI        | Immediate         | `rd ← rs1 + imm`                                             |
| SLTI        | Immediate         | `rd ← signed(rs1) < signed(imm)`                             |
| SLTIU       | Immediate         | `rd ← unsigned(rs1) < unsigned(imm)`                         |
| XORI        | Immediate         | `rd ← rs1 ^ imm`                                             |
| ORI         | Immediate         | `rd ← rs1 \| imm`                                            |
| ANDI        | Immediate         | `rd ← rs1 & imm`                                             |
| SLLI        | Immediate         | `rd ← rs1 << shamt[5:0]`                                     |
| SRLI        | Immediate         | `rd ← rs1 >> shamt[5:0]`                                     |
| SRAI        | Immediate         | `rd ← rs1 >>> shamt[5:0]`                                    |
| ADDW        | Register          | 32-bit addition; sign-extend result to 64 bits               |
| SUBW        | Register          | 32-bit subtraction; sign-extend result to 64 bits            |
| SLLW        | Register          | 32-bit logical left shift; sign-extend result to 64 bits     |
| SRLW        | Register          | 32-bit logical right shift; sign-extend result to 64 bits    |
| SRAW        | Register          | 32-bit arithmetic right shift; sign-extend result to 64 bits |
| ADDIW       | Immediate         | 32-bit addition; sign-extend result to 64 bits               |
| SLLIW       | Immediate         | 32-bit logical left shift; sign-extend result to 64 bits     |
| SRLIW       | Immediate         | 32-bit logical right shift; sign-extend result to 64 bits    |
| SRAIW       | Immediate         | 32-bit arithmetic right shift; sign-extend result to 64 bits |
| LB          | Base + Offset     | `rd ← sign-extend(MEM[rs1 + imm], 8)`                        |
| LH          | Base + Offset     | `rd ← sign-extend(MEM[rs1 + imm], 16)`                       |
| LW          | Base + Offset     | `rd ← sign-extend(MEM[rs1 + imm], 32)`                       |
| LD          | Base + Offset     | `rd ← MEM[rs1 + imm]`                                        |
| LBU         | Base + Offset     | `rd ← zero-extend(MEM[rs1 + imm], 8)`                        |
| LHU         | Base + Offset     | `rd ← zero-extend(MEM[rs1 + imm], 16)`                       |
| LWU         | Base + Offset     | `rd ← zero-extend(MEM[rs1 + imm], 32)`                       |
| SB          | Base + Offset     | `MEM[rs1 + imm] ← rs2[7:0]`                                  |
| SH          | Base + Offset     | `MEM[rs1 + imm] ← rs2[15:0]`                                 |
| SW          | Base + Offset     | `MEM[rs1 + imm] ← rs2[31:0]`                                 |
| SD          | Base + Offset     | `MEM[rs1 + imm] ← rs2[63:0]`                                 |
| BEQ         | PC-relative       | Branch if `rs1 == rs2`                                       |
| BNE         | PC-relative       | Branch if `rs1 != rs2`                                       |
| BLT         | PC-relative       | Branch if signed `rs1 < rs2`                                 |
| BGE         | PC-relative       | Branch if signed `rs1 >= rs2`                                |
| BLTU        | PC-relative       | Branch if unsigned `rs1 < rs2`                               |
| BGEU        | PC-relative       | Branch if unsigned `rs1 >= rs2`                              |
| JAL         | PC-relative       | `rd ← PC + 4`; `PC ← PC + imm`                               |
| JALR        | Register-relative | `rd ← PC + 4`; `PC ← (rs1 + imm) & ~1`                       |
| LUI         | Upper Immediate   | `rd ← U-immediate`                                           |
| AUIPC       | PC-relative       | `rd ← PC + U-immediate`                                      |

## Instruction Encoding
The processor uses the standard 32-bit RISC-V instruction formats.

### R-Type

```text
+---------+---------+---------+--------+---------+---------+
| funct7  |   rs2   |   rs1   | funct3 |   rd    | opcode  |
+---------+---------+---------+--------+---------+---------+
| 7 bits  | 5 bits  | 5 bits  | 3 bits | 5 bits  | 7 bits  |
+---------+---------+---------+--------+---------+---------+
```

### I-Type

```text
+-------------------+---------+--------+---------+---------+
|      imm[11:0]    |   rs1   | funct3 |   rd    | opcode  |
+-------------------+---------+--------+---------+---------+
|      12 bits      | 5 bits  | 3 bits | 5 bits  | 7 bits  |
+-------------------+---------+--------+---------+---------+
```

### S-Type

```text
+-----------+---------+---------+--------+---------+---------+
| imm[11:5] |   rs2   |   rs1   | funct3 | imm[4:0]| opcode  |
+-----------+---------+---------+--------+---------+---------+
|  7 bits   | 5 bits  | 5 bits  | 3 bits | 5 bits  | 7 bits  |
+-----------+---------+---------+--------+---------+---------+
```

### B-Type

```text
+---------+-----------+---------+---------+--------+---------+
| imm[12] | imm[10:5] |   rs2   |   rs1   | funct3 | opcode  |
+---------+-----------+---------+---------+--------+---------+
| 1 bit   | 6 bits    | 5 bits  | 5 bits  | 3 bits | 7 bits  |
+---------+-----------+---------+---------+--------+---------+
```

### U-Type

```text
+---------------------------+---------+---------+
|         imm[31:12]        |   rd    | opcode  |
+---------------------------+---------+---------+
|          20 bits          | 5 bits  | 7 bits  |
+---------------------------+---------+---------+
```

### J-Type

```text
+---------+-----------------+---------+------------+---------+---------+
| imm[20] |    imm[10:1]    | imm[11] | imm[19:12] |   rd    | opcode  |
+---------+-----------------+---------+------------+---------+---------+
| 1 bit   |     10 bits     | 1 bit   |   8 bits   | 5 bits  | 7 bits  |
+---------+-----------------+---------+------------+---------+---------+
```

## Opcode Encoding

| Instruction Class | Opcode (Binary) | Opcode (Hex) |
| ----------------- | --------------- | ------------ |
| LOAD              | `0000011`       | `0x03`       |
| OP-IMM            | `0010011`       | `0x13`       |
| AUIPC             | `0010111`       | `0x17`       |
| STORE             | `0100011`       | `0x23`       |
| OP                | `0110011`       | `0x33`       |
| LUI               | `0110111`       | `0x37`       |
| BRANCH            | `1100011`       | `0x63`       |
| JALR              | `1100111`       | `0x67`       |
| JAL               | `1101111`       | `0x6F`       |
| OP-IMM-32         | `0011011`       | `0x1B`       |
| OP-32             | `0111011`       | `0x3B`       |

## Function Encoding

### OP

| Instruction | funct3 | funct7    |
| ----------- | ------ | --------- |
| ADD         | `000`  | `0000000` |
| SUB         | `000`  | `0100000` |
| SLL         | `001`  | `0000000` |
| SLT         | `010`  | `0000000` |
| SLTU        | `011`  | `0000000` |
| XOR         | `100`  | `0000000` |
| SRL         | `101`  | `0000000` |
| SRA         | `101`  | `0100000` |
| OR          | `110`  | `0000000` |
| AND         | `111`  | `0000000` |

### OP-IMM

| Instruction | funct3 | Immediate Encoding      |
| ----------- | ------ | ----------------------- |
| ADDI        | `000`  | 12-bit signed immediate |
| SLTI        | `010`  | 12-bit signed immediate |
| SLTIU       | `011`  | 12-bit signed immediate |
| XORI        | `100`  | 12-bit signed immediate |
| ORI         | `110`  | 12-bit signed immediate |
| ANDI        | `111`  | 12-bit signed immediate |
| SLLI        | `001`  | `funct6=000000`         |
| SRLI        | `101`  | `funct6=000000`         |
| SRAI        | `101`  | `funct6=010000`         |

### OP-32

| Instruction | funct3 | funct7    |
| ----------- | ------ | --------- |
| ADDW        | `000`  | `0000000` |
| SUBW        | `000`  | `0100000` |
| SLLW        | `001`  | `0000000` |
| SRLW        | `101`  | `0000000` |
| SRAW        | `101`  | `0100000` |

### OP-IMM-32

| Instruction | funct3 | funct7                  |
| ----------- | ------ | ----------------------- |
| ADDIW       | `000`  | 12-bit signed immediate |
| SLLIW       | `001`  | `0000000`               |
| SRLIW       | `101`  | `0000000`               |
| SRAIW       | `101`  | `0100000`               |

### LOAD

| Instruction | funct3 |
| ----------- | ------ |
| LB          | `000`  |
| LH          | `001`  |
| LW          | `010`  |
| LD          | `011`  |
| LBU         | `100`  |
| LHU         | `101`  |
| LWU         | `110`  |

### STORE

| Instruction | funct3 |
| ----------- | ------ |
| SB          | `000`  |
| SH          | `001`  |
| SW          | `010`  |
| SD          | `011`  |

### BRANCH

| Instruction | funct3 |
| ----------- | ------ |
| BEQ         | `000`  |
| BNE         | `001`  |
| BLT         | `100`  |
| BGE         | `101`  |
| BLTU        | `110`  |
| BGEU        | `111`  |

### Jumps and Upper Immediate

| Instruction | funct3 |
| ----------- | ------ |
| JAL         | —      |
| JALR        | `000`  |
| LUI         | —      |
| AUIPC       | —      |

## ALU Operation Encoding

| alu_op[3:0] | Operation |
| ----------- | --------- |
| `0000`      | ADD       |
| `0001`      | SUB       |
| `0010`      | SLL       |
| `0011`      | SRL       |
| `0100`      | SRA       |
| `0101`      | AND       |
| `0110`      | OR        |
| `0111`      | XOR       |
| `1000`      | SLT       |
| `1001`      | SLTU      |
| `1010`      | ADDW      |
| `1011`      | SUBW      |
| `1100`      | SLLW      |
| `1101`      | SRLW      |
| `1110`      | SRAW      |
| `1111`      | LUI       |

## MEM Operation-Width Encoding

| op_width[2:0] | Access            | Load | Store |
| ------------- | ----------------- | ---- | ----- |
| `000`         | Byte              | LB   | SB    |
| `001`         | Halfword          | LH   | SH    |
| `010`         | Word              | LW   | SW    |
| `011`         | Doubleword        | LD   | SD    |
| `100`         | Byte Unsigned     | LBU  | —     |
| `101`         | Halfword Unsigned | LHU  | —     |
| `110`         | Word Unsigned     | LWU  | —     |
| `111`         | Reserved          | —    | —     |

## Write-Back Result Encoding

| res[1:0] | Result Source            |
| -------- | ------------------------ |
| `00`     | ALU Output               |
| `01`     | MEM Output               |
| `10`     | TAG `r_out` (`PC + 4`)   |
| `11`     | TAG `t_out` (`PC + imm`) |

## Control Word Format

The Control Unit generates a **20-bit control word**. It combines datapath control signals with metadata consumed by forwarding, hazard-detection, and branch-handling logic.

| Bit   | Control Signal | Description |
| ----- | -------------- | ----------- |
| 19    | uses_rs1       | Indicates whether the instruction uses rs1 (forwarding metadata) |
| 18    | uses_rs2       | Indicates whether the instruction uses rs2 (forwarding metadata) |
| 17    | branch         | Identifies a control-flow instruction requiring branch/jump handling |
| 16    | write(RF)      | Register-file write enable |
| 15:12 | alu_op[3:0]    | ALU operation selection |
| 11    | alu_src        | Selects immediate or rs2 as ALU operand |
| 10    | is_jalr        | Selects JALR target calculation |
| 9:7   | op_width[2:0]  | Memory access width and signedness |
| 6     | write(RAM)     | RAM write enable |
| 5     | is_load        | Identifies a load instruction for hazard detection |
| 4:3   | res[1:0]       | Write-back result selection |
| 2:0   | funct3[2:0]    | Branch-condition encoding passed to the BCU |

The control word contains two categories of information:

**Datapath control — 13 bits**

`write_rf`, `alu_op[3:0]`, `alu_src`, `is_jalr`, `op_width[2:0]`, `write_ram`, and `res[1:0]`.

These signals directly control datapath operations, operand selection, memory access, and write-back selection.

**Pipeline and module metadata — 7 bits**

`uses_rs1`, `uses_rs2`, `branch`, `is_load`, and `funct3[2:0]`.

These signals are consumed by other processor units:
- `uses_rs1` and `uses_rs2` support forwarding and hazard detection.
- `branch` identifies branch/jump instructions for control-flow handling.
- `is_load` supports load-use hazard detection.
- `funct3` identifies the conditional branch operation for the BCU.

Control word layout:

```text
{uses_rs1, uses_rs2, branch, write(RF), alu_op[3:0], alu_src, is_jalr, op_width[2:0], write(RAM), is_load, res[1:0], funct3[2:0]}
```

## Control Word Table

| Instruction | uses_rs1 | uses_rs2 | branch | write(RF) | alu_op[3:0] | alu_src | is_jalr | op_width[2:0] | write(RAM) | is_load | res[1:0] | funct3[2:0] |
| ----------- | -------- | -------- | -----  | --------  | ----------  | ------  | ------  | ------------  | ---------  | ------- | -------  | ------------ |
| ADD         |      1 |        1 |      0 |         1 |      `0000` |       0 |       0 |         `000` |          0 | 0 |     `00` | `000` |
| SUB         |      1 |        1 |      0 |         1 |      `0001` |       0 |       0 |         `000` |          0 | 0 |     `00` | `000` |
| SLL         |      1 |        1 |      0 |         1 |      `0010` |       0 |       0 |         `000` |          0 | 0 |     `00` | `000` |
| SRL         |      1 |        1 |      0 |         1 |      `0011` |       0 |       0 |         `000` |          0 | 0 |     `00` | `000` |
| SRA         |      1 |        1 |      0 |         1 |      `0100` |       0 |       0 |         `000` |          0 | 0 |     `00` | `000` |
| AND         |      1 |        1 |      0 |         1 |      `0101` |       0 |       0 |         `000` |          0 | 0 |     `00` | `000` |
| OR          |      1 |        1 |      0 |         1 |      `0110` |       0 |       0 |         `000` |          0 | 0 |     `00` | `000` |
| XOR         |      1 |        1 |      0 |         1 |      `0111` |       0 |       0 |         `000` |          0 | 0 |     `00` | `000` |
| SLT         |      1 |        1 |      0 |         1 |      `1000` |       0 |       0 |         `000` |          0 | 0 |     `00` | `000` |
| SLTU        |      1 |        1 |      0 |         1 |      `1001` |       0 |       0 |         `000` |          0 | 0 |     `00` | `000` |
| ADDI        |      1 |        0 |      0 |         1 |      `0000` |       1 |       0 |         `000` |          0 | 0 |     `00` | `000` |
| SLTI        |      1 |        0 |      0 |         1 |      `1000` |       1 |       0 |         `000` |          0 | 0 |     `00` | `000` |
| SLTIU       |      1 |        0 |      0 |         1 |      `1001` |       1 |       0 |         `000` |          0 | 0 |     `00` | `000` |
| XORI        |      1 |        0 |      0 |         1 |      `0111` |       1 |       0 |         `000` |          0 | 0 |     `00` | `000` |
| ORI         |      1 |        0 |      0 |         1 |      `0110` |       1 |       0 |         `000` |          0 | 0 |     `00` | `000` |
| ANDI        |      1 |        0 |      0 |         1 |      `0101` |       1 |       0 |         `000` |          0 | 0 |     `00` | `000` |
| SLLI        |      1 |        0 |      0 |         1 |      `0010` |       1 |       0 |         `000` |          0 | 0 |     `00` | `000` |
| SRLI        |      1 |        0 |      0 |         1 |      `0011` |       1 |       0 |         `000` |          0 | 0 |     `00` | `000` |
| SRAI        |      1 |        0 |      0 |         1 |      `0100` |       1 |       0 |         `000` |          0 | 0 |     `00` | `000` |
| ADDW        |      1 |        1 |      0 |         1 |      `1010` |       0 |       0 |         `000` |          0 | 0 |     `00` | `000` |
| SUBW        |      1 |        1 |      0 |         1 |      `1011` |       0 |       0 |         `000` |          0 | 0 |     `00` | `000` |
| SLLW        |      1 |        1 |      0 |         1 |      `1100` |       0 |       0 |         `000` |          0 | 0 |     `00` | `000` |
| SRLW        |      1 |        1 |      0 |         1 |      `1101` |       0 |       0 |         `000` |          0 | 0 |     `00` | `000` |
| SRAW        |      1 |        1 |      0 |         1 |      `1110` |       0 |       0 |         `000` |          0 | 0 |     `00` | `000` |
| ADDIW       |      1 |        0 |      0 |         1 |      `1010` |       1 |       0 |         `000` |          0 | 0 |     `00` | `000` |
| SLLIW       |      1 |        0 |      0 |         1 |      `1100` |       1 |       0 |         `000` |          0 | 0 |     `00` | `000` |
| SRLIW       |      1 |        0 |      0 |         1 |      `1101` |       1 |       0 |         `000` |          0 | 0 |     `00` | `000` |
| SRAIW       |      1 |        0 |      0 |         1 |      `1110` |       1 |       0 |         `000` |          0 | 0 |     `00` | `000` |
| LB          |      1 |        0 |      0 |         1 |      `0000` |       1 |       0 |         `000` |          0 | 1 |     `01` | `000` |
| LH          |      1 |        0 |      0 |         1 |      `0000` |       1 |       0 |         `001` |          0 | 1 |     `01` | `000` |
| LW          |      1 |        0 |      0 |         1 |      `0000` |       1 |       0 |         `010` |          0 | 1 |     `01` | `000` |
| LD          |      1 |        0 |      0 |         1 |      `0000` |       1 |       0 |         `011` |          0 | 1 |     `01` | `000` |
| LBU         |      1 |        0 |      0 |         1 |      `0000` |       1 |       0 |         `100` |          0 | 1 |     `01` | `000` |
| LHU         |      1 |        0 |      0 |         1 |      `0000` |       1 |       0 |         `101` |          0 | 1 |     `01` | `000` |
| LWU         |      1 |        0 |      0 |         1 |      `0000` |       1 |       0 |         `110` |          0 | 1 |     `01` | `000` |
| SB          |      1 |        1 |      0 |         0 |      `0000` |       1 |       0 |         `000` |          1 | 0 |     `00` | `000` |
| SH          |      1 |        1 |      0 |         0 |      `0000` |       1 |       0 |         `001` |          1 | 0 |     `00` | `000` |
| SW          |      1 |        1 |      0 |         0 |      `0000` |       1 |       0 |         `010` |          1 | 0 |     `00` | `000` |
| SD          |      1 |        1 |      0 |         0 |      `0000` |       1 |       0 |         `011` |          1 | 0 |     `00` | `000` |
| BEQ         |      1 |        1 |      1 |         0 |      `0000` |       0 |       0 |         `000` |          0 | 0 |     `00` | `000` |
| BNE         |      1 |        1 |      1 |         0 |      `0000` |       0 |       0 |         `000` |          0 | 0 |     `00` | `001` |
| BLT         |      1 |        1 |      1 |         0 |      `0000` |       0 |       0 |         `000` |          0 | 0 |     `00` | `100` |
| BGE         |      1 |        1 |      1 |         0 |      `0000` |       0 |       0 |         `000` |          0 | 0 |     `00` | `101` |
| BLTU        |      1 |        1 |      1 |         0 |      `0000` |       0 |       0 |         `000` |          0 | 0 |     `00` | `110` |
| BGEU        |      1 |        1 |      1 |         0 |      `0000` |       0 |       0 |         `000` |          0 | 0 |     `00` | `111` |
| JAL         |      0 |        0 |      1 |         1 |      `0000` |       0 |       0 |         `000` |          0 | 0 |     `10` | `000` |
| JALR        |      1 |        0 |      1 |         1 |      `0000` |       0 |       1 |         `000` |          0 | 0 |     `10` | `000` |
| LUI         |      0 |        0 |      0 |         1 |      `1111` |       1 |       0 |         `000` |          0 | 0 |     `00` | `000` |
| AUIPC       |      0 |        0 |      0 |         1 |      `0000` |       0 |       0 |         `000` |          0 | 0 |     `11` | `000` |
### Branch Condition Encoding

| Instruction | funct3 |
| ----------- | ------ |
| BEQ         | `000`  |
| BNE         | `001`  |
| BLT         | `100`  |
| BGE         | `101`  |
| BLTU        | `110`  |
| BGEU        | `111`  |

For a valid conditional branch, the CU asserts `branch` based on the opcode and supported `funct3` encoding, and carries `funct3` in the 20-bit control word. It does not evaluate the branch condition. The BCU performs branch resolution in EX using the registered `funct3` and the comparison results from the ALU.

JAL and JALR remain unconditional control-flow instructions and assert `branch` for PC redirection.

### TAG Output Usage

| Instruction        | t_out                  | r_out    |
| ------------------ | ---------------------- | -------- |
| Conditional Branch | `PC + imm`             | —        |
| JAL                | `PC + imm`             | `PC + 4` |
| JALR               | `(rs1 + imm) & ~64'd1` | `PC + 4` |
| AUIPC              | `PC + imm`             | —        |

- `t_out` is used as the PC target for branches and jumps.
- `t_out` is selected as the write-back result for AUIPC.
- `r_out` is selected as the write-back result for JAL and JALR.
- `res[1:0]` selects the write-back source.

### Instruction Count

| Category                      | Number of Instructions |
| ----------------------------- | ---------------------  |
| 64-bit Register-Register      |                     10 |
| 64-bit Immediate              |                      9 |
| 32-bit Word Register-Register |                      5 |
| 32-bit Word Immediate         |                      4 |
| Loads                         |                      7 |
| Stores                        |                      4 |
| Conditional Branches          |                      6 |
| Jumps                         |                      2 |
| Upper Immediate               |                      2 |
| **Total**                     |                 **49** |
