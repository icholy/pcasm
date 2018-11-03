

;
; file: skel.asm
; This file is a skeleton that can be used to start assembly programs.

%include "asm_io.inc"
segment .data
;
; initialized data is put in the data segment here
;
prompt        db "Enter a number: ", 0
ident_msg     db "Identify is ", 0
square_msg    db "Square of input is ", 0
cube_msg      db "Cube of input is ", 0
cube25_msg    db "Cube of input times 25 is ", 0
quot_msg      db "Quotien of cube/100 is ", 0
rem_msg       db "Remainder of cube/100 is ", 0
neg_msg       db "The negation of the remander is ", 0


segment .bss
;
; uninitialized data is put in the bss segment
;
input resd 1
 

segment .text
        global  _asm_main
_asm_main:

; setup
        enter   0,0               ; setup routine
        pusha

        ; prompt for input
        mov     eax, prompt
        call    print_string
        call    read_int
        mov     [input], eax

        ; print the identity
        mov     eax, ident_msg
        call    print_string
        mov     eax, [input]
        call    print_int
        call    print_nl

        ; print the square
        mov     eax, [input]
        imul    eax
        mov     ebx, eax
        mov     eax, square_msg
        call    print_string
        mov     eax, ebx
        call    print_int
        call    print_nl

        ; print cube
        mov     ebx, [input]
        mov     eax, ebx
        imul    ebx
        imul    ebx
        mov     ebx, eax
        mov     eax, cube_msg
        call    print_string
        mov     eax, ebx
        call    print_int
        call    print_nl

        ; print cube * 25
        mov     ebx, [input]
        mov     eax, ebx
        imul    ebx
        imul    ebx
        mov     ebx, 25
        imul    ebx
        mov     ebx, eax
        mov     eax, cube_msg
        call    print_string
        mov     eax, ebx
        call    print_int
        call    print_nl



; cleanup


        popa
        mov     eax, 0            ; return back to C
        leave                     
        ret


