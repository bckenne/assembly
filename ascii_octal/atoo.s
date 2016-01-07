/*
Bradley Kennedy (bckenne)
CPSC 2310 summer 2014
July 24, 2014
Program 3
This file contains two functions: 
one that converts ascii octal to octal 
one that converts octal to ascii octal
*/

	.global atoo
	.type atoo, %function
	
	asc	.req	r6
	oct	.req	r4
	offset	.req	r5
	mask	.req	r7
	count	.req	r9
	
/* atoo - ascii-to-octal
 *
 * prototype
 *   unsigned atoo( char * );
 *
 * input parameter
 *   r0 - pointer to string containing octal digits
 *
 * return value
 *   r0  - binary value when input string is interpreted
 *         as string of octal digits
 *
 * notes
 *   goal is an atoi()-like interface
 *   stops on first ascii character that cannot be converted (that is,
 *     the first character that is not between '0' and '7')
 *   overflow is not checked -- only the last eleven digits in the
 *     input string are significant in cases with more than eleven
 *   for eleven or more digits, the leftmost octal digit will be
 *     limited in range from 0-3 since there are 32 rather than 33
 *     bits in a word
 *
 * local register map
        r4(oct)         - holds actual octal value as it is created
        r6(asc)         - holds the ascii character to be converted
        r5(offset)      - holds the offset of where the ascii characters are held
 */	
atoo:
	push 	{r4-r6, lr}
	mov	offset, #0      
	mov	oct, #0
loop:
	ldrb	asc, [r0, offset]       @ load the ascii character to be converted
	sub	asc, asc, #0x30         @ convert to actual value by subtracting '0'
	cmp	asc, #0                 
	blt	atoo_ret		@ branch to return if(asc<0||asc>7)
	cmp	asc, #7
	bgt	atoo_ret
	lsl	oct, oct, #3		@ shift octal 3 bits left
	add	oct, oct, asc		@ add the new 3 bit value that was converted
	add	offset, offset, #1	@ increment offset to access next char
	b	loop			
atoo_ret:
	mov	r0, oct			@ copy the converted octal into r0 to return
	pop	{r4-r6, lr}
	bx	lr

	.global otoa
	.type otoa, %function

/* otoa - octal-to-ascii
 *
 * prototype
 *   void otoa( unsigned, char * );
 *
 * inrut parameters
 *   r0 - 32-bit binary value
 *   r1 - pointer to string in which the subroutine
 *        deposits the converted characters; the memory allocated for
 *        the string must have space for at least twelve characters
 *        (eleven octal digits at max and null byte)
 *
 * return value
 *   none
 *
 * effect/output
 *   changes the contents of memory starting at address s
 *
 * notes
 *   otoa ignores any leading zeros, but it will convert an input
 *     value of zero to the output ascii string "0"
 *   goal is an itoa()-like interface
 *
 * local register map
	r2		- temporary variable used just to store a #0 ('\0') and set after last char in string
	r3		- sentry variable set from 0 to 1 when it has found the first non-zero character
	r4 (oct)	- holds the value of the octal being converted
     	r5 (offset)	- holds the offset used to access memory locations to store chars
	r6 (asc)	- holds the value being converted to ascii
	r7 (mask)	- set to #7 (binary 111) to make a mask for extracting a 3 bit field
	r9 (count)	- holds the number of shifts to use for field extraction
	r10		- temporary variable used to store the shifted version of oct
 */
otoa:
	push	{r4-r10,lr}
	mov	offset, #0		@ start with offset at 0
	mov	oct, r0			@ copy the input octal to oct register
	mov	mask, #7		@ set the mask to 7 (binary 111)
	mov	count, #30		@ set the shift counter 30 so that we can extract the 2 msb of oct first
	mov	r3, #0			@ set sentry variable to 0
loop3:
	lsr	r10, oct, count		@ shift oct right by count and store in r10
	and	asc, r10, mask		@ extract 3 bits into asc to get a number 0-7
	add	asc, asc, #0x30		@ convert to ascii code by adding '0'
	cmp	asc, #0x30		@ test if asc is a '0'
	bne	next			@ if it is not branch to next
	cmp	r3, #1			@ if it is a zero we test for r3 (is this not a leading zero)
	bne	skip			@ if it is a leading zero branch to skip
next:
	mov	r3, #1			@ we get here after hitting the first non-zero or if we get to the last char, and set r3 to 1
	strb	asc, [r1, offset]	@ store this char to the passed address+offset
	add	offset, offset, #1	@ increase offset for next char
skip:
	sub	count, count, #3	@ subtract 3 from count so that next shift extracts the next 3 bits left->right
	cmp	count, #0		@ check to see if count is equal to zero (are we about to be on the last char?)
	moveq	r3, #1			@ if we are about to be on the last character set r1 to 1 (store last char even if '0')
	bge	loop3			
		
	mov	r2, #0			@ set temp variable r2 to #0 or '\0' null character
	strb	r2, [r1, offset]	@ store null character at end of string
	pop	{r4-r10, lr}		
	bx		lr

	.unreq	oct
	.unreq	offset
	.unreq	mask
	.unreq	asc
	.unreq 	count
	
.prt:	.ascii "r1 = %d\012\000"
