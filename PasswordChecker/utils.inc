.XLIST

;; utils.inc
;; Utility functions for the PasswordChecker project
;;
;; EECS 2110 - Computer Architecture and Organization
;; Spring 2016 at the University of Toledo

; Checks to see if the character in <al> is between <lower> and <upper> inclusive
; If it is, increment <counter> and jump to <ok>
; If not, and it is below <lower>, jump to <nextLower>
; If not, and it is above <upper>, jump to <nextUpper>
_CheckChar MACRO lower, upper, counter, nextLower, nextUpper, ok
    CMP  al, lower
    JNAE nextLower
    CMP  al, upper
    JNBE nextUpper
    INC  counter
    JMP  ok
ENDM

; Checks to see if <counter> is greater than zero, and if so, jump to <nextOk>
; If not, print <msg> and increment <validationCounter>
_AssertOne MACRO counter, nextOk, msg, validationCounter
    cmp     counter, 0
    jne     nextOk
    _PutStr msg
    inc     validationCounter
ENDM

.LIST