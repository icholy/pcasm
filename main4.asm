

;
; file: skel.asm
; This file is a skeleton that can be used to start assembly programs.

%include "asm_io.inc"
segment .data
;
; initialized data is put in the data segment here
;
Sum     dd 0

segment .bss
;
; uninitialized data is put in the bss segment
;
Input   resd 1

segment .text
        global  _asm_main
        extern get_input, print_result
_asm_main:
        enter   0,0               ; setup routine
        pusha

        ; the index
        mov     edx, 1

input_loop:

        ; get a number
        push    edx
        push    dword Input
        call    get_input
        add     esp, 8
        
        ; quit asking if we got zeros
        mov     eax, [Input]
        cmp     eax, 0
        je      end_input_loop

        ; add to sum
        add     [Sum], eax
        
        ; increment the index
        inc     edx

        ; ask for another number
        jmp     short input_loop

end_input_loop:

        push    dword [Sum]
        call    print_result
        pop     ecx

        popa
        mov     eax, 0            ; return back to C
        leave
        ret