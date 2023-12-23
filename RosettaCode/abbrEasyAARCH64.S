/* ARM assembly AARCH64 Raspberry PI 3B */
/*  program include.s   */

/*******************************************/
/* Constantes file                             */
/*******************************************/
.include "../include/includeConstantsARM64.inc"

/*******************************************/
/* Initialized data                        */
/*******************************************/
.data
szMessResult:  .asciz "Number = "
szRetourLigne: .asciz "\n"
/*******************************************/
/* Uninitialized data                       */
/*******************************************/
.bss
sZoneConv:                   .skip 100
.text
.global _main 
_main:
    .cfi_startproc
    mov x0,1000                  // number 
    ldr x1,qAdrsZoneConv
    bl conversion10S              // result decimal conversion
    ldr x0,qAdrszMessResult
    bl affichageMess              // call function display
    ldr x0,qAdrsZoneConv
    bl affichageMess              // call function display
    ldr x0, qAdrszRetourLigne
    bl affichageMess
    mov x0,0                      // return code OK
100:                              // standard end programm
    mov x8,EXIT                   // request to exit program
    svc 0                         // perform the system call
qAdrszMessResult:            .quad szMessResult
qAdrsZoneConv:               .quad sZoneConv
qAdrszRetourLigne:           .quad szRetourLigne
/********************************************************/
/*        File Include fonctions                        */
/********************************************************/
.include "../include/includeARM64.inc"
.cfi_endproc
.end