//
// Funcions for Linux and Apple silicon 
//
// Ira Theobold
//
// This follows the AArch64 ABI https://developer.arm.com/documentation/den0024/a/The-ABI-for-ARM-64-bit-Architecture
//
// Print function
//
// register usage:      x0, address of string to print
//                      x1, length of string
//                      x2, used for syscall
//                      x8, syscall
//
//

	.p2align 2
        .text
#if defined(__APPLE__)
	.global print, @function
_print:
#else
        .type print, @function  // these two directives make the function
print:
#endif

        .globl print            // callable from other object files.
        mov     x2, x1          // move length into place for syscall
        mov     x1, x0          // move string address into place for syscall
        mov     x0, #1          // print to stdout
        mov     x8, #0x40       // do a write system call
        svc     #0
        ret                     // return to caller

// end of print function
//
// -------------------------------------------------------------------------------- //
//
// ???? function
//

