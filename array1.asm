%define ARRAY_SIZE 100
%define NEW_LINE 10

;
; file: skel.asm
; This file is a skeleton that can be used to start assembly programs.

segment .data
;
; initialized data is put in the data segment here
;
FirstMsg        db "First 10 elements of array", 0
Prompt          db "Enter index of element to display: ", 0
SecondMessage   db "Element %d is %d", NEW_LINE, 0
ThirdMsg        db "Elements 20 through 29 of array", 0
InputFormat     db "%d", 0


segment .bss
;
; uninitialized data is put in the bss segment
;
array   resd ARRAY_SIZE


segment .text
        global  _asm_main
        extern  _printf, _scanf, _dump_line
_asm_main:
        enter   4,0               ; setup routine
        push    ebx
        push    esi

; initialize array to 100, 99, 98, 97, etc ...

        mov     ecx, ARRAY_SIZE
        mov     ebx, array
init_loop:
        mov     [ebx], ecx
        add     ebx, 4
        loop    init_loop

; print out the first message
        push    FirstMsg
        call    _printf
        pop     ecx
        
        push    dword 10
        push    dword array
        call    _print_array
        add     esp, 8


; prompt 

prompt_loop:
        ; puts the prompt
        push    dword Prompt
        call    _printf
        pop     ecx

        ; scanf the index
        lea     eax, [ebp-4]
        push    eax
        push    dword InputFormat
        call    _scanf
        add     esp, 8

        ; scanf returns the number of scanned items, we want 1
        cmp     eax, 1
        je      input_ok

        ; try again
        call    _dump_line
        jmp     prompt_loop

input_ok:

;
; code is put in the text segment. Do not modify the code before
; or after this comment.
;

        pop     esi
        pop     ebx
        mov     eax, 0            ; return back to C
        leave
        ret

; 
; routine _print_array
; C prototype:
;       void _print_array(const int * a, int n);
; Parameters:
;       a - first element address
;       n - number of elements to print
segment .data
OutputFormat    db "%-5d %5d", NEW_LINE, 0

segment .text
_print_array:
        enter   0, 0
        push    esi
        push    ebx

        xor     esi, esi      ; esi = 0
        mov     ecx, [ebp+12] ; ecx = n
        mov     ebx, [ebp+8]  ; ebx = address of array
print_loop:
        push    ecx ; save ecx

        ; printf(OutputFormat, esi, [ebx+esi*4]);
        push    dword [ebx + 4*esi]
        push    esi
        push    dword OutputFormat
        call    _printf
        add     esp, 12

        pop     ecx ; restore ecx
        inc     esi
        loop    print_loop

        pop     ebx
        pop     esi
        leave
        ret