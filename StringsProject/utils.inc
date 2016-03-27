.XLIST

;; utils.inc
;; Utility macros for the strings project
;;
;; EECS 2110 - Computer Architecture and Organization
;; Spring 2016 at the University of Toledo

ASCII_TO_UPPER_MASK EQU 11011111b   ; The bitmask to convert a character to upper
ASCII_TO_LOWER_MASK EQU 00100000b   ; The bitmask to convert a character to lower

_CharToLower    MACRO   reg
    OR  reg, ASCII_TO_LOWER_MASK
ENDM

_CharToUpper    MACRO   reg
    AND reg, ASCII_TO_UPPER_MASK
ENDM

_CharToggleCase MACRO   reg
    XOR reg, ASCII_TO_LOWER_MASK
ENDM

.LIST
