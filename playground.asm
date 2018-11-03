

;
; file: skel.asm
; This file is a skeleton that can be used to start assembly programs.

%include "asm_io.inc"
segment .data
;
; initialized data is put in the data segment here
;
hello_msg    db "Hello World!", 0


segment .bss
;
; uninitialized data is put in the bss segment
;

segment .text
        global  _asm_main
_asm_main:

        ; setup
        enter   0,0               ; setup routine
        pusha

        ; main
        mov     eax, hello_msg
        call    print_string
        call    print_nl

        ; cleanup
        popa
        mov     eax, 0            ; return back to C
        leave                     
        ret


