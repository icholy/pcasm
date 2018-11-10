

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
        mov     ebp,esp
        sub     esp, SIZEOF_DOUBLE      ; define one double on stack

    

        pop     esi                     ; restore esi
        mov     eax, 0

        mov     esp, ebp
        pop     ebp
        ret 

