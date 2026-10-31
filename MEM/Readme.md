# Memory (MEM) Stage

A parameterized 1 KiB byte-addressable memory supporting 8-bit, 16-bit, 32-bit, and 64-bit accesses. It provides combinational reads and synchronous writes, with support for both aligned and misaligned accesses. The memory follows little-endian byte ordering and supports signed and unsigned load operations.

<p align="center">
  <img src="images/MEM_Waveform.png" width="1000"/>
  <br>
  <sub>MEM Waveform</sub>
</p>

## Features

- Synchronous writes on the positive clock edge
- Supports byte, halfword, word, and doubleword accesses
- Supports aligned and misaligned memory accesses
- Little-endian byte ordering
- Signed loads: LB, LH, LW
- Unsigned loads: LBU, LHU, LWU
- Store operations: SB, SH, SW, SD
- Partial writes preserve unaffected memory bytes
- Sign extension and zero extension for load operations

## Operation Encoding

The 3-bit `op_width` signal selects the access width and load signedness.

| `op_width` | Access Type                | Load Operation | Store Operation |
|  --------  | -------------------------- | -------------- | --------------- |
|    `000`   | Byte (8-bit)               | LB             | SB              |
|    `001`   | Halfword (16-bit)          | LH             | SH              |
|    `010`   | Word (32-bit)              | LW             | SW              |
|    `011`   | Doubleword (64-bit)        | LD             | SD              |
|    `100`   | Byte Unsigned (8-bit)      | LBU            | —               |
|    `101`   | Halfword Unsigned (16-bit) | LHU            | —               |
|    `110`   | Word Unsigned (32-bit)     | LWU            | —               |
|    `111`   | Reserved                   | —              | —               |

- Signed loads perform sign extension to the 64-bit output width.
- Unsigned loads perform zero extension to the 64-bit output width.
- Store operations use the corresponding byte, halfword, word, or doubleword encoding.
