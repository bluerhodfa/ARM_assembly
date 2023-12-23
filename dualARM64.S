//
// ARM assembler program to print string
// using C library function call 
//
// Tested on: 
//              Macbook Pro M2 MacOS 12.6.3
//              Linux Fedora 6.1.14-200,fc37.aarch64              
//
//  Compile and run
//      gcc -o dualARM64 dualARM64.S
//      ./dualARM64
//
// include my MACROS for cross compliation on Linux and Apple Silicon
#include "aarch64_macros.S"

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
        LLD_ADDR        x0, helloFred
        mov             x1, xzr
        CRT             printf
// Branch to exit
        b               end
// 
// End message
end:    LLD_ADDR        x0, ExitStr
        mov             x1, xzr
// Call variadic function from C Runtime Library
        CRT             printf
        b               exit
// Normal end of program
exit:   ldp             x20, x30, [sp], 16
        mov             w0, wzr
        ret
        .cfi_endproc

// Pogram data section
        .data
StartStr:       .byte 0x1B      // clear screen 
		.byte 'c'	// and start msg at
		.byte 1		// top of screen
                .asciz  "Program start \n\n"
                .asciz  "\n\n"
                .byte 255
ExitStr:        .asciz  "Program exited successfully \n\n"
helloFred:      .asciz  "\t Hello Fred %d\n\n"
        .end