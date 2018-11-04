

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
_asm_main:
        enter   0,0               ; setup routine
        pusha

input_loop:

        ; get a number
        mov     ebx, Input
        call    get_input
        
        ; quit asking if we got zero
        mov     eax, [Input]
        cmp     eax, 0
        je      end_input_loop

        ; add to sum
        add     [Sum], eax

        ; ask for another number
        jmp     short input_loop

end_input_loop:

        mov     ebx, [Sum]
        call    print_result

        popa
        mov     eax, 0            ; return back to C
        leave                     
        ret    

segment .data

IntputPrompt    db "Enter a number (0 to quit): ", 0
ResultPrefix    db "The sum is: ", 0
OverflowError   db "The sum overflowed", 0

segment .text
; Parameters
;       ebx - result address
get_input:
        mov     eax, IntputPrompt
        call    print_string
        call    read_int
        mov     [ebx], eax
        ret

; Parameters
;       ebx - result value
print_result:
        mov     eax, ResultPrefix
        call    print_string
        mov     eax, ebx
        call    print_int
        call    print_nl
        ret


