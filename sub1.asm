

;
; file: sub1.asm
; Convert first.asm to use subprogram

%include "asm_io.inc"
;
; initialized data is put in the .data segment
;
segment .data
;
; These labels refer to strings used for output
;
prompt1 db    "Enter a number: ", 0       ; don't forget nul terminator
prompt2 db    "Enter another number: ", 0
outmsg1 db    "You entered ", 0
outmsg2 db    " and ", 0
outmsg3 db    ", the sum of these is ", 0


;
; uninitialized data is put in the .bss segment
;
segment .bss
;
; These labels refer to double words used to store the inputs
;
input1  resd 1
input2  resd 1
result  resd 1

 

;
; code is put in the .text segment
;
segment .text
        global  _asm_main
_asm_main:
        enter   0,0               ; setup routine
        pusha

        mov     eax, prompt1      ; print out prompt
        mov     ecx, ret1
        jmp     short print_line
ret1:
        mov     ebx, input1       ; result address
        mov     ecx, ret2         ; return address
        jmp     short get_int
ret2:
        mov     eax, prompt2      ; print out prompt
        mov     ecx, $+7
        jmp     short print_line
ret3:
        mov     ebx, input2
        mov     ecx, ret4
        jmp     short get_int
ret4:
        mov     eax, [input1]     ; eax = dword at input1
        add     eax, [input2]     ; eax += dword at input2
        mov     [result], eax     ; result = eax

        mov     ecx, ret5
        jmp     print_debug
ret5:
        mov     ecx, ret6
        jmp     short print_result
ret6:
;
; next print out result message as series of steps
;

        popa
        mov     eax, 0            ; return back to C
        leave                     
        ret

; Parameters:
;       ebx - address of dword to store integer into
;       ecx - return address
get_int:
        call read_int
        mov [ebx], eax
        jmp ecx

; Parameters
;       eax - address of string
;       ecx - return address
print_line:
        call    print_string
        call    print_nl
        jmp     ecx


; Parameters
;       ecx - return address
print_result:
        mov     eax, outmsg1
        call    print_string      ; print out first message
        mov     eax, [input1]     
        call    print_int         ; print out input1
        mov     eax, outmsg2
        call    print_string      ; print out second message
        mov     eax, [input2]
        call    print_int         ; print out input2
        mov     eax, outmsg3
        call    print_string      ; print out third message
        mov     eax, [result]
        call    print_int         ; print out sum (result)
        call    print_nl          ; print new-line
        jmp     ecx

; Parameters
;       ecx - return address
print_debug:
        dump_regs 1               ; dump out register values
        dump_mem 2, outmsg1, 1    ; dump out memory
        jmp     ecx