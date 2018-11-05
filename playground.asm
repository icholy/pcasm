

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

Sum     resd 0

segment .text
        global  _asm_main
_asm_main:

        ; setup
        enter   0,0               ; setup routine
        pusha

        ; main
        push    Sum
        push    2
        call    calc_sum
        add     esp, 8

        ; print the result
        mov     eax, [Sum]
        call    print_int
        call    print_nl

        ; cleanup
        popa
        mov     eax, 0            ; return back to C
        leave                     
        ret

; Parameters
;       n [ebp+8] - values to sum
;       sump [ebp+12] - result address
calc_sum:
        push    ebp
        mov     ebp, esp
        sub     esp, 4 ; local sum [ebp-4]

        mov     dword [ebp-4], 0
        mov     ecx, [ebp+8] ; counter

sum_loop:
        add [ebp-4], ecx
        loop sum_loop

        mov eax, [ebp-4] ; result
        mov ebx, [ebp+12] ; result address
        mov [ebx], eax

        mov     esp, ebp
        pop     ebp
        ret