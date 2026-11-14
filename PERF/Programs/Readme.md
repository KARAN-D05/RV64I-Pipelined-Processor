# Performance Benchmark Programs

This directory contains C programs compiled and executed on the custom RV64I pipelined processor. These programs serve as software workloads for evaluating processor functionality and, eventually, architectural performance metrics such as cycle count, CPI and IPC.

## Software-to-Hardware Flow

Programs are written in C and compiled using the RISC-V GNU Toolchain targeting the RV64I base integer ISA (`-march=rv64i`, `-mabi=lp64`).

The execution flow is:

1. **C Source (`.c`):** Defines the benchmark workload.
2. **Assembly (`.s`):** GCC translates the C program into RV64I assembly.
3. **Object Files (`.o`):** Assembly and startup code are assembled into relocatable object files.
4. **Linking (`.elf`):** The linker script places code and data into their designated memory regions, producing an ELF executable.
5. **Memory Image (`.hex`):** The executable's instruction section is extracted and converted into a hexadecimal memory image for instruction ROM initialization.

## Startup and Memory Configuration

Each program uses a startup assembly file (`Start.s`) that provides the initial execution environment before calling `main()`.

The startup code is responsible for:
- Initializing the stack pointer.
- Initializing benchmark input data in RAM when required.
- Calling the C `main()` function.
- Retrieving the result into an architectural register when required.

The linker script (`.ld`) defines the memory layout used during linking.

The processor uses a **Harvard architecture**, with independent instruction and data memory spaces:

| Memory | Capacity | Address Range |
|---|---:|---|
| Instruction ROM | 4 KB | `0x00000000 – 0x00000FFF` |
| Data RAM | 1 KB | Physical offsets `0x000 – 0x3FF` |

For linking, RAM is assigned the logical address range `0x10000000 – 0x100003FF`, keeping it separate from the ROM address range. The processor's data-memory interface uses the lower 10 address bits to access the physical RAM.

The stack grows downward from `0x10000400`, which is the address immediately beyond the RAM region.

## Execution

The generated `Program.hex` image is loaded into the instruction ROM using `$readmemh`. The startup code initializes the required data in RAM, so benchmark inputs do not need to be preloaded separately.

Programs are executed through processor simulation. Results can be inspected in architectural registers and data RAM.

Each benchmark has its own directory containing its source code, startup file, linker script and relevant generated artifacts.
