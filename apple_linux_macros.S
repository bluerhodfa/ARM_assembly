// Macros for Apple and Linux assembly on AARCH64
//
// Ira Theobold 2023
//

.macro GLABEL label
#if defined(__APPLE__)
        .global _\label
#else
        .global \label
#endif
.endm

.macro MAIN
#if defined(__APPLE__)
_main:
#else
main:
#endif
.endm

// Call C runtime library function
.macro CRT  label
#if defined(__APPLE__)
    bl  _\label
#else
    bl  \label
#endif
.endm

.macro  LLD_ADDR xreg, label
#if defined(__APPLE__)
        adrp    \xreg, \label@PAGE
        add     \xreg, \xreg, \label@PAGEOFF
#else
        ldr     \xreg, =\label
#endif
.endm