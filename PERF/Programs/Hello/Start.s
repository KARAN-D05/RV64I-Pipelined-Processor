.section .text.init
.globl _start

_start:
    li sp, 0x10000400
    call main

    la t1, __program_end
    jalr zero, 0(t1)

.section .program_end, "ax"
.globl __program_end

__program_end:
    .word 0
