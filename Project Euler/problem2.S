//
// ARM assembler program
//
// Project Euler: Problem 2
// Find the sum of all the even-valued terms in the Fibonacci sequence which do not exceed four million.
//
// A direct translation of the problem statement would be a program like this:
//	 Pseudo code:
//
//	 	limit=4000000
// 		sum=0
// 		a=1
// 		b=1
// 		while b<limit
// 	 	  if b mod 2=0 then sum=sum+b
//  	  	h=a+b
//    		a=b
//    		b=h
// 		output sum
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
    mov     x29, sp

// init registers

//	"Answer using Phi golden ratio",sum)

	adrp x9, fourmill@PAGE				// limit=4000000
	ldr x10, [x9, fourmill@PAGEOFF]
	//	evenSum, a, b = 0, 1, 2
	// load 4M into register pair as a
	mov	x11, #0							// sum=0
	mov x12, #1							// a=1
	mov x13, #2							// b=1 
	mov x14, #0							// counter 
	mov x2, #0							// 
	mov x3, #0							// 
	b _loop

_loop:
	// while b < 4000000
	add	x14, x14, #1				// increment loop counter
	// end when we get to 0 in x9 loop counter
	cmp x14, x10
    beq  _print

	// if b % 2 == 0:
	// input: x9=dividend, x13=divisor
	udiv x2, x14, x13
	msub x3, x2, x13, x14
	// result: x2=quotient, x3=remainder
	cbz	x3,	_evensum
	b	_print

_evensum:
	// evensum += b
	add	x11, x11, x2
	// a, b = b, a+b
	mov	x12, x13
	add x13, x13, x12
	b	_loop

//  print("Answer using Even Sum = ", evenSum)
_print:
    mov     x8, x11
    str     x8, [sp]
    adrp    x0, Lstr@PAGE
    add     x0, x0, Lstr@PAGEOFF
    mov     x1, xzr
    // Call variadic function from C Runtime Library
    bl      _printf

	b       _exit

	// Normal end of program
_exit:
    ldp x20, x30, [sp], 16
    mov w0, wzr
    ret
    .cfi_endproc

    .data
//
fourmill: .long 4000000	
Lstr: .asciz "AARCH64 assembly, Project Euler - Problem 2.\n Sum of all the even-valued terms in the Fibonacci sequence which do not exceed four million =  %d\n"

    .end
