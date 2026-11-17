	.file	"Hello.c"
	.option nopic
	.attribute arch, "rv64i2p1"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.globl	message
	.bss
	.align	3
	.type	message, @object
	.size	message, 13
message:
	.zero	13
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-16
	sd	s0,8(sp)
	addi	s0,sp,16
	lui	a5,%hi(message)
	addi	a5,a5,%lo(message)
	li	a4,72
	sb	a4,0(a5)
	lui	a5,%hi(message)
	addi	a5,a5,%lo(message)
	li	a4,101
	sb	a4,1(a5)
	lui	a5,%hi(message)
	addi	a5,a5,%lo(message)
	li	a4,108
	sb	a4,2(a5)
	lui	a5,%hi(message)
	addi	a5,a5,%lo(message)
	li	a4,108
	sb	a4,3(a5)
	lui	a5,%hi(message)
	addi	a5,a5,%lo(message)
	li	a4,111
	sb	a4,4(a5)
	lui	a5,%hi(message)
	addi	a5,a5,%lo(message)
	li	a4,32
	sb	a4,5(a5)
	lui	a5,%hi(message)
	addi	a5,a5,%lo(message)
	li	a4,87
	sb	a4,6(a5)
	lui	a5,%hi(message)
	addi	a5,a5,%lo(message)
	li	a4,111
	sb	a4,7(a5)
	lui	a5,%hi(message)
	addi	a5,a5,%lo(message)
	li	a4,114
	sb	a4,8(a5)
	lui	a5,%hi(message)
	addi	a5,a5,%lo(message)
	li	a4,108
	sb	a4,9(a5)
	lui	a5,%hi(message)
	addi	a5,a5,%lo(message)
	li	a4,100
	sb	a4,10(a5)
	lui	a5,%hi(message)
	addi	a5,a5,%lo(message)
	li	a4,33
	sb	a4,11(a5)
	lui	a5,%hi(message)
	addi	a5,a5,%lo(message)
	sb	zero,12(a5)
	li	a5,0
	mv	a0,a5
	ld	s0,8(sp)
	addi	sp,sp,16
	jr	ra
	.size	main, .-main
	.ident	"GCC: (13.2.0-11ubuntu1+12) 13.2.0"
