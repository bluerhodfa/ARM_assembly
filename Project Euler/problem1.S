//
// ARM assembler program 
//  
// Project Euler: Problem 1
// Find the sum of all the multiples of 3 or 5 below 1000.
// Pseudo code:
//
//      target=999
//      Function SumDivisibleBy(n)
//              p=target div n
//              return n*(p*(p+1)) div 2
//      EndFunction
//      Output SumDivisibleBy(3)+SumDivisibleBy(5)-SumDivisibleBy(15)
//
// Tested on: 
//              Macbook Pro M2 MacOS 12.6.3
//
//  Compile and run
//      gcc -o SumDivisibleBy SumDivisibleBy.S
//      ./SumDivisibleBy
//
	.p2align 2
	.text
// application start point
	.global _main

_main:                  // void main()
	.cfi_startproc
    // preserve the stack
	stp 	x20,x30, [sp, -16]!
	mov 	x29, sp
    // set up division registers

	mov 	x9,  #1001		// Loop max
	mov 	x10, #3			// sumby 3
	mov 	x11, #0			// udiv answer
  	mov 	x12, #0			// msub answer
  	mov 	x13, #0			// sum of 3 and 5 divisors
  	mov 	x14, #0			// sum of 15 divisor
	b		_loop

_5:

	mov 	x9,  #999
	mov 	x10, #5
	b		_loop	

_15:
	mov 	x9,  #999
	mov 	x10, #15
	b		_loop	

_loop:
	// Decrement loop counter
	sub		x9, x9,  #1	
	// end when we get to 0 in x0 loop counter
	cbz     x9, _print

	// input: x9=dividend, x10=divisor
	udiv	x11, x9, x10
	msub 	x12, x11, x10, x9
	// result: x11=quotient, x12=remainder
	// Branch to update the total to if x12 is 0
	cbz		x12, _total
	// back to top of the loop
	b       _loop       

_total:
  	cmp		x10, #15
  	beq		_15tot

	add		x13, x13, x9
	// Return to loop
	b		_loop
_15tot:
    add    x14, x14, x9
	// Return to loop
	b		_loop


_print:
	cmp		x10, #3
	beq		_5
	cmp		x10, #5
	beq		_15
	// check we are in the _15 loop
	cmp		x10, #15
	sub		x13, x13, x14	
	mov 	x8,  x13
	str 	x8, [sp]
	adrp	x0, Lstr@PAGE
	add 	x0, x0, Lstr@PAGEOFF
	mov 	x1, xzr
	// Call variadic function from C Runtime Library
	bl 		_printf

	b		_exit

// Normal end of program
_exit:
	ldp x20, x30, [sp], 16
   	mov w0, wzr
   	ret
	.cfi_endproc

	.data
//
Lstr:   .asciz "AARCH64 assembly, Project Euler - Problem 1.\n Sum of all the multiples of 3 or 5 below 1000 =  %d\n"

	.end
