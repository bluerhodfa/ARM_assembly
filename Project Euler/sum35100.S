//
// ARM assembler program 
//  
// Project Euler: Problem 1
// Find the sum of all the multiples of 3 or 5 below 1000.
//
// Tested on: 
//              Macbook Pro M2 MacOS 12.6.3
//              Linux Fedora 6.1.14-200,fc37.aarch64              
//
//  Compile and run
//      gcc -o sum35100 sum351000.S
//      ./sum351000
//
// include my MACROS for cross compliation on Linux and Apple Silicon
#include "../aarch64_macros.S"

        .p2align 2
        .text
        GLABEL main

MAIN
        .cfi_startproc
// preserve the stack
        stp             x20,x30, [sp, -16]!
        mov             x29, sp
// Start message
start:  LLD_ADDR        x0, StartStr
        mov             x1, xzr
// Call variadic function from C Runtime Library
        CRT             printf
        b               code
// program code
code:
        LLD_ADDR    x0,     Dstr
        mov         x1,     xzr
#if defined(__APPLE__)
        bl              _divide
#else
        bl              divide
#endif
        mov         x0, 16
        ret
// Branch to exit
        b               exit
// Normal end of program
exit:   ldp             x20, x30, [sp], 16
        mov             w0, wzr
        ret
        .cfi_endproc

// Pogram data section
        .data
// Function for dividing numbers
        .text
        .p2align    4
#if defined(__APPLE__)
        .global _divide, @function
_divide:
#else
        .type _divide, @function
divide:
#endif
// Save register x30 before calling our function
        str         x30,    [sp, -16]!
        CRT         printf
//restore  register x30 before returning
        ldr         x30,    [sp], 16
        ret

StartStr:       .byte 0x1B      // clear screen 
		.byte 'c'	// and start msg at
		.byte 1		// top of screen
                .asciz  "Project Euler Problem 1\n\n"
                .asciz  "\n\n"
                .byte 255
        .p2align    4
Dstr:           .asciz  "\t Divide function called \n\n"
        .end