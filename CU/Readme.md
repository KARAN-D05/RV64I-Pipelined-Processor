# Control Unit (CU)

The Control Unit (CU) is a combinational instruction decoder responsible
for generating the control signals required to execute supported RV64I
instructions.

It operates in the Instruction Decode (ID) stage of the 5-stage
pipeline. Based on the instruction opcode, `funct3`, and `funct7`
fields, it generates the appropriate control signals.

For conditional branches, the CU identifies valid branch instructions
and outputs the corresponding `funct3` field for branch-condition
selection in the EX stage. It also identifies valid unconditional jumps
(JAL and JALR). **Branch and jump resolution is handled separately by
the Branch Control Unit (BCU)**, keeping instruction decoding
independent of control-flow resolution.

The CU supports 49 instructions across arithmetic, logical, memory,
branch, and control-transfer operations.

```{=html}
<p align="center">
```
`<img src="images/CU_Waveform.png" width="1000"/>`{=html} `<br>`{=html}
`<sub>`{=html}Control Unit producing control signals for corresponding
instructions`</sub>`{=html}
```{=html}
</p>
```
## Features

-   Decodes R-type, I-type, S-type, B-type, U-type, and J-type
    instruction formats.
-   Generates ALU operation selection and operand selection controls.
-   Generates register-file and data-memory write controls.
-   Selects the appropriate write-back result source.
-   Identifies valid conditional branch instructions using opcode and
    `funct3`.
-   Outputs the conditional branch instruction's `funct3` for branch
    resolution in the EX stage.
-   Identifies unconditional jumps (JAL and JALR) for resolution by the
    BCU.
-   Generates `uses_rs1` and `uses_rs2` metadata to identify
    source-register usage for forwarding and hazard detection.
-   Generates `is_load` to identify load instructions for load-use
    hazard detection.
-   Uses deterministic default control values for unsupported
    instructions and encodings.

## Supported Instructions

  ---------------------------------------------------------------------------
  Instruction      Supported Instructions                            Count
  Class                                                              
  ---------------- ------------------------------------------------- --------
  OP               ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND  10

  OP-IMM           ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI,   9
                   SRAI                                              

  OP-32            ADDW, SUBW, SLLW, SRLW, SRAW                      5

  OP-IMM-32        ADDIW, SLLIW, SRLIW, SRAIW                        4

  LOAD             LB, LH, LW, LD, LBU, LHU, LWU                     7

  STORE            SB, SH, SW, SD                                    4

  BRANCH           BEQ, BNE, BLT, BGE, BLTU, BGEU                    6

  U-type           LUI, AUIPC                                        2

  JUMP             JAL, JALR                                         2

  **Total**                                                          **49**
  ---------------------------------------------------------------------------

## Interface

### Inputs

  ------------------------------------------------------------------------
  Signal              Width            Description
  ------------------- ---------------- -----------------------------------
  `instr`             32 bits          Instruction supplied by the IF/ID
                                       pipeline register

  ------------------------------------------------------------------------

### Outputs

  ------------------------------------------------------------------------
  Signal              Width            Description
  ------------------- ---------------- -----------------------------------
  `write_rf`          1 bit            Register-file write enable

  `alu_op`            4 bits           ALU operation selection

  `alu_src`           1 bit            Selects ALU operand 2: register or
                                       immediate

  `is_jalr`           1 bit            Identifies JALR and selects its
                                       target-address calculation

  `op_width`          3 bits           Memory operation width and
                                       signedness selection

  `write_ram`         1 bit            Data-memory write enable

  `res`               2 bits           Write-back result source selection

  `branch`            1 bit            Valid branch/jump indicator;
                                       asserted for supported conditional
                                       branches, JAL, and JALR

  `uses_rs1`          1 bit            Indicates whether the instruction
                                       uses `rs1`

  `uses_rs2`          1 bit            Indicates whether the instruction
                                       uses `rs2`

  `is_load`           1 bit            Identifies a load instruction for
                                       hazard detection

  `funct3`            3 bits           Conditional-branch condition
                                       encoding passed to the BCU
  ------------------------------------------------------------------------

## Branch and Jump Decoding

The `branch` output indicates that the instruction is a valid
conditional branch or jump. It is a **valid branch/jump indicator**, not
the final taken decision.

