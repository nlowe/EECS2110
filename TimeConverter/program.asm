; Nathan Lowe
; EECS 2110 - Computer Architecture and Organization
; Spring 2016 at the University of Toledo
;
; Description: Given some time in hours, minutes, and seconds, print:
;              * The total number of seconds
;              * The total number of minutes and seconds
;              * The total number of hours, minutes, and seconds

; ==============================================================================
; | Include libraries and macros                                               |
; ==============================================================================
include ..\lib\pcmac.inc

; ==============================================================================
; | Constants used in this file                                                |
; ==============================================================================
TAB                 EQU 09          ; Horizontal Tab
CR                  EQU 13          ; Carriage Return
LF                  EQU 10          ; Line Feed
EOS                 EQU '$'         ; DOS End of string terminator

ASCII_TO_LOWER_MASK EQU 00100000b   ; The bitmask to convert a character to lower
NUMERIC_START       EQU '0'
NUMERIC_END         EQU '9'

RET_OK              EQU 00h         ; Return code for OK

; ===========================     Start of Setup    ============================
.model small        ; Small Memory MODEL
.586                ; Pentium Instruction Set
.stack 100h         ; Stack area - 256 bytes
; ===========================      End of Setup      ===========================

; ===========================  Start of Data Segment ===========================
.data
; ---------------------------    Input Prompt Strings    ---------------------------
promptTime       DB  'Enter a time:', CR, LF, EOS
inputHoursPrompt        DB  'Hours> ', EOS
inputMinutesPrompt      DB  'Minutes> ', EOS
inputSecondsPrompt      DB  'Seconds> ', EOS
continuePrompt          DB  'Do you want to repeat (y/n)? ', EOS
; ----------------------------------------------------------------------------------

; ---------------------------       Output Message       ---------------------------
outTime          DB  'The provided time is', CR, LF, EOS
outHours         DB  ' Hours, ', EOS
outMinutes       DB  ' Minutes, and ', EOS
outSeconds       DB  ' Seconds', EOS
outOr            DB  ', Or', CR, LF, EOS
blank            DB  CR, LF, EOS
; ----------------------------------------------------------------------------------

; ---------------------------       Error Messages        ---------------------------
continueInvalidPrompt   DB 'Project specification dictates you enter either one of (Y,y,N,n), so I will ask again. ', EOS
errInvalidValue         DB 'Not a number or no number provided!', CR, LF, EOS
errTooLarge             DB 'One of the values entered is too large!', CR, LF, EOS
; ----------------------------------------------------------------------------------

; ---------------------------       Variables        ---------------------------
totalSeconds         DW 0
remainderSeconds     DW 0
remainderMinutes     DW 0
; ------------------------------------------------------------------------------

; ===========================   End of Data Segment  ===========================

; GetDec from Util.lib does not indicate invalid input
; This function returns a positive number from stdin or -1 in ax if no number was entered
_SafeGetDec MACRO
    LOCAL       _SAFE_GETDEC_LOOP0, _SAFE_GETDEC_LOOP0_DONE, _SAFE_GETDEC_BLANK
    LOCAL       _SAFE_GETDEC_RET
    _SvRegs     <cx, bx, dx>
    xor         bx, bx
    xor         cx, cx
_SAFE_GETDEC_LOOP0:
    _GetCh
    cmp         al, NUMERIC_START
    JNAE        _SAFE_GETDEC_LOOP0_DONE
    cmp         al, NUMERIC_END
    JNBE        _SAFE_GETDEC_LOOP0_DONE
    or          cx, -1                      ; Remember if we saw at least one digit
    sub         al, 30h                     ; De-ASCII-tize
    cbw
    add         bx, ax                      ; Add it to the running total
    mov         ax, bx                      ; And shift left by one power of 10
    mov         bx, 10
    xor         dx, dx
    mul         bx
    mov         bx, ax
    jmp         _SAFE_GETDEC_LOOP0
_SAFE_GETDEC_LOOP0_DONE:
    jcxz        _SAFE_GETDEC_BLANK          ; If we didn't see any digits, return -1
    mov         ax, bx                      ; Shift back right by one power of 10
    mov         bx, 10
    xor         dx, dx
    div         bx
    jmp         _SAFE_GETDEC_RET
_SAFE_GETDEC_BLANK:
    mov         ax, -1
_SAFE_GETDEC_RET:
    _RsRegs     <dx, bx, cx>
ENDM

.code
EXTRN GetDec:NEAR
EXTRN PutDec:NEAR

start:
main            PROC
    _LdSeg  ds, @data               ; Load the data segment

PROMPT:
    _PutStr     promptTime

    _PutStr     inputHoursPrompt
    _SafeGetDec
    cmp         ax, 0
    jl          INVALID_VALUE
    mov         bx, 3600
    mul         bx
    cmp         dx, 0
    jne         VALUE_TOO_LARGE
    mov         totalSeconds, ax

    _PutStr     inputMinutesPrompt
    _SafeGetDec
    cmp         ax, 0
    jl          INVALID_VALUE
    mov         bx, 60
    mul         bx
    cmp         dx, 0
    jne         VALUE_TOO_LARGE
    add         totalSeconds, ax
    cmp         totalSeconds, 0
    jl          VALUE_TOO_LARGE

    _PutStr     inputSecondsPrompt
    _SafeGetDec
    cmp         ax, 0
    jl          INVALID_VALUE
    add         totalSeconds, ax
    cmp         totalSeconds, 0
    jl          VALUE_TOO_LARGE
    _PutStr     blank

    ; Total Seconds
    _PutStr     outTime
    mov         ax, totalSeconds
    call        PutDec
    _PutStr     outSeconds
    _PutStr     outOr

    ; Total Minutes and Seconds
    xor         dx, dx
    mov         ax, totalSeconds
    mov         bx, 60
    div         bx
    mov         remainderSeconds, dx
    mov         remainderMinutes, ax
    call        PutDec
    _PutStr     outMinutes
    mov         ax, remainderSeconds
    call        PutDec
    _PutStr     outSeconds
    _PutStr     outOr

    ; Total Minutes and Seconds
    xor         dx, dx
    mov         ax, remainderMinutes
    mov         bx, 60
    div         bx
    push        dx
    call        PutDec
    _PutStr     outHours
    pop         ax
    call        PutDec
    _PutStr     outMinutes
    mov         ax, remainderSeconds
    call        PutDec
    _PutStr     outSeconds
    _PutStr     blank
    _PutStr     blank

    ; Continue?
CONTINUE_PROMPT:
    _PutStr     continuePrompt
    _GetCh
    sPutStr     blank

    mov         totalSeconds, 0

    or          al, ASCII_TO_LOWER_MASK     ; Convert the read character to lower case
    cmp         al, 'y'
    je          PROMPT                      ; The user entered 'y', prompt for another PW
    cmp         al, 'n'
    je          EXIT                        ; The user entered 'n', exit
    _PutStr     continueInvalidPrompt       ; /snark
    jmp         CONTINUE_PROMPT             ; ask again...

INVALID_VALUE:
    _PutStr     errInvalidValue
    jmp         PROMPT

VALUE_TOO_LARGE:
    _PutStr     errTooLarge
    jmp         PROMPT

EXIT:
    _Exit       RET_OK
main            ENDP
    END         main
