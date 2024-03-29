/*   File include fonctions   */
.data
ptzZoneHeap:   .quad zZoneHeap
.bss
.align 8
zZoneHeap:              .skip HEAPSIZE
zEndZoneHeap:
.text
/******************************************************************/
/*     String display with  size compute                          */
/******************************************************************/
/* x0 contains string address (string ended with zero binary) */
affichageMess:
    stp x0,x1,[sp,-16]!        // save  registers
    stp x2,x8,[sp,-16]!        // save  registers
    mov x2,0                   // size counter
1:                             // loop start
    ldrb w1,[x0,x2]            // load a byte
    cbz w1,2f                  // if zero -> end string
    add x2,x2,#1               // else increment counter
    b 1b                       // and loop
2:                             // x2 =  string size
    mov x1,x0                  // string address
    mov x0,STDOUT              // output Linux standard
    mov x8,WRITE               // code call system "write"
    svc 0                      // call systeme Linux
    ldp x2,x8,[sp],16          // restaur  2 registres
    ldp x0,x1,[sp],16          // restaur  2 registres
    ret                        // retour adresse lr x30
/******************************************************************/
/*     Decimal conversion unsigned                             */ 
/******************************************************************/
/* x0 contains the value  */
/* x1 contains the address of receiving area  length >= 21 */
/* the receiving area return a string ascii left aligned */
/* and with final zero */
/* x0 return length string whitout zero final  */
.equ LGZONECONV,   20
conversion10:
    stp x5,lr,[sp,-16]!        // save  registers
    stp x3,x4,[sp,-16]!        // save  registers
    stp x1,x2,[sp,-16]!        // save  registers
    mov x4,#LGZONECONV         // position last digit
    mov x5,#10                 // decimal conversion
1:                             // loop begin
    mov x2,x0                  // copy starting number or successive quotients
    udiv x0,x2,x5              // division by ten
    msub x3,x0,x5,x2           //compute remainder
    add x3,x3,#48              // digit
    sub x4,x4,#1               // previous position
    strb w3,[x1,x4]            // store digit ascii
    cbnz x0,1b                 // end if quotient = zero
    mov x2,LGZONECONV          // compute string length (20 - dernière position)
    sub x0,x2,x4               // no instruction rsb in 64 bits !!!
                               // move result to area begin
    cbz x4,3f                  // full area ?
    mov x2,0                   // start position
2:    
    ldrb w3,[x1,x4]            // load digit
    strb w3,[x1,x2]            // store digit
    add x4,x4,#1               // next position origin
    add x2,x2,#1               // and next position destination
    cmp x4,LGZONECONV - 1      // end ?
    ble 2b                     // else loop
3: 
    mov w3,0
    strb w3,[x1,x2]             // zero final
100:
    ldp x1,x2,[sp],16          // restaur des  2 registres
    ldp x3,x4,[sp],16          // restaur des  2 registres
    ldp x5,lr,[sp],16          // restaur des  2 registres
    ret                        // retour adresse lr x30
/******************************************************************/
/*     Decimal conversion signed                             */ 
/******************************************************************/
/* x0 contains the value  */
/* x1 contains the address of receiving area  length >= 21 */
/* the receiving area return a string ascii left aligned */
/* et avec un zero final */
/* x0 return length string whitout zero final  */
.equ LGZONECONVS,   21
conversion10S:
    stp x5,lr,[sp,-16]!        // save  registers
    stp x3,x4,[sp,-16]!        // save  registers
    stp x1,x2,[sp,-16]!        // save  registers
    cmp x0,0                   // is negative ?
    bge 11f                    // no 
    mov x3,'-'                 // yes
    neg x0,x0                  // number inversion 
    b 12f
11:
    mov x3,'+'                 // positive number
12:
    strb w3,[x1]
    mov x4,#LGZONECONVS         // position last digit
    mov x5,#10                 // decimal conversion 
1:                             // loop conversion start
    mov x2,x0                  // copy starting number or successive quotients
    udiv x0,x2,x5              // division by ten
    msub x3,x0,x5,x2           //compute remainder
    add x3,x3,#48              // conversion ascii
    sub x4,x4,#1               // previous position
    strb w3,[x1,x4]            // store digit
    cbnz x0,1b                 // end if quotient = zero

    mov x2,LGZONECONVS          // compute string length (21 - dernière position)
    sub x0,x2,x4               // no instruction rsb in 64 bits !!!
                               // move result to area begin
    cmp x4,1
    beq 3f                     // full area ?
    mov x2,1                   // no -> begin area 
2:    
    ldrb w3,[x1,x4]            // load a digit
    strb w3,[x1,x2]            // and store at begin area
    add x4,x4,#1               // last position
    add x2,x2,#1               // et begin last postion
    cmp x4,LGZONECONVS - 1      // end ?
    ble 2b                     // no -> loop 
