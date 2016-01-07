
	global atoo
	.type atoo, %function
	
	asc		.req	r6
	oct		.req	r4
	offset	.req	r5
	mask		.req	r7
	
atoo:
	push 	{r4-r7,lr}
	mov	offset, #0
	mov	oct, #0
	mov	r8, r0
loop:
	ldr	asc, [r8, offset]
	mov	r0, asc
	bl putchar
	ldr	r0, =.prt
	sub	asc, asc, #0x30
	mov	r1, asc
	bl 	printf
	cmp	asc, #0
	blt	atoo_ret
	cmp	asc, #7
	bgt	atoo_ret
	lsl	oct, oct, #3
	add	oct, oct, asc
	add	offset, offset, #1
	b		loop
atoo_ret:
	pop	{r4-r7,lr}
	bx		lr

	.global otoa
	.type otoa, %function

otao:
	push	{r4-r7,lr}
	mov	offset, #10
	mov	oct, r0
	mov	mask, #7
loop2:
	and	asc, oct, mask
	add	asc, asc, #0x30
	str	asc, [r1, offset]
	lsr	oct, oct, #3
	sub	offset, offset, #1
	cmp	offset, #0
	blt	loop2
	
	pop	{r4-r7, lr}
	bx		lr

	.unreq	oct
	.unreq	offset
	.unreq	mask
	.unreq	asc
	
.prt	.ascii "asc = %d\012\000"
