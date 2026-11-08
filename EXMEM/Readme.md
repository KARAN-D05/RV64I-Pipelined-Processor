# EXMEM – Execute/Memory Pipeline Register

## Overview

The EXMEM module is a 280-bit pipeline register that stores the outputs of the Execute (EX) stage and transfers them to the Memory (MEM) stage.

It captures the ALU result, forwarded store data, TAG outputs, control signals, and register indices on the rising edge of the clock. The module supports asynchronous active-high reset.

## Waveform

<p align="center">
  <img src="images/EXMEM_Waveform.png" width="100%">
</p>

## Features

- 64-bit ALU result storage.
- 64-bit forwarded store-data storage.
- 64-bit TAG return-address (`r_out`) storage.
- 64-bit TAG target (`t_out`) storage.
- 9-bit control-word storage.
- Storage of `rs1`, `rs2`, and `rd` register indices.
- Asynchronous active-high reset.
- Parameterized data width, register-index width, and control-word width.

## Interface

| Signal | Direction | Width | Description |
|---|---|---:|---|
| `alu_in` | Input | 64 | ALU result from EX |
| `data_in2` | Input | 64 | Forwarded second operand, retained as store data |
| `r_in` | Input | 64 | TAG return address |
| `t_in` | Input | 64 | TAG target address |
| `c_word_in` | Input | 9 | Remaining control signals |
| `rs1`, `rs2`, `rd` | Input | 5 each | Source and destination register indices |
| `clk` | Input | 1 | Clock |
| `rst` | Input | 1 | Asynchronous active-high reset |
| `alu_out` | Output | 64 | Registered ALU result |
| `data_out2` | Output | 64 | Registered store data |
| `r_out` | Output | 64 | Registered TAG return address |
| `t_out` | Output | 64 | Registered TAG target address |
| `c_word_out` | Output | 9 | Registered control signals |
| `rs1_out`, `rs2_out`, `rd_out` | Output | 5 each | Registered register indices |

## Pipeline Payload

The EXMEM register stores the following fields:

| Field | Width |
|---|---:|
| ALU result | 64 bits |
| Store data | 64 bits |
| TAG return address | 64 bits |
| TAG target address | 64 bits |
| Control word | 9 bits |
| Register indices (`rs1`, `rs2`, `rd`) | 15 bits |
| **Total** | **280 bits** |

## Control Word

The 9-bit control word carries the signals required by the downstream MEM and WB stages:

| Bits | Signal |
|---|---|
| `[8]` | `uses_rs1` |
| `[7]` | `uses_rs2` |
| `[6]` | `write_rf` |
| `[5:3]` | `op_width` |
| `[2]` | `write_ram` |
| `[1:0]` | `res` |

## Verification

- Directed testbench verification using Icarus Verilog.
- Verified asynchronous reset assertion between clock edges.
- Verified sequential capture of all datapath, control, and register-index fields.
- Verified consecutive input updates and zero control-word propagation.
- RTL simulation passed.
- Gate-Level Simulation (GLS) passed.
