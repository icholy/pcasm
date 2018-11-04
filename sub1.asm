

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
        call    print_string

        mov     ebx, input1       ; result address
        call    get_int

        mov     eax, prompt2      ; print out prompt
        call    print_string

        mov     ebx, input2
        call    get_int

        mov     eax, [input1]     ; eax = dword at input1
        add     eax, [input2]     ; eax += dword at input2
        mov     [result], eax     ; result = eax

        call    print_debug
        call    print_result
;
; next print out result message as series of steps
;

        popa
        mov     eax, 0            ; return back to C
        leave                     
        ret

; Parameters:
;       ebx - address of dword to store integer into
get_int:
        call read_int
        mov [ebx], eax
        ret

; Parameters
;       eax - address of string
print_line:
        call    print_string
        call    print_nl
        ret


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
        ret

print_debug:
        dump_regs 1               ; dump out register values
        dump_mem 2, outmsg1, 1    ; dump out memory
        ret