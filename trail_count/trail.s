@ Bradley Kennedy (bckenne)
@ CPSC 2310 Summer 2014 
@ July 28, 2014
@ Program #4
@ This program counts and returns the number of trailing zero's in a 32 bit  register input

        .global trailing_zeros
        .type trailing_zeros, %function
 
        zeros   .req    r4
        bit     .req    r5
        input   .req    r6
/* trailing_zeros
 *
 * prototype
 *   int trailing_zeros( int word );
 *
 * input parameter
 *   r0 - the C "float" number (i.e., the IEEE single precision 
 *        floating point format
 *
 * return value
 *   r0  - the number of trailing zeros in word
 *
 *
 * local register map
        r4(zeros)       - holds the current count of trailing zeros
        r5(bit)         - holds a single bit after extraction from input
        r6(input)       - initially a copy of the input, this holds the 32 bit value being processed
 */       
trailing_zeros:
        push    {r4-r6, lr}             
        mov     zeros, #0               
        mov     input, r0
loop:   
        and     bit, input, #1          @ extract the current lsb of input
        cmp     bit, #1                 
        beq     done                    @ if the extracted bit is a 1 skip to done b/c there are no more trailing zeros
        add     zeros, zeros, #1        @ else { increment zeros
        lsr     input, input, #1        @        shift input right by 1 bit
        cmp     zeros, #23              @                  
        blt     loop                    @ branch back to loop if(zeros<23)
done:
        mov     r0, zeros               @ copy zeros into the return register r0
        pop     {r4-r6, lr}
        bx      lr 
        
        .unreq  zeros
        .unreq  bit
        .unreq  input
