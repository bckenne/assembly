/*
Brad Kennedy (bckenne)
CPSC 2310
July 17, 2014
Program 2		
*/	
	.global prt_binary
	.type prt_binary, %function
	in .req r6
	shift .req r3
	bit .req r7
	mask .req r4
	count .req r5
/*
prt_binary routine
input parameter: r0 -32 bit number
return value: none
effect/output: print binary representation of r0
typical calling sequence: put number in r0, call prt_binary
local register usage:
        r3 stores the size of the shift
        r4 stores the mask
        r5 stores a counter for spacing
        r6 stores copy of input value
        r7 stores the bit to be printed
*/
prt_binary:
	push {lr}
	mov in, r0
	mov count, #0
	mov mask, #1
	mov shift, #32
	bl prtspace                     @ branch and link to prtspace to print leading space
	
    loop:                               @ while(shift >=0)
        sub shift, shift, #1            @ decrement shift
        cmp shift, #0                   
        blt done                        @ branch out if(shift<0)
        
        lsr bit, in, shift              @ shift to put the bit to be printed in lsb position
        
        and bit, mask, bit              @ and with the mask to get lsb
        cmp bit, #1                     
        blne prt0                       @ if(bit!=1) branch and link to prt0
        cmp bit, #1                     
        bleq prt1                       @ if(bit==1) branch and link to prt1
        add count, count, #1            @ increment count
        cmp count, #4                   
        bleq prtspace                   @ branch and link to prtspace if(count==4)
        
        b loop                          
done:
	
	pop {lr}
	bx lr
	
@ prt0 subroutine this prints a '0' to the terminal
prt0:
        push {lr}
        mov r0, #0x30
        bl putchar
        pop {lr}
        bx lr

@ prt1 subroutine this prints a '1' to the terminal   
prt1:
        push {lr}
        mov r0, #0x31
        bl putchar
        pop {lr}
        bx lr

@ prtspace subroutine this prints a ' ' to the terminal    
prtspace:
        push {lr}
        mov r0, #0x20
        bl putchar
        mov count, #0                   @ reset count to zero so that next space can be printed after 4 more bits
        pop {lr}
        bx lr
