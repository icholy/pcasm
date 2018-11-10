

;
; file: dmax.asm

global _dmax



segment .text
; function _dmax
; returns the larger of its two double arguments
; C prototype
; double dmax( double d1, double d2 )
; Parameters:
;   d1   - first double
;   d2   - second double
; Return value:
;   larger of d1 and d2 (in ST0)

; next, some helpful symbols are defined

%define d1   [ebp+8]
%define d2   [ebp+16]

_dmax:
        enter   0, 0
        fld     qword d2 ; stack: d2
        fld     qword d1 ; stack: d1, d2
        fcomip  st1      ; stack: d2
        jna     short done
        fcomp   st0      ; stack: 
        fld     dword d1 ; stack: d1
done:

        leave
        ret