3: 
    mov w3,0
    strb w3,[x1,x2]            // zero final
    add x0,x0,1                // string length must take into account the sign
100:
    ldp x1,x2,[sp],16          // restaur  2 registers
    ldp x3,x4,[sp],16          // restaur  2 registers
    ldp x5,lr,[sp],16          // restaur  2 registers
    ret                        // return address lr x30
/******************************************************************/
/*     conversion  hexadecimal register                           */ 
/******************************************************************/
/* x0 contains value and x1 address zone receptrice   */
conversion16:
    stp x0,lr,[sp,-48]!        // save  registres
    stp x1,x2,[sp,32]          // save  registres
    stp x3,x4,[sp,16]          // save  registres
    mov x2,#60                 // start bit position
    mov x4,#0xF000000000000000 // mask
    mov x3,x0                  // save entry value
1:                             // start loop
    and x0,x3,x4               // value register and mask
    lsr x0,x0,x2               // right shift
    cmp x0,#10                 // >= 10 ?
    bge 2f                     // yes
    add x0,x0,#48              // no is digit
    b 3f
2:
    add x0,x0,#55              // else is a letter A-F
3:
    strb w0,[x1],#1            // load result  and + 1 in address
    lsr x4,x4,#4               // shift mask 4 bits left
    subs x2,x2,#4              // decrement counter 4 bits <= zero  ?
    bge 1b                     // no -> loop

100:                           // fin standard de la fonction
    ldp x3,x4,[sp,16]          // restaur des  2 registres
    ldp x1,x2,[sp,32]          // restaur des  2 registres
    ldp x0,lr,[sp],48          // restaur des  2 registres
    ret    
/******************************************************************/
/*     conversion ascii string to number                          */ 
/******************************************************************/
/* x0 contains string address ended by 0x0 or 0xA */
/* x0 return the number  */ 
conversionAtoD:
    stp x5,lr,[sp,-16]!        // save  registers
    stp x3,x4,[sp,-16]!        // save  registers
    stp x1,x2,[sp,-16]!        // save  registers
    mov x1,#0
    mov x2,#10             // factor ten
    mov x4,x0              // save address in x4
    mov x3,#0              // positive signe by default
    mov x0,#0              // init résult to zéro
    mov x5,#0
1:                         // loop to remove space at begin of string
    ldrb w5,[x4],1         // load in w5 string octet 
    cbz w5,100f            // string end -> end routine
    cmp w5,#0x0A           // string end -> end routine
    beq 100f
    cmp w5,#' '            // space ?
    beq 1b                 // yes -> loop
2:
    cmp x5,#'-'            // first character is -
    bne 3f
    mov x3,#1              // negative number
    b 4f                   // previous position
3:                         // begin loop compute digit
    cmp x5,#'0'            // character not a digit
    blt 4f
    cmp x5,#'9'            // character not a digit
    bgt 4f
                           // character is a digit
    sub w5,w5,#48

    mul x0,x2,x0           // multiply last result by factor
    smulh x1,x2,x0         // hight 
    cbnz x1,99f            // overflow ?
    add x0,x0,x5           // no -> add to result
4:
    ldrb w5,[x4],1         // load new octet and increment to one
    cbz w5,5f              // string end -> end routine
    cmp w5,#0xA            // string end ?
    bne 3b                 // no -> loop
5:
    cmp x3,#1              // test register x3 for signe
    cneg x0,x0,eq          // if equal egal negate value
    cmn x0,0               // carry to zero no error
    b 100f
99:                        // overflow
    adr x0,szMessErrDep
    bl  affichageMess
    cmp x0,0               // carry to one  error
    mov x0,#0              // if error return zéro
100:
    ldp x1,x2,[sp],16      // restaur  2 registers
    ldp x3,x4,[sp],16      // restaur  2 registers
    ldp x5,lr,[sp],16      // restaur  2 registers
    ret                    // retur address lr x30
szMessErrDep:      .asciz "Number too large: overflow of 64 bits. :\n"
.align 4                   // instruction to realign the following routines
/***************************************************/
/*   reserve heap area                             */
/***************************************************/
// x0 contains size in byte to reserve */
// x0 returne  begin address of area */
reserverPlace:              // INFO: reserverPlace
    stp x1,lr,[sp,-16]!     // save  registers
    stp x2,x3,[sp,-16]!     // save  registers
    mov x1,x0
    tst x1,#0b111           // size multiple of 8 ?
    beq 1f                  // yes
    and x1,x1,0xFFFFFFFFFFFFFFF8 // else align to 8 superior
    add x1,x1,8
1:
    ldr x2,qAdrptzZoneHeap
    ldr x0,[x2]
    add x1,x1,x0            //  size too large ?
    ldr x3,qAdrzEndZoneHeap
    cmp x1,x3
    blt 2f                  // no it is ok
    adr x0,szMessErrTas     // yes -> error
    bl affichageMess
    mov x0,#-1
    b 100f
2:
    str x1,[x2]            // store new pointer
100:                       // fin standard de la fonction
    ldp x2,x3,[sp],16      // restaur  2 registers
    ldp x1,lr,[sp],16      // restaur  2 registers
    ret                    // retur address lr x30
qAdrptzZoneHeap:       .quad ptzZoneHeap
qAdrzEndZoneHeap:      .quad zEndZoneHeap
szMessErrTas:          .asciz "Error : heap not large !!!\n"
.align 4
/***************************************************/
/*   liberer place sur le tas                     */
/***************************************************/
// r0 contains begin address area 
libererPlace:               // INFO: libererPlace
    stp x1,lr,[sp,-16]!     // save  registers
    ldr x1,qAdrzZoneHeap
    cmp x0,x1
    blt 99f
    ldr x1,qAdrzEndZoneHeap
    cmp x0,x1
    bge 99f
    ldr x1,qAdrptzZoneHeap
    str x0,[x1]
    b 100f
99:
    adr x0,szMessErrTas1
    bl affichageMess
    mov x0,-1
100:
    ldp x1,lr,[sp],16      // restaur  2 registers
    ret                    // retur address lr x30
qAdrzZoneHeap:    .quad zZoneHeap
szMessErrTas1:    .asciz "Error : address  < or > heap addresses !!!\n"
.align 4

/******************************************************************/
/*   insert string at character insertion  */ 
/******************************************************************/
/* x0 contains the address of string 1 */
/* x1 contains the address of insertion string   */
/* x0 return the address of new string  on the heap */
/* or -1 if error   */
strInsertAtCharInc:
    stp x2,lr,[sp,-16]!                      // save  registers
    stp x3,x4,[sp,-16]!                      // save  registers
    stp x5,x6,[sp,-16]!                      // save  registers
    stp x7,x8,[sp,-16]!                      // save  registers
    mov x3,#0                                // length counter 
1:                                           // compute length of string 1
    ldrb w4,[x0,x3]
    cmp w4,#0
    cinc  x3,x3,ne                           // increment to one if not equal
    bne 1b                                   // loop if not equal
    mov x5,#0                                // length counter insertion string
2:                                           // compute length to insertion string
    ldrb w4,[x1,x5]
    cmp x4,#0
    cinc  x5,x5,ne                           // increment to one if not equal
    bne 2b                                   // and loop
    cmp x5,#0
    beq 99f                                  // string empty -> error
    add x3,x3,x5                             // add 2 length
    add x3,x3,#1                             // +1 for final zero
    mov x6,x0                                // save address string 1
    mov x0,x3
    bl reserverPlace
    cmp x0,#-1                               // allocation error
    beq 99f
    mov x5,x0                                // save address heap for output string
    mov x2,0
    mov x4,0               
3:                                           // loop copy string begin 
    ldrb w3,[x6,x2]
    cmp w3,0
    beq 99f
    cmp w3,CHARPOS                           // insertion character ?
    beq 5f                                   // yes
    strb w3,[x5,x4]                          // no store character in output string
    add x2,x2,1
    add x4,x4,1
    b 3b                                     // and loop
5:                                           // x4 contains position insertion
    add x8,x4,1                              // init index character output string
                                             // at position insertion + one
    mov x3,#0                                // index load characters insertion string
6:
    ldrb w0,[x1,x3]                          // load characters insertion string
    cmp w0,#0                                // end string ?
    beq 7f                                   // yes 
    strb w0,[x5,x4]                          // store in output string
    add x3,x3,#1                             // increment index
    add x4,x4,#1                             // increment output index
    b 6b                                     // and loop
7:                                           // loop copy end string 
    ldrb w0,[x6,x8]                          // load other character string 1
    strb w0,[x5,x4]                          // store in output string
    cmp x0,#0                                // end string 1 ?
    beq 8f                                   // yes -> end
    add x4,x4,#1                             // increment output index
    add x8,x8,#1                             // increment index
    b 7b                                     // and loop
8:
    mov x0,x5                                // return output string address 
    b 100f
99:                                          // error
    mov x0,#-1
100:
    ldp x7,x8,[sp],16                        // restaur  2 registers
    ldp x5,x6,[sp],16                        // restaur  2 registers
    ldp x3,x4,[sp],16                        // restaur  2 registers
    ldp x2,lr,[sp],16                        // restaur  2 registers
    ret
