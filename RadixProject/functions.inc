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
    cmp          mem, MAX_RADIX
    jg           err_jmp_loc
    cmp          mem, MIN_RADIX
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

_GetRadix MACRO outnum, radix, symbols, symbolLen, err_jmp_loc
    LOCAL        _GET_RADIX_LOOP0, _GET_RADIX_LOOP0_DONE
    LOCAL        _GET_RADIX_END, _GET_RADIX_HANDLE_NEG, _GET_RADIX_APPLY_SIGN
    xor          cx, cx                 ; The running total is kept in cx
    push         cx
_GET_RADIX_LOOP0:
    _GetCh
    cmp          al, CR
    je           _GET_RADIX_LOOP0_DONE
    cmp          al, '-'
    je           _GET_RADIX_HANDLE_NEG
    _CharToUpper al
    _IndexOf     symbols, al, symbolLen                ; Index in dx
    cmp          dx, -1
    je           err_jmp_loc
    cmp          dl, radix
    jge          err_jmp_loc
    pop          bx
    or           bx, 2
    push         bx
    push         dx
    mov          al, radix
    cbw
    xchg         ax, cx
    xor          dx, dx
    imul         cx
    pop          dx
    add          ax, dx
    mov          cx, ax
    jmp          _GET_RADIX_LOOP0
_GET_RADIX_LOOP0_DONE:
    xor          dx, dx
    pop          ax                 ; Pop the status flags into ax
    cmp          ax, 2              ; Ensure we got at least one valid character
    jnge         err_jmp_loc
    mov          ax, 0
    je           _GET_RADIX_APPLY_SIGN
    mov          ax, -1
_GET_RADIX_APPLY_SIGN:
    imul         cx
    mov          cx, ax
    mov          outnum, cx
    jmp          _GET_RADIX_END
_GET_RADIX_HANDLE_NEG:
    cmp          cx, 0              ; The negative symbol must be the first
    jne          err_jmp_loc        ; symbol to appear. If cx isn't zero, treat
    pop          cx                 ; it as a bad symbol. Read the flags from
    or           cx, 1              ; the stack and set the sign flag
    push         cx
    xor          cx, cx
    jmp          _GET_RADIX_LOOP0
_GET_RADIX_END:
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

; Compute a to the power x and store the result in res. X must be positive
_Pow MACRO a, x, res
    LOCAL _POW_LOOP0, _POW_LOOP0_DONE, _POW_X_0
    mov   cx, x
    jcxz  _POW_X_0
    mov   bx, a
    mov   res, bx
_POW_LOOP0:
    dec   cx
    jcxz  _POW_LOOP0_DONE
    xor   dx, dx
    mov   ax, res
    imul  bx
    mov   res, ax
    jmp   _POW_LOOP0
_POW_X_0:
    mov   res, 1
_POW_LOOP0_DONE:
    nop
ENDM

; convert the character in the specified register to uppercase if it is a letter
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
