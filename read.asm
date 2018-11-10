

;
; file: read.asm
; This subroutine reads an array of doubles from a file

segment .data
        format  db      "%lf", 0        ; format for fscanf()

segment .bss

 

segment .text
        global  _read_doubles
        extern  _fscanf

%define SIZEOF_DOUBLE   8
%define FP              dword [ebp + 8]
%define ARRAYP          dword [ebp + 12]
%define ARRAY_SIZE      dword [ebp + 16]
%define TEMP_DOUBLE     [ebp - 8]
%define TEMP_DOUBLE_H   [ebp - 4]

;
; function _read_doubles
; C prototype:
;   int read_doubles( FILE * fp, double * arrayp, int array_size );
; This function reads doubles from a text file into an array, until
; EOF or array is full.
; Parameters:
;   fp         - FILE pointer to read from (must be open for input)
;   arrayp     - pointer to double array to read into
;   array_size - number of elements in array
; Return value:
;   number of doubles stored into array (in EAX)

_read_doubles:
        push    ebp
        mov     ebp, esp
        sub     esp, SIZEOF_DOUBLE      ; define one double on stack

        push    esi                     ; save esi
        mov     esi, ARRAYP
        xor     edx, edx                ; zero edx (array index)
        
while_loop:

        ; quit if the array is full
        cmp     edx, ARRAY_SIZE
        jnl     short quit

        ; use scanf to read a float from the FILE
        push    edx                ; save
        lea     eax, TEMP_DOUBLE
        push    eax
        push    dword format
        push    FP
        call    _fscanf
        add     esp, 12
        pop     edx                ; restore edx

        ; make sure fscanf returned 1
        cmp     eax, 1
        jne     short quit

        ; add the value into the array
        mov     eax, TEMP_DOUBLE                     ; copy the low bytes
        mov     [esi + SIZEOF_DOUBLE*edx], eax
        mov     eax, TEMP_DOUBLE_H                   ; copy the high bytes
        mov     [esi + SIZEOF_DOUBLE*edx + 4], eax
        inc     edx

        jmp     while_loop
quit:

        pop     esi                     ; restore esi
        mov     eax, edx                ; return number of values read

        mov     esp, ebp                ; restore frame pointer
        pop     ebp
        ret 

