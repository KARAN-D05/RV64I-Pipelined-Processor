# MEM-to-EX Forwarding (MEF) Unit

The MEM-to-EX Forwarding (MEF) unit resolves Read-After-Write (RAW) data dependencies between instructions separated by one intervening instruction in the five-stage pipeline. It detects source-register matches between the instruction in the EX stage and the destination register of the instruction in the MEM/WB pipeline register.

When a dependency is detected, the MEF unit forwards the final write-back result from MEM/WB directly to the corresponding ALU input, avoiding the need to wait for register-file write-back.

<p align="center">
  <img src="images/MEF_Waveform.png" width="1000"/>
  <br>
  <sub>MEM-EX Forwarding</sub>
</p>

## Features

- Supports independent forwarding paths for both ALU operands.
- Detects RAW dependencies by comparing source and destination register indices.
- Uses `uses_rs1` and `uses_rs2` metadata to qualify source-register comparisons.
- Prevents forwarding from the zero register (`x0`).
- Qualifies forwarding using the MEM/WB register-file write control.
- Supports simultaneous forwarding to both ALU operands.
- Provides original ID/EX operands when no forwarding condition is satisfied.
- Implements combinational forwarding logic without additional pipeline latency.

## Interface

| Signal              | Direction | Width   | Description                                        |
| ------------------- | --------- | ------- | -------------------------------------------------- |
| `id_ex_rs1`         | Input     | 5 bits  | First source register index from ID/EX             |
| `id_ex_rs2`         | Input     | 5 bits  | Second source register index from ID/EX            |
| `id_ex_data1`       | Input     | 64 bits | Original first source operand from ID/EX           |
| `id_ex_data2`       | Input     | 64 bits | Original second source operand from ID/EX          |
| `mem_wb_result`     | Input     | 64 bits | Final write-back result available in MEM/WB        |
| `mem_wb_write_rf`   | Input     | 1 bit   | MEM/WB register-file write control                 |
| `mem_wb_rd`         | Input     | 5 bits  | Destination register index from MEM/WB             |
| `uses_rs1`          | Input     | 1 bit   | Indicates whether the current instruction uses rs1 |
| `uses_rs2`          | Input     | 1 bit   | Indicates whether the current instruction uses rs2 |
| `alu_operand_a`     | Output    | 64 bits | First ALU operand after forwarding selection       |
| `alu_operand_b`     | Output    | 64 bits | Second ALU operand after forwarding selection      |

## Forwarding Logic

The MEF unit independently checks both source operands against the destination register in MEM/WB.

A forwarding condition is asserted when:

- The corresponding source register is used by the current instruction.
- The source register is not `x0`.
- The source register index matches `mem_wb_rd`.
- The MEM/WB instruction enables register-file write-back.

The forwarding conditions are:

```systemverilog
forward1 = (mem_wb_rd != 0) &&
           (id_ex_rs1 == mem_wb_rd) &&
           uses_rs1 &&
           mem_wb_write_rf;

forward2 = (mem_wb_rd != 0) &&
           (id_ex_rs2 == mem_wb_rd) &&
           uses_rs2 &&
           mem_wb_write_rf;
```

The resulting forwarding decisions control two independent operand-selection paths:

```systemverilog
alu_operand_a = forward1 ? mem_wb_result : id_ex_data1;
alu_operand_b = forward2 ? mem_wb_result : id_ex_data2;
```

If a dependency is detected, the corresponding ALU operand receives the MEM/WB result. Otherwise, the original operand from ID/EX is selected.

### Source-Usage Qualification

The `uses_rs1` and `uses_rs2` signals prevent false forwarding conditions caused by instruction fields that do not represent actual source-register dependencies.

For example, an immediate instruction may contain a bit pattern in the `rs2` field position, but that field is part of the immediate rather than a source-register index. The source-usage metadata prevents such a match from triggering forwarding.

## Verification

- RTL simulation: 10 directed test vectors verified.
- Gate-level simulation: 10 directed test vectors verified using the synthesized and technology-mapped netlist.
- Independent forwarding: Verified forwarding to `alu_operand_a` and `alu_operand_b` separately.
- Simultaneous forwarding: Verified both operands receiving the MEM/WB result.
- Dependency detection: Verified matching and non-matching source/destination register indices.
- Source qualification: Verified that unused source registers do not trigger forwarding.
- Zero-register handling: Verified that forwarding from `x0` is prevented.
- Write qualification: Verified that forwarding is disabled when `mem_wb_write_rf` is deasserted.
- Operand selection: Verified original ID/EX operand pass-through when forwarding is not required.
