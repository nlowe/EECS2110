.XLIST

UPPERCASE_START EQU 'A'
UPPERCASE_END   EQU 'Z'
LOWERCASE_START EQU 'a'
LOWERCASE_END   EQU 'z'
NUMERIC_START   EQU '0'
NUMERIC_END     EQU '9'
ASCII_TO_UPPER_MASK EQU 11011111b   ; The bitmask to convert a character to upper
ASCII_TO_LOWER_MASK EQU 00100000b   ; The bitmask to convert a character to lower

;; functions.inc
;; String Operation Functions for the Strings project
;;
;; EECS 2110 - Computer Architecture and Organization
;; Spring 2016 at the University of Toledo

; Find the index of the first occurrence of c in the string s of length len
; result in dx, -1 if not found
_IndexOf    MACRO   s, c, len
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

; Find the number of occurrences of a character c in s of length len
; result in dx, 0 if not found
_Count      MACRO   s, c, len
    xor     dx, dx
    mov     bx, -1
_COUNT_LOOP0:
    inc     bx
    cmp     bl, len
    je      _COUNT_LOOP0_DONE
    cmp     s[bx], c
    jne     _COUNT_LOOP0
    inc     dx
    jmp     _COUNT_LOOP0
_COUNT_LOOP0_DONE:
    nop
ENDM

; Calculate the number of alphanumeric characters in the string s of length len
; Result in ax
_StrAlphaLen    MACRO   s, len
    xor              ax, ax
    mov              bx, -1
_STR_ALPHALEN_LOOP0:
    inc              bx
    cmp              bl, len
    je               _STR_ALPHALEN_LOOP0_DONE

    _NotAlphaNumChar s[bx], _STR_ALPHALEN_LOOP0
    inc              ax
    jmp              _STR_ALPHALEN_LOOP0
_STR_ALPHALEN_LOOP0_DONE:
    nop
ENDM

; Replace all occurrences in s (of length len) of c1 with c2
_StrRepalce MACRO   s, len, c1, c2
    mov     bx, -1
_STR_REPLACE_LOOP0:
    inc     bx
    cmp     bl, len
    je      _STR_REPLACE_LOOP0_DONE
    cmp     s[bx], c1
    jne     _STR_REPLACE_LOOP0
    mov     s[bx], c2
    jmp     _STR_REPLACE_LOOP0
_STR_REPLACE_LOOP0_DONE:
    nop
ENDM

; Convert all letters in the string s of length len to upper case
_StrToUpper MACRO   s, len
    mov         bx, -1
_STR_TO_UPPER_LOOP0:
    inc          bx
    ; TODO: Is it legal for the user to include '$' in their string?
    cmp          bl, len
    je           _STR_TO_UPPER_LOOP0_DONE
    _CharToUpper s[bx]
    jmp          _STR_TO_UPPER_LOOP0
_STR_TO_UPPER_LOOP0_DONE:
    nop
ENDM

; Convert all letters in the string s of length len to lower case
_StrToLower MACRO   s, len
    mov         bx, -1
_STR_TO_LOWER_LOOP0:
    inc          bx
    cmp          bl, len
    je           _STR_TO_LOWER_LOOP0_DONE
    _CharToLower s[bx]
    jmp          _STR_TO_LOWER_LOOP0
_STR_TO_LOWER_LOOP0_DONE:
    nop
ENDM

; Toggle the case of all letters in the string s of length len
_StrToggle  MACRO   s, len
    mov         bx, -1
_STR_TOGGLE_LOOP0:
    inc             bx
    cmp             bl, len
    je              _STR_TOGGLE_LOOP0_DONE
    _CharToggleCase s[bx]
    jmp             _STR_TOGGLE_LOOP0
_STR_TOGGLE_LOOP0_DONE:
    nop
ENDM

; Jump to lblTrue if the specified character is not an alphanumeric character or space
_NotAlphaNumChar MACRO c, lblTrue
    LOCAL _NOT_ALPHANUM_END
    cmp  c, ' '
    je   _NOT_ALPHANUM_END
    cmp  c, NUMERIC_START
    JNAE lblTrue
    cmp  c, NUMERIC_END
    JBE  _NOT_ALPHANUM_END
    cmp  c, UPPERCASE_START
    JNAE lblTrue
    cmp  c, UPPERCASE_END
    JBE  _NOT_ALPHANUM_END
    cmp  c, LOWERCASE_START
    JNAE lblTrue
    cmp  c, LOWERCASE_END
    JNBE lblTrue
_NOT_ALPHANUM_END:
    nop
ENDM

; Print the specified string of length len to stdout, including the '$' character
_SafePutStr MACRO s, len
    mov    bx, -1
_SAFE_PUTSTR_LOOP0:
    inc    bx
    cmp    bl, len
    je     _SAFE_PUTSTR_LOOP0_DONE

    _PutCh s[bx]
    jmp    _SAFE_PUTSTR_LOOP0
_SAFE_PUTSTR_LOOP0_DONE:
    nop
ENDM

_CharToLower    MACRO   reg
    cmp  reg, 'A'
    jnge _CHAR_TO_LOWER_DONE
    cmp  reg, 'Z'
    jnle _CHAR_TO_LOWER_DONE
    or   reg, ASCII_TO_LOWER_MASK
_CHAR_TO_LOWER_DONE:
    nop
ENDM

_CharToUpper    MACRO   reg
    cmp  reg, 'a'
    jnge _CHAR_TO_UPPER_DONE
    cmp  reg, 'z'
    jnle _CHAR_TO_UPPER_DONE
    and  reg, ASCII_TO_UPPER_MASK
_CHAR_TO_UPPER_DONE:
    nop
ENDM

_CharToggleCase MACRO   reg
    _NotAlphaNumChar reg, _CHAR_TOGGLE_DONE
    xor              reg, ASCII_TO_LOWER_MASK
_CHAR_TOGGLE_DONE:
    nop
ENDM

.LIST
