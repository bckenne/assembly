
	.global atoo
	.type atoo, %function
	
	asc	.req	r6
	oct	.req	r4
	offset	.req	r5
	mask	.req	r7
	count	.req	r9
	
atoo:
	push 	{lr}
	mov	offset, #0
	mov	oct, #0
	mov	r8, r0
loop:
	ldrb	asc, [r8, offset]
	sub	asc, asc, #0x30
	cmp	asc, #0
	blt	atoo_ret
	cmp	asc, #7
	bgt	atoo_ret
	lsl	oct, oct, #3
	add	oct, oct, asc
	add	offset, offset, #1
	b	loop
atoo_ret:
	mov	r0, oct
	pop	{lr}
	bx	lr

	.global otoa
	.type otoa, %function

otoa:
	push	{r4-r7,lr}
	mov	offset, #0
	mov	oct, r0
	mov	mask, #7
	mov	r8, r1
	mov	count, #1
	mov	r10, oct, lsr #1
	and	asc, r10, mask
	add	asc, asc, #0x30
	lsl	oct, oct, #2
	cmp	asc, #0x30
	beq	next
	strb	asc, [r8, offset]
next:
	cmp	asc, #0x30
	addne	offset, offset, #1
	
loop2:
	and	asc, oct, mask
	add	asc, asc, #0x30
	add	count, count, #1
	cmp	count, #11
	bge	after
	lsl	oct, oct, #3
	cmp	asc, #0x30
	beq	loop2
	strb	asc, [r8, offset]
	lsr	oct, oct, #3
	add	offset, offset, #1
	cmp	count, #11
	ble	loop2
	b	skip
after:
	mov	r10, #0
	strb	r10, [r8, offset]
skip:
	mov	r1, r8
	pop	{r4-r7, lr}
	bx		lr

	.unreq	oct
	.unreq	offset
	.unreq	mask
	.unreq	asc
	
.prt:	.ascii "r1 = %d\012\000"
