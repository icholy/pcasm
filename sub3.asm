

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

        ; the index
        mov     edx, 1

input_loop:

        ; get a number
        push    edx
        push    dword Input
        call    get_input
        add     esp, 8
        
        ; quit asking if we got zero
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

segment .data

IntputPrompt1    db "Enter number  ", 0
IntputPrompt2    db " (0 to quit): ", 0
ResultPrefix    db "The sum is: ", 0
OverflowError   db "The sum overflowed", 0

segment .text
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


