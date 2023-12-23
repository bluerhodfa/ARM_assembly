//
// AARCH64 assembler boilerplate - 1Continue.S
//
// 	Author: ~/Library/Mobile Documents/com~apple~CloudDocs/code/ARM_assembly/RosettaCode
// 	Created on: Wednesday 22 March 2023 at 10:23 Unix time: 1679480637
//

.p2align 2
.text
.global _main

// Constants
//
// SVC codes
.equ    SVCEXIT,    98
.equ    SVCWRITE,   64
//
.equ    STDIN,  0                // input console
.equ    STDOUT, 1                // output console
//
_main:
.cfi_startproc
// preserve the stack
        stp     x20,x30, [sp, -16]!
        mov     x29, sp

        mov     x9, #1      // 1 counter
        mov     x10, #10      // 1  max
        b _loop
_loop:
        b       _print
        cmp     x9, x10     // Compare x9 against x10
        bge     _exit        // If x9 >= x10
        add     x9, x9, #1  // Add x2 to x1 and store the res9lt 9n #1
        b       _loop

_print:
        stp     x20,x30, [sp, -16]!
        mov     x29, sp
        mov x8, x9          // Copy x9 into x8 (ndirect result location register)
        str x8, [sp]        // Store data from x9 on stack[sp]  
        mov x1,x0                  // string address
        mov x0,STDOUT              // output Linux standard
        adrp x8,SVCWRITE@PAGE               // code call system "write"
        add x8, x8, SVCWRITE@PAGEOFF // Add SVCRITE@PAGEOFF to x8 and store the result in x8
        svc 0  
        b    exit        
// Call variadic function from C Runtime Library
        adrp    x0,	prtlin@PAGE
        add     x0, x0, prtlin@PAGEOFF // Add x0 to x0 aLstr@PAGEOFF store the result in x
        mov     x1, xzr         // Copy  x1 into x    
        bl      _printf         // Call _printf
        ldp		x20, x30, [sp], 16
        b       _loop           // Return to _loop
// Normal end of program
_exit:	ldp		x20, x30, [sp], 16
        mov		w0, wzr
        ret
        .cfi_endproc
        .data
prtlin:     .asciz  "%d, "
szComma:    .asciz  ", "
szNewline:  .asciz  "\n "
        .end