

;
; file: skel.asm
; This file is a skeleton that can be used to start assembly programs.

%include "asm_io.inc"
segment .data
;
; initialized data is put in the data segment here
;
format db `%d\n`, 0

segment .bss
;
; uninitialized data is put in the bss segment
;

segment .text
        extern _scanf, _printf
        global  _asm_main
_asm_main:

        ; setup
        enter   0,0               ; setup routine
        pusha

        ; main
        push    dword 10
        call    foo
        pop     ecx

        ; cleanup
        popa
        mov     eax, 0            ; return back to C
        leave                     
        ret


foo:
        enter   4, 0

        mov     [ebp-4], dword 0; i = 0

foo_loop:
        mov     eax, [ebp-4]   ; eax = i
        cmp     eax, [ebp+8]   ; i < x
        jnl     end_foo_loop

        push    eax
        push    format
        call    _printf
        add     esp, 8

        push    dword [ebp-4]
        call    foo
        pop     ecx

        inc     dword [ebp-4]
        jmp     short foo_loop
end_foo_loop:

        sub     esp, 4
        leave
        ret