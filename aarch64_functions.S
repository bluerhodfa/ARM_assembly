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
//
// Start of print function
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
//divide  function
//
        .p2align    2
#if defined(__APPLE__)
        .global _divide, @function
_divide:
#else
        .type divide, @function
divide:
#endif
// Save register x30 before calling our function
        str         x30,    [sp,-16]

        mov         x0, #10        //; init counter
        mov         x1, #0  
        mov         x8, #0          //; init total
subtract:
        sdiv        x1, x0, x2      //;subtract x2 from x0 and store result in x1
        msub        x3, x2, x1, x0  //; result: x2=quotient, x3=remainder 
        sub         x0, x0, #1      //; subtract 1 from counter
        cbz         x3, total       //; Branch to update the total to if x3 is 0
        cbz         x0, result      //; end when we get to 0 in x0 loop counter
        b           subtract        //; back to top of the loop
        b           fend

total:  add         x8, x8, x1      //; add x1 to x8 to update total 
        b           subtract        //; back to top of the loop
fend:
//restore  register x30 before returning
        ldr         x30,    [sp], 16
        ret
