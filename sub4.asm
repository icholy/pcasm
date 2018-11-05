

;
; file: skel.asm
; This file is a skeleton that can be used to start assembly programs.

%include "asm_io.inc"

segment .data

IntputPrompt1    db "Enter number  ", 0
IntputPrompt2    db " (0 to quit): ", 0
ResultPrefix    db "The sum is: ", 0
OverflowError   db "The sum overflowed", 0

segment .text
        global get_input, print_result
; Parameters
;       [ebp+8] result address
get_input:
        ; save the old base pointer
        push    ebp
        mov     ebp, esp

        ; print the prompt with the current index
        mov     eax, IntputPrompt1
        call    print_string
        mov     eax, [ebp+12]
        call    print_int
        mov     eax, IntputPrompt2
        call    print_string

        ; ask for a number
        call    read_int
        mov     ebx, [ebp+8]
        mov     [ebx], eax

        ; restore the prev base pointer
        pop     ebp
        ret

; Parameters
;       [ebp+8] - result value
print_result:
        ; save old base pointer
        push    ebp
        mov     ebp, esp

        mov     eax, ResultPrefix
        call    print_string
        mov     eax, [ebp+8]
        call    print_int
        call    print_nl

        ; restore the prev base pointer
        pop     ebp
        ret


