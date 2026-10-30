# Execution (EX) Stage
The Execution (EX) stage integrates the Arithmetic Logic Unit (ALU) and Target Address Generator (TAG) to perform arithmetic, logical, shift, and comparison operations while generating branch and jump target addresses.

## Features
- Integrates the ALU and TAG as independent combinational modules operating in parallel.
- Supports 64-bit arithmetic, logical, shift, and comparison operations.
- Supports RV64I word operations, including ADDW, SUBW, SLLW, SRLW, and SRAW, with sign-extension of 32-bit results to 64 bits.
- Supports register-register and register-immediate operations through operand selection.
- Generates six branch-condition signals for equality, signed comparisons, and unsigned comparisons.
- Generates branch target addresses using `PC + imm`.
- Generates JALR target addresses using `(rs1 + imm) & ~1`.
- Generates link addresses using `PC + 4`.

## Interface
| Signal    | Direction | Width   | Description                              |
| --------- | --------- | ------- | ---------------------------------------- |
| `pc`      | Input     | 64 bits | Current instruction's program counter    |
| `rs1`     | Input     | 64 bits | First source operand                     |
| `rs2`     | Input     | 64 bits | Second source operand                    |
| `imm`     | Input     | 64 bits | Sign-extended immediate                  |
| `is_jalr` | Input     | 1 bit   | Selects JALR target generation           |
| `alu_op`  | Input     | 4 bits  | Selects the ALU operation                |
| `alu_src` | Input     | 1 bit   | Selects the second ALU operand           |
| `beq`     | Output    | 1 bit   | Equal condition                          |
| `bne`     | Output    | 1 bit   | Not-equal condition                      |
| `blt`     | Output    | 1 bit   | Signed less-than condition               |
| `bge`     | Output    | 1 bit   | Signed greater-than-or-equal condition   |
| `bltu`    | Output    | 1 bit   | Unsigned less-than condition             |
| `bgeu`    | Output    | 1 bit   | Unsigned greater-than-or-equal condition |
| `out`     | Output    | 64 bits | ALU result                               |
| `t_out`   | Output    | 64 bits | Branch or jump target address            |
| `r_out`   | Output    | 64 bits | Link address (`PC + 4`)                  |

## Operand Selection
The ALU selects its second operand using the `alu_src` control input:

`op2 = alu_src ? imm : rs2`

This supports both register-register and register-immediate instructions.
For branch instructions, `alu_src` is deasserted, allowing the ALU to compare `rs1` and `rs2`.

## Target Address Generation
The TAG operates in parallel with the ALU and generates the target and link addresses.

**Branch and JAL target:**
`t_out = pc + imm`

**JALR target:**

`t_out = (rs1 + imm) & ~1`
**Link address:**
`r_out = pc + 4`

## Verification

- **RTL simulation:** Directed test vectors covering ALU operations, word operations, immediate operand selection, branch conditions, and target address generation.
- **Gate-level simulation:** Passed using the synthesized and technology-mapped netlist.
- **Arithmetic operations:** Verified 64-bit arithmetic, logical operations, shifts, and signed and unsigned comparisons.
- **Word operations:** Verified 32-bit arithmetic and shifts with sign-extension to 64 bits.
- **Branch conditions:** Verified all six branch-condition outputs.
- **Target generation:** Verified branch targets, JALR targets, bit-zero clearing, and link-address generation.
- **Integrated verification:** Confirmed that the ALU and TAG produce the expected outputs when instantiated together in the EX stage.
