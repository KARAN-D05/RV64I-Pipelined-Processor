OUTPUT_ARCH("riscv")
ENTRY(_start)

MEMORY
{
    ROM (rx)  : ORIGIN = 0x00000000, LENGTH = 4K
    RAM (rwx) : ORIGIN = 0x10000000, LENGTH = 1K
}

SECTIONS
{
    .text :
    {
        KEEP(*(.text.init))
        *(.text)
        *(.text.*)
        *(.rodata)
        *(.rodata.*)
        KEEP(*(.program_end))
    } > ROM

    .sdata :
    {
        *(.sdata)
        *(.sdata.*)
        *(.data)
        *(.data.*)
    } > RAM

    .sbss (NOLOAD) :
    {
        *(.sbss)
        *(.sbss.*)
        *(.bss)
        *(.bss.*)
        *(COMMON)
    } > RAM

    __stack_top = ORIGIN(RAM) + LENGTH(RAM);
}
