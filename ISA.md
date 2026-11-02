# Instruction Set Architecture
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
+---------+---------+---------+--------+---------+----------+
| imm[11:5]|   rs2   |   rs1   | funct3 | imm[4:0]| opcode  |
+---------+---------+---------+--------+---------+----------+
| 7 bits   | 5 bits  | 5 bits  | 3 bits | 5 bits  | 7 bits  |
+---------+---------+---------+--------+---------+----------+
```

### B-Type

```text
+---------+---------+---------+--------+---------+---------+
| imm[12] | imm[10:5]|  rs2   |  rs1   | funct3  | opcode  |
+---------+---------+---------+--------+---------+---------+
```

### U-Type

```text
+---------------------------+---------+---------+
|         imm[31:12]        |   rd    | opcode  |
+---------------------------+---------+---------+
```

### J-Type

```text
+---------+-----------------+---------+---------+-----------+
| imm[20] |    imm[10:1]    | imm[11] | imm[19:12]|   rd    |
+---------+-----------------+---------+---------+-----------+
| 1 bit   |     10 bits     | 1 bit   |  8 bits   | 5 bits  |
+---------+-----------------+---------+---------+-----------+
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

The Control Unit generates a **14-bit control word**.

|  Bit | Control Signal | Description                             |
| ---  | -------------- | --------------------------------------- |
|   13 | branch         | PC redirect control                     |
|   12 | write(RF)      | Register File write enable              |
| 11:8 | alu_op[3:0]    | ALU operation select                    |
|    7 | alu_src        | Selects immediate or rs2 as ALU operand |
|    6 | is_jalr        | Selects JALR target calculation         |
|  5:3 | op_width[2:0]  | Memory access width                     |
|    2 | write(RAM)     | RAM write enable                        |
|  1:0 | res[1:0]       | Write-back result selection             |

Control word layout:

```text
{branch, write(RF), alu_op[3:0], alu_src, is_jalr, op_width[2:0], write(RAM), res[1:0]}
```

## Control Word Table

