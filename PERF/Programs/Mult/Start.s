.section .text.init
.globl _start

_start:
    # Initialize stack pointer
    li sp, 0x10000400

    # Data RAM base
    lui t0, 0x10000

    # Initialize multiplicand = 123456789
    li t1, 123456789
    sd t1, 0(t0)

    # Initialize multiplier = 987654321
    li t1, 987654321
    sd t1, 8(t0)

    # Execute C main()
    call main

    # Reload RAM base (t0 is caller-saved)
    lui t0, 0x10000

    # Retrieve result into a0 (x10)
    ld a0, 16(t0)

    # Jump to termination sentinel
    la t1, __program_end
    jalr zero, 0(t1)


.section .program_end, "ax"
.globl __program_end

__program_end:
    .word 0
