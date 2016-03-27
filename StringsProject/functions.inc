.XLIST

;; functions.inc
;; String Operation Functions for the Strings project
;;
;; EECS 2110 - Computer Architecture and Organization
;; Spring 2016 at the University of Toledo

; Find the index of the first occurrence of c in the string s, result in dx, -1 if not found
_IndexOf    MACRO   s, c
    mov     dx, -2
    mov     bx, 0
_INDEX_OF_LOOP0:
    cmp     s[bx], '$'
    je      _INDEX_OF_LOOP0_DONE

    inc     dx
    cmp     s[bx], c
    je      _INDEX_OF_LOOP0_DONE
    inc     bx
    jmp     _INDEX_OF_LOOP0
_INDEX_OF_LOOP0_DONE:
    inc     dx
ENDM

; Find the number of occurrences of a character c in s, result in dx
_Count      MACRO   s, c
    xor     dx, dx
    mov     bx, -1
_COUNT_LOOP0:
    inc     bx
    cmp     s[bx], '$'
    je      _COUNT_LOOP0_DONE
    cmp     s[bx], c
    jne     _COUNT_LOOP0
    inc     dx
    jmp     _COUNT_LOOP0
_COUNT_LOOP0_DONE:
    nop
ENDM

; Find the length of the input string, result in dx
_StrLen     MACRO   s
    xor     bx, bx
_STRLEN_LOOP0:
    ; TODO: Is it legal for the user to include '$' in their string?
    cmp     s[bx], '$'
    je      _STRLEN_LOOP0_DONE
    inc     bx
    jmp     _STRLEN_LOOP0
_STRLEN_LOOP0_DONE:
    mov     dx, bx
ENDM

_StrAlphaLen    MACRO   s
    ; TODO: Implement. Need clarification on this and _StrLen
    _PutStr notImplemented
ENDM

; Replace all occurrences of c1 with c2 in s
_StrRepalce MACRO   s, c1, c2
    mov     bx, -1
_STR_REPLACE_LOOP0:
    inc     bx
    cmp     s[bx], '$'
    je      _STR_REPLACE_LOOP0_DONE
    cmp     s[bx], c1
    jne     _STR_REPLACE_LOOP0
    mov     s[bx], c2
    jmp     _STR_REPLACE_LOOP0
_STR_REPLACE_LOOP0_DONE:
    nop
ENDM

; Convert all letters in the string s to upper case
_StrToUpper MACRO   s
    xor     bx, bx
_STR_TO_UPPER_LOOP0:
    ; TODO: Is it legal for the user to include '$' in their string?
    cmp          s[bx], '$'
    je           _STR_TO_UPPER_LOOP0_DONE
    inc          bx
    _CharToUpper s[bx]
    jmp          _STR_TO_UPPER_LOOP0
_STR_TO_UPPER_LOOP0_DONE:
    nop
ENDM

; Convert all letters in the string s to lower case
_StrToLower MACRO   s
    xor     bx, bx
_STR_TO_LOWER_LOOP0:
    ; TODO: Is it legal for the user to include '$' in their string?
    cmp          s[bx], '$'
    je           _STR_TO_LOWER_LOOP0_DONE
    inc          bx
    _CharToLower s[bx]
    jmp          _STR_TO_LOWER_LOOP0
_STR_TO_LOWER_LOOP0_DONE:
    nop
ENDM

_StrToggle  MACRO   s
    xor     bx, bx
_STR_TOGGLE_LOOP0:
    ; TODO: Is it legal for the user to include '$' in their string?
    cmp             s[bx], '$'
    je              _STR_TOGGLE_LOOP0_DONE
    inc             bx
    _CharToggleCase s[bx]
    jmp             _STR_TOGGLE_LOOP0
_STR_TOGGLE_LOOP0_DONE:
    nop
ENDM

.LIST