| Instruction | branch | write(RF) | alu_op[3:0] | alu_src | is_jalr | op_width[2:0] | write(RAM) | res[1:0] |
| ----------- | -----  | --------  | ----------  | ------  | ------  | ------------  | ---------  | -------  |
| ADD         |      0 |         1 |      `0000` |       0 |       0 |         `000` |          0 |     `00` |
| SUB         |      0 |         1 |      `0001` |       0 |       0 |         `000` |          0 |     `00` |
| SLL         |      0 |         1 |      `0010` |       0 |       0 |         `000` |          0 |     `00` |
| SRL         |      0 |         1 |      `0011` |       0 |       0 |         `000` |          0 |     `00` |
| SRA         |      0 |         1 |      `0100` |       0 |       0 |         `000` |          0 |     `00` |
| AND         |      0 |         1 |      `0101` |       0 |       0 |         `000` |          0 |     `00` |
| OR          |      0 |         1 |      `0110` |       0 |       0 |         `000` |          0 |     `00` |
| XOR         |      0 |         1 |      `0111` |       0 |       0 |         `000` |          0 |     `00` |
| SLT         |      0 |         1 |      `1000` |       0 |       0 |         `000` |          0 |     `00` |
| SLTU        |      0 |         1 |      `1001` |       0 |       0 |         `000` |          0 |     `00` |
| ADDI        |      0 |         1 |      `0000` |       1 |       0 |         `000` |          0 |     `00` |
| SLTI        |      0 |         1 |      `1000` |       1 |       0 |         `000` |          0 |     `00` |
| SLTIU       |      0 |         1 |      `1001` |       1 |       0 |         `000` |          0 |     `00` |
| XORI        |      0 |         1 |      `0111` |       1 |       0 |         `000` |          0 |     `00` |
| ORI         |      0 |         1 |      `0110` |       1 |       0 |         `000` |          0 |     `00` |
| ANDI        |      0 |         1 |      `0101` |       1 |       0 |         `000` |          0 |     `00` |
| SLLI        |      0 |         1 |      `0010` |       1 |       0 |         `000` |          0 |     `00` |
| SRLI        |      0 |         1 |      `0011` |       1 |       0 |         `000` |          0 |     `00` |
| SRAI        |      0 |         1 |      `0100` |       1 |       0 |         `000` |          0 |     `00` |
| ADDW        |      0 |         1 |      `1010` |       0 |       0 |         `000` |          0 |     `00` |
| SUBW        |      0 |         1 |      `1011` |       0 |       0 |         `000` |          0 |     `00` |
| SLLW        |      0 |         1 |      `1100` |       0 |       0 |         `000` |          0 |     `00` |
| SRLW        |      0 |         1 |      `1101` |       0 |       0 |         `000` |          0 |     `00` |
| SRAW        |      0 |         1 |      `1110` |       0 |       0 |         `000` |          0 |     `00` |
| ADDIW       |      0 |         1 |      `1010` |       1 |       0 |         `000` |          0 |     `00` |
| SLLIW       |      0 |         1 |      `1100` |       1 |       0 |         `000` |          0 |     `00` |
| SRLIW       |      0 |         1 |      `1101` |       1 |       0 |         `000` |          0 |     `00` |
| SRAIW       |      0 |         1 |      `1110` |       1 |       0 |         `000` |          0 |     `00` |
| LB          |      0 |         1 |      `0000` |       1 |       0 |         `000` |          0 |     `01` |
| LH          |      0 |         1 |      `0000` |       1 |       0 |         `001` |          0 |     `01` |
| LW          |      0 |         1 |      `0000` |       1 |       0 |         `010` |          0 |     `01` |
| LD          |      0 |         1 |      `0000` |       1 |       0 |         `011` |          0 |     `01` |
| LBU         |      0 |         1 |      `0000` |       1 |       0 |         `100` |          0 |     `01` |
| LHU         |      0 |         1 |      `0000` |       1 |       0 |         `101` |          0 |     `01` |
| LWU         |      0 |         1 |      `0000` |       1 |       0 |         `110` |          0 |     `01` |
| SB          |      0 |         0 |      `0000` |       1 |       0 |         `000` |          1 |     `00` |
| SH          |      0 |         0 |      `0000` |       1 |       0 |         `001` |          1 |     `00` |
| SW          |      0 |         0 |      `0000` |       1 |       0 |         `010` |          1 |     `00` |
| SD          |      0 |         0 |      `0000` |       1 |       0 |         `011` |          1 |     `00` |
| BEQ         |      1 |         0 |      `0000` |       0 |       0 |         `000` |          0 |     `00` |
| BNE         |      1 |         0 |      `0000` |       0 |       0 |         `000` |          0 |     `00` |
| BLT         |      1 |         0 |      `0000` |       0 |       0 |         `000` |          0 |     `00` |
| BGE         |      1 |         0 |      `0000` |       0 |       0 |         `000` |          0 |     `00` |
| BLTU        |      1 |         0 |      `0000` |       0 |       0 |         `000` |          0 |     `00` |
| BGEU        |      1 |         0 |      `0000` |       0 |       0 |         `000` |          0 |     `00` |
| JAL         |      1 |         1 |      `0000` |       0 |       0 |         `000` |          0 |     `10` |
| JALR        |      1 |         1 |      `0000` |       0 |       1 |         `000` |          0 |     `10` |
| LUI         |      0 |         1 |      `1111` |       1 |       0 |         `000` |          0 |     `00` |
| AUIPC       |      0 |         1 |      `0000` |       0 |       0 |         `000` |          0 |     `11` |

### Branch Condition Encoding

| Instruction | ALU Condition |
| ----------- | ------------- |
| BEQ         | `beq`         |
| BNE         | `bne`         |
| BLT         | `blt`         |
| BGE         | `bge`         |
| BLTU        | `bltu`        |
| BGEU        | `bgeu`        |

Conditional branches assert `branch` only when the corresponding ALU condition is true. JAL and JALR assert `branch` unconditionally.

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
