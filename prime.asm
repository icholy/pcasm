

;
; file: skel.asm
; This file is a skeleton that can be used to start assembly programs.

%include "asm_io.inc"
segment .data
;
; initialized data is put in the data segment here
;
PromptMsg db "Find primes up to: ", 0


segment .bss
;
; uninitialized data is put in the bss segment
;
Guess   resd 1
Factor  resd 1
Limit   resd 1


 

segment .text
        global  _asm_main
_asm_main:
        enter   0,0               ; setup routine
        pusha


        ; read the limit
        mov     eax, PromptMsg
        call    print_string
        call    read_int
        mov     [Limit], eax

        ; treat first two primes as special cases
        mov     eax, 2
        call    print_int
        call    print_nl
        mov     eax, 3
        call    print_int
        call    print_nl

        ; initial guess
        mov     dword [Guess], 5

while_limit:

        ; while guess <= limit
        mov     eax, [Guess]
        mov     ebx, [Limit]
        cmp     eax, ebx
        jnbe    end_while_limit

        ; look for factor of guess
        mov     ebx, 3 ; ebx is factor = 3
while_factor:

        ; while condition: factor * factor
        mov     eax, ebx ; factor * factor
        mul     eax
        jo      end_while_factor ; if answer won't fit in eax
        cmp     eax, [Guess]
        jnb     end_while_factor

        ; while condition: guess % factor != 0
        mov     eax, [Guess]
        mov     edx, 0
        div     ebx
        cmp     edx, 0
        je      end_while_factor

        add     ebx, 2 ; factor += 2
        jmp     while_factor

end_while_factor:
        je      end_if
        mov     eax, [Guess]
        call    print_int
        call    print_nl

end_if:
        add     dword [Guess], 2
        jmp     while_limit

end_while_limit:


        popa
        mov     eax, 0            ; return back to C
        leave                     
        ret


