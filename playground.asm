

;
; file: skel.asm
; This file is a skeleton that can be used to start assembly programs.

%include "asm_io.inc"
segment .data
;
; initialized data is put in the data segment here
;
message db `Hello World!\n`, 0

segment .bss
;
; uninitialized data is put in the bss segment
;

segment .text
        extern _scanf, _printf
        global  _asm_main

%define answer      [ebp-4]
_asm_main:

        ; setup
        push    ebp          ; save the prev stack frame
        mov     ebp, esp     ; save the current stack frame (so we can access stuff relative to it)
        sub     esp, 4       ; one local variable
        pusha                ; save the registers

        push    message      ; print hello world
        call    _printf
        pop     ecx

        popa                 ; restore the registers
        mov     esp, ebp     ; restore the stack back to where it was (we already did this though)
        pop     ebp          ; restore the previous stack frame
        mov     eax, 0       ; the C return value
        ret