//
// AARCH64 assembler boilerplate -  bptest.S
//
// 	Author: ira
// 	Created on: Mon 20 Mar 2023 17:33:36 GMT
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

// Call variadic function from C Runtime Library
        LLD_ADDR	x0,	Lstr
        CRT 		printf

        b 		exit
// Normal end of program
exit:	ldp		x20, x30, [sp], 16
        mov		w0, wzr
        ret
        .cfi_endproc
        .data

Lstr:	.asciz	"Executing bptest.S\n"

        .end
