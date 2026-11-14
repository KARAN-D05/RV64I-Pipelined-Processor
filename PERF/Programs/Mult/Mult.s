	.file	"Mult.c"
	.option nopic
	.attribute arch, "rv64i2p1"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.globl	multiplicand
	.section	.sbss,"aw",@nobits
	.align	3
	.type	multiplicand, @object
	.size	multiplicand, 8
multiplicand:
	.zero	8
	.globl	multiplier
	.align	3
	.type	multiplier, @object
	.size	multiplier, 8
multiplier:
	.zero	8
	.globl	result
	.align	3
	.type	result, @object
	.size	result, 8
result:
	.zero	8
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-48
	sd	s0,40(sp)
	addi	s0,sp,48
	lui	a5,%hi(multiplicand)
	ld	a5,%lo(multiplicand)(a5)
	sd	a5,-24(s0)
	lui	a5,%hi(multiplier)
	ld	a5,%lo(multiplier)(a5)
	sd	a5,-32(s0)
	sd	zero,-40(s0)
	j	.L2
.L4:
	ld	a5,-32(s0)
	andi	a5,a5,1
	beq	a5,zero,.L3
	ld	a4,-40(s0)
	ld	a5,-24(s0)
	add	a5,a4,a5
	sd	a5,-40(s0)
.L3:
	ld	a5,-24(s0)
	slli	a5,a5,1
	sd	a5,-24(s0)
	ld	a5,-32(s0)
	srli	a5,a5,1
	sd	a5,-32(s0)
.L2:
	ld	a5,-32(s0)
	bne	a5,zero,.L4
	lui	a5,%hi(result)
	ld	a4,-40(s0)
	sd	a4,%lo(result)(a5)
	li	a5,0
	mv	a0,a5
	ld	s0,40(sp)
	addi	sp,sp,48
	jr	ra
	.size	main, .-main
	.ident	"GCC: (13.2.0-11ubuntu1+12) 13.2.0"