For conditional branches, the CU asserts `branch` only when the opcode
identifies a conditional branch and `funct3` contains a supported branch
encoding.

  funct3   Instruction
  -------- -------------
  000      BEQ
  001      BNE
  100      BLT
  101      BGE
  110      BLTU
  111      BGEU

For valid conditional branches, `funct3` is passed to the output. For
non-branch instructions and unsupported branch encodings, `funct3`
defaults to `3'b000`.

The CU also asserts `branch` for JAL and JALR. The BCU distinguishes the
three control-flow cases using the registered control metadata:

  --------------------------------------------------------------------------------------------------------------------------
  Instruction class                   `branch`   `is_jalr`              `uses_rs1`              `uses_rs2` BCU action
  --------------------------------- ---------- ----------- ----------------------- ----------------------- -----------------
  Conditional branch                         1           0                       1                       1 Select ALU
                                                                                                           comparison using
                                                                                                           `funct3`

  JAL                                        1           0                       0                       0 Assert
                                                                                                           `branch_taken`
                                                                                                           unconditionally

  JALR                                       1           1                       1                       0 Assert
                                                                                                           `branch_taken`
                                                                                                           unconditionally

  Other supported instruction                0           0   Instruction-dependent   Instruction-dependent No redirect
  --------------------------------------------------------------------------------------------------------------------------

The `branch` signal does **not** indicate whether a conditional branch
is taken. The BCU receives the registered `branch`, `funct3`, `is_jalr`,
`uses_rs1`, and `uses_rs2` fields along with the ALU's six comparison
outputs in EX. It selects the appropriate comparison for conditional
branches, while JAL and JALR are taken unconditionally.

The ALU operands are supplied by the EX Forwarding Unit (EFU), so
dependencies are resolved through the existing forwarding paths before
branch evaluation. The BCU generates a single `branch_taken` output for
PC redirection.

The target address is calculated separately by TAG: - Conditional
branches and JAL: `PC + imm` - JALR: `(rs1 + imm) & ~64'd1`

## Control Word Format

The CU generates a **20-bit control word**:

``` text
{uses_rs1, uses_rs2, branch, write_rf, alu_op[3:0], alu_src, is_jalr, op_width[2:0], write_ram, is_load, res[1:0], funct3[2:0]}
```

The control word contains two categories of information:

**Datapath control - 13 bits**

-   `write_rf`
-   `alu_op[3:0]`
-   `alu_src`
-   `is_jalr`
-   `op_width[2:0]`
-   `write_ram`
-   `res[1:0]`

These signals directly control datapath operations, operand selection,
memory access, and write-back selection.

**Pipeline and module metadata - 7 bits**

-   `uses_rs1`
-   `uses_rs2`
-   `branch`
-   `is_load`
-   `funct3[2:0]`

These signals are consumed by other processor units:

-   `uses_rs1` and `uses_rs2` support forwarding and hazard detection.
    They also help the BCU distinguish JAL from conditional branches.
-   `branch` identifies a valid conditional branch or jump (JAL/JALR);
    it does not indicate that a conditional branch is taken.
-   `is_load` supports load-use hazard detection.
-   `funct3` identifies the conditional branch condition for the BCU.

The complete 20-bit control word is carried through the pipeline as
required by the individual stages and modules.

## Verification

The Control Unit was verified using a self-checking SystemVerilog
testbench.

**Verification coverage:**

-   All 49 supported instruction decodings.
-   All six conditional branch instruction encodings.
-   Valid branch/jump identification for conditional branches, JAL, and
    JALR.
-   Corresponding `funct3` output for valid conditional branches.
-   Invalid branch encodings (`funct3` 010 and 011).
-   Representative invalid opcodes and unsupported instruction
    encodings.
-   Invalid `funct3` and `funct7` combinations.
-   Invalid shift-immediate encodings.
-   Individual verification of all output control signals, including
    source-usage metadata, `is_load`, and `funct3`.

  Verification Stage            Result
  ----------------------------- ------------
  RTL Simulation                71/71 PASS
  Gate-Level Simulation (GLS)   71/71 PASS
  Synthesis                     Completed

All 71 directed test cases passed in both RTL simulation and gate-level
simulation.
