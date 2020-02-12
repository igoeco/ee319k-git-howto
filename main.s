; main.s
; Author: Ramesh Yerraballi
; Toggle PF3 (Green LED) in the TM4C
GPIO_PORTF_DATA_R  EQU 0x400253FC
GPIO_PORTF_DIR_R   EQU 0x40025400
GPIO_PORTF_DEN_R   EQU 0x4002551C
SYSCTL_RCGCGPIO_R  EQU 0x400FE608
        AREA    |.text|, CODE, READONLY, ALIGN=2
        THUMB
        EXPORT  Start
Start
   LDR R0,=SYSCTL_RCGCGPIO_R  
   LDR R1,[R0]    
   ORR R1,#0x20 ;turn on clock F
   STR R1,[R0]   
   NOP          ;wait for clock to stabilize
   NOP
   LDR R0,=GPIO_PORTF_DIR_R
   MOV R1,#0x08 ;PF3 is an output pin
   STR R1,[R0]
   LDR R0,=GPIO_PORTF_DEN_R
   MOV R1,#0x08 ;PF3 is digital enabled
   STR R1,[R0]
loop 
   LDR R0,=GPIO_PORTF_DATA_R ; load current state of PF3
   LDR R1,[R0]
   EOR R1,#0x08 ;toggle PF3 pin using Exclusive-OR
   STR R1,[R0]
   LDR R0,=1000000
   BL Delay
   B loop
   
; Delay subroutine 
; R0: Input
Delay
   SUBS R0,R0,#1
   BNE  Delay         ; Delay loop to see the flashing
   BX   LR


    ALIGN                           ; make sure the end of this section is aligned
    END                             ; end of file
