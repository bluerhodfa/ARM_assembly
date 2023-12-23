/*******************************************/
/* Constantes                              */
/*******************************************/
.equ STDIN,  0                // Linux input console
.equ STDOUT, 1                // linux output console
.equ OPEN,   56               // call system Linux 64 bits
.equ CLOSE,  57               // call system Linux 64 bits
.equ READ,   63               // call system Linux 64 bits 
.equ WRITE,  64               // call system Linux 64 bits 
.equ EXIT,   93               // call system Linux 64 bits 
.equ HEAPSIZE,   100000
.equ CHARPOS,       '@'       // position character

/*  file */
.equ O_RDONLY, 0
.equ O_WRONLY, 0x0001    
.equ O_RDWR,   0x0002          // open for reading and writing

.equ O_CREAT,  0x040           // create if nonexistant
.equ O_TRUNC,  0x0400          // truncate to zero length
.equ O_EXCL,   0x0800          // error if already exists 

.equ AT_FDCWD,    -100