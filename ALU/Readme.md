# RV64I ALU

- A parameterized 64-bit combinational Arithmetic Logic Unit implementing the arithmetic, logical, shift, and comparison operations required by the RV64I instruction subset.
- Uses a **64-bit Kogge-Stone Adder (KSA)** for addition, reducing the combinational critical path compared with the initial implementation.
- Supports register-register and register-immediate operations through an operand-selection input.
- Generates six branch-condition signals for equality, signed comparisons, and unsigned comparisons.
- Verified using directed RTL test vectors and gate-level simulation (GLS) after synthesis and technology mapping.

<p align="center">
  <img src="images/ALU_Waveform.png" width="1000"/>
  <br>
  <sub>RV64I ALU Waveform</sub>
</p>

### Supported Operations

| Opcode        | Operation | Description                                       |
| ------------- | --------- | ------------------------------------------------- |
| `0000`        | ADD       | Addition (`rs1 + op2`)                            |
| `0001`        | SUB       | Subtraction (`rs1 - op2`)                         |
| `0010`        | SLL       | Logical left shift                                |
| `0011`        | SRL       | Logical right shift                               |
| `0100`        | SRA       | Arithmetic right shift                            |
| `0101`        | AND       | Bitwise AND (`rs1 & op2`)                         |
| `0110`        | OR        | Bitwise OR (`rs1 \| op2`)                         |
| `0111`        | XOR       | Bitwise XOR (`rs1 ^ op2`)                         |
| `1000`        | SLT       | Signed less-than comparison; returns `1` or `0`   |
| `1001`        | SLTU      | Unsigned less-than comparison; returns `1` or `0` |
| `1010`        | Invalid   | Output defaults to zero                           |
| `1011`        | Invalid   | Output defaults to zero                           |
| `1100`        | Invalid   | Output defaults to zero                           |
| `1101`        | Invalid   | Output defaults to zero                           |
| `1110`        | Invalid   | Output defaults to zero                           |
| `1111`        | Invalid   | Output defaults to zero                           |

**Operand selection:** `op2 = alu_src ? imm : rs2`

For register shifts, the shift amount is `rs2[5:0]`. For immediate shifts, it is `imm[5:0]`.

### Branch Condition Outputs

The ALU independently compares `op2` and `rs2` to generate branch-condition signals for the control unit.

| Signal | Branch | Condition             |
| ------ | ------ | --------------------- |
| `beq`  | BEQ    | `op2 == rs2`          |
| `bne`  | BNE    | `op2 != rs2`          |
| `blt`  | BLT    | Signed `op2 < rs2`    |
| `bge`  | BGE    | Signed `op2 >= rs2`   |
| `bltu` | BLTU   | Unsigned `op2 < rs2`  |
| `bgeu` | BGEU   | Unsigned `op2 >= rs2` |

### Verification

- **RTL simulation:** Directed test vectors covering arithmetic, logical, shift, comparison, branch-condition, and invalid-opcode behavior.
- **Gate-level simulation:** Passed using the synthesized and technology-mapped netlist.
- **Arithmetic edge cases:** Tested signed boundaries, all-ones operands, and 64-bit overflow behavior.
- **Shift operations:** Tested boundary shift amounts, including `0`, `1`, `63`, and immediate shift-amount truncation.
- **Invalid opcodes:** Verified that encodings `1010` through `1111` produce zero.

<p align="center">
  <img src="images/ALU_Synthesis.png" width="800"/>
  <br>
  <sub>RV64I ALU Synthesized Netlist</sub>
</p>

Gate-level simulation was performed after synthesis and technology mapping to verify the ALU's behavior in the Sky130HD implementation.
