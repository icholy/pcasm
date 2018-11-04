

;
; file: skel.asm
; This file is a skeleton that can be used to start assembly programs.

%include "asm_io.inc"
segment .data
;
; initialized data is put in the data segment here
;
input1_prompt_msg db "Input a number: ", 0
input2_prompt_msg db "Input another number: ", 0
result_prompt_msg db "Max: "

segment .bss
;
; uninitialized data is put in the bss segment
;
input1 resd 1
input2 resd 1
result resd 1
 

segment .text
        global  _asm_main
_asm_main:
        enter   0,0               ; setup routine
        pusha

        ; get the two numbers from the user
        mov     eax, input1_prompt_msg
        call    print_string
        call    read_int
        mov     [input1], eax

        mov     eax, input2_prompt_msg
        call    print_string
        call    read_int
        mov     [input2], eax

        ; find the max

        mov     eax, [input2]

        xor     ebx, ebx
        cmp     eax, [input1]
        setg    bl
        neg     ebx

        and     eax, ebx
        mov     ecx, eax

        mov     eax, [input1]
        not     ebx
        and     eax, ebx

        add     eax, ecx
        mov     [result], eax

        dump_regs 1

        ; print the result
        mov     eax, result_prompt_msg
        call    print_string
        mov     eax, [result]
        call    print_int
        call    print_nl

        popa
        mov     eax, 0            ; return back to C
        leave                     
        ret


