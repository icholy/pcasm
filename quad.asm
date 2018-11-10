global _quadratic

;
; file: quad.asm

; function quadratic
; finds solutions to the quadratic equation: 
;       a*x^2 + b*x + c = 0
; C prototype:
;   int quadratic( double a, double b, double c,
;                  double * root1, double *root2 )
; Parameters:
;   a, b, c - coefficients of powers of quadratic equation (see above)
;   root1   - pointer to double to store first root in
;   root2   - pointer to double to store second root in
; Return value:
;   returns 1 if real roots found, else 0

%define a               qword [ebp+8]
%define b               qword [ebp+16]
%define c               qword [ebp+24]
%define root1           dword [ebp+32]
%define root2           dword [ebp+36]
%define disc            qword [ebp-8]
%define one_over_2a     qword [ebp-16]

segment .data
MinusFour       dw      -4

segment .text

_quadratic:
        push    ebp
        mov     ebp, esp
        sub     esp, 16         ; allocate 2 doubles (disc & one_over_2a)
        push    ebx             ; must save original ebx

        ; b^2 - 4ac
        fild    word [MinusFour] ; stack -4
        fld     a                ; stack: a, -4
        fld     c                ; stack: c, a, -4
        fmulp   st1              ; stack: a*c, -4
        fmulp   st1              ; stacl" -4*c*a
        fld     b                ; stack: b, -4*c*a
        fld     b                ; stack: b, b, -4*c*a
        fmulp   st1              ; stack: b*b, -4*c*a
        faddp   st1              ; stack b*b - 4*c*a
        
        ; there are no real answers if the current value is below 0
        ftst
        fstsw   ax
        sahf
        jb      no_real_solution

        ; sqrt(b^2 - 4ac)
        fsqrt                    ; stack: sqrt(b*b - 4ac)
        fstp    disc             ; store and pop

        ; 1 / 2a
        fld1                     ; stack: 1
        fld1                     ; stack: 1, 1
        fld1                     ; stack: 1, 1, 2
        faddp   st1              ; stack: 2, 1
        fld     a                ; stack: 2, a, 1
        fmulp   st1              ; stack: 2*a, 1
        fdivp   st1              ; stack: 1/2*a
        fstp    one_over_2a      ; store and pop

        ; root1
        fld    one_over_2a      ; stack = one_over_2a
        fld    disc             ; stack = disc, one_over_2a
        fld    b                ; stack = b, disc, one_over_2a
        faddp  st1              ; stack = b+disc, one_over_2a
        fdivp  st1              ; stack = b+disc / one_over_2a
        fstp   qword root1

        ; root2
        fld    one_over_2a      ; stack = one_over_2a
        fld    disc             ; stack = disc, one_over_2a
        fchs                    ; stack = -disc, one_over_2a
        fld    b                ; stack = b, disc, one_over_2a
        faddp  st1              ; stack = b-disc, one_over_2a
        fdivp  st1              ; stack = b-disc / one_over_2a
        fstp   qword root2

        mov     eax, 1

        jmp     short quit

no_real_solution:
        mov     eax, 0          ; return value is 0

quit:
        pop     ebx
        mov     esp, ebp
        pop     ebp
        ret

