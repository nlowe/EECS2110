.XLIST

LOWERCASE_START EQU 'a'
LOWERCASE_END   EQU 'z'
ASCII_TO_UPPER_MASK EQU 11011111b   ; The bitmask to convert a character to upper

;; functions.inc
;; String Operation Functions for the Strings project
;;
;; EECS 2110 - Computer Architecture and Organization
;; Spring 2016 at the University of Toledo

_PickRadix MACRO   mem, exit_jmp_loc, err_jmp_loc
    LOCAL   _PICK_RADIX_NOT_HEX, _PICK_RADIX_DONE
    _GetCh
    _CharToUpper al
    cmp          al, 'X'
    je           exit_jmp_loc
    cmp          al, 'H'
    jne          _PICK_RADIX_NOT_HEX
    mov          mem, 16
    jmp          _PICK_RADIX_DONE
_PICK_RADIX_NOT_HEX:
    cmp          al, '1'
    jnge         err_jmp_loc
    cmp          al, '9'
    jnle         err_jmp_loc
    sub          al, '0'
    mov          mem, al
    _GetCh
    cmp          al, CR
    je           _PICK_RADIX_DONE
    cmp          al, '0'
    jnge         err_jmp_loc
    cmp          al, '9'
    jnle         err_jmp_loc
    sub          al, '0'
    mov          bl, al
    mov          al, mem
    mov          cl, 10
    mul          cl
    add          al, bl
    mov          mem, al
_PICK_RADIX_DONE:
    cmp          mem, 35
    jg           err_jmp_loc
    cmp          mem, 2
    jl           err_jmp_loc
    nop
ENDM

; Find the index of the first occurrence of c in the string s of length len
; result in dx, -1 if not found
_IndexOf    MACRO   s, c, len
    LOCAL   _INDEX_OF_LOOP0, _INDEX_OF_LOOP0_DONE, _INDEX_OF_LOOP0_DONE_NOT_FOUND
    cmp     len, 0                  ; Check to see if we were passed a 0 length string
    je      _INDEX_OF_LOOP0_DONE_NOT_FOUND

    mov     bx, -1
_INDEX_OF_LOOP0:
    inc     bx

    cmp     bl, len
    je      _INDEX_OF_LOOP0_DONE_NOT_FOUND
    cmp     s[bx], c
    jne     _INDEX_OF_LOOP0

    mov     dx, bx
    jmp     _INDEX_OF_LOOP0_DONE
_INDEX_OF_LOOP0_DONE_NOT_FOUND:
    mov     dx, -1
_INDEX_OF_LOOP0_DONE:
    nop
ENDM

; We're lazy. Print num in the specified radix using the symbol table
_PutRadix MACRO num, radix, symbols
    LOCAL _PUT_RADIX_LOOP0, _PUT_RADIX_LOOP1, _PUT_RADIX_LOOP1_DONE
    mov    al, radix
    cbw
    mov    cx, num
    xchg   ax, cx
    push   '$'
    cmp    ax, 0
    jge    _PUT_RADIX_LOOP0
    sPutCh '-'
    cwd
    xor    ax, dx
    sub    ax, dx
_PUT_RADIX_LOOP0:
    ; radix is in bx
    ; leftover is in ax
    ; divide ax by dx. Leftover in ax, remainder (symbol offset) in dx
    xor    dx, dx
    idiv   cx
    mov    bx, dx
    mov    dl, symbols[bx]
    push   dx
    cmp    ax, 0
    jne    _PUT_RADIX_LOOP0
_PUT_RADIX_LOOP1:
    pop    ax
    cmp    al, '$'
    je     _PUT_RADIX_LOOP1_DONE
    _PutCh al
    jmp    _PUT_RADIX_LOOP1
_PUT_RADIX_LOOP1_DONE:
    nop
ENDM

; GetDec from Util.lib does not indicate invalid input
; This function returns a positive number from stdin or -1 if no number was entered
_SafeGetDec MACRO
    LOCAL   _SAFE_GETDEC_LOOP0, _SAFE_GETDEC_LOOP0_DONE, _SAFE_GETDEC_BLANK
    LOCAL   _SAFE_GETDEC_RET
    _SvRegs <cx, bx>
    xor     bx, bx
    xor     cx, cx
_SAFE_GETDEC_LOOP0:
    _GetCh
    cmp     al, NUMERIC_START
    JNAE    _SAFE_GETDEC_LOOP0_DONE
    cmp     al, NUMERIC_END
    JNBE    _SAFE_GETDEC_LOOP0_DONE
    or      cx, -1                      ; Remember if we saw at least one digit
    sub     al, 30h                     ; De-ASCII-tize
    cbw
    add     bx, ax                      ; Add it to the running total
    mov     ax, bx                      ; And shift left by one power of 10
    mov     bx, 10
    mul     bx
    mov     bx, ax
    jmp     _SAFE_GETDEC_LOOP0
_SAFE_GETDEC_LOOP0_DONE:
    jcxz    _SAFE_GETDEC_BLANK          ; If we didn't see any digits, return -1
    mov     ax, bx                      ; Shift back right by one power of 10
    mov     bx, 10
    div     bx
    cbw
    jmp     _SAFE_GETDEC_RET
_SAFE_GETDEC_BLANK:
    mov     ax, -1
_SAFE_GETDEC_RET:
    _RsRegs <bx, cx>
ENDM

_CharToUpper    MACRO   reg
    LOCAL _CHAR_TO_UPPER_DONE
    cmp   reg, LOWERCASE_START
    jnge  _CHAR_TO_UPPER_DONE
    cmp   reg, LOWERCASE_END
    jnle  _CHAR_TO_UPPER_DONE
    and   reg, ASCII_TO_UPPER_MASK
_CHAR_TO_UPPER_DONE:
    nop
ENDM

.LIST
