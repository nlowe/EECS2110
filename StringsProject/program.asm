; Nathan Lowe
; EECS 2110 - Computer Architecture and Organization
; Spring 2016 at the University of Toledo
;
; Description: Given an input string, perform one of the following operations:
;   1:   Find the index of the first occurrence of a user-input character in the string
;   2:   Find the number of occurrences of a certain letter in a string
;   3:   Find the length of the input string.
;   4:   Find the number of alphanumeric characters of the input string, incl. space
;   5:   Write a routine that replaces every occurrence of a certain letter with another symbol
;   6:   Capitalize the letters in the string
;   7:   Make each letter lower case
;   8:   Toggle the case of each letter
;   9:   input a new string
;   10:  undo the last action that modified the string
;   100: output the menu
;   0:   exit the program

; ==============================================================================
; | Include libraries and macros                                               |
; ==============================================================================
include ..\lib\pcmac.inc
include .\utils.inc
include .\functions.inc

; ==============================================================================
; | Constants used in this file                                                |
; ==============================================================================
TAB                 EQU 09          ; Horizontal Tab
CR                  EQU 13          ; Carriage Return
LF                  EQU 10          ; Line Feed
EOS                 EQU '$'         ; DOS End of string terminator

MAX_LENGTH          EQU 50          ; The maximum length of the input string

RET_OK              EQU 00h         ; Return code for OK

; ===========================     Start of Setup    ============================
.model small        ; Small Memory MODEL
.586                ; Pentium Instruction Set
.stack 100h         ; Stack area - 256 bytes
; ===========================      End of Setup      ===========================

; ===========================  Start of Data Segment ===========================
.data
; Include message definitions. This needs to be done in the data segment
include .\strings.inc

; ---------------------------       Variables        ---------------------------
; input_buffer    STRBUF <>
input_buffer    DB  80
input_length    DB  ?
input_string    DB  50 DUP('$')
padding         DB  '$'
; ------------------------------------------------------------------------------

; ===========================   End of Data Segment  ===========================

.code

EXTRN GetDec:NEAR
EXTRN PutDec:NEAR


start:
main            PROC
    _LdSeg  ds, @data               ; Load the data segment

PROMPT:
    _PutStr newStringPrompt
    _GetStr input_buffer

MENU:
    _PutStr blank
    _PutStr functionMenu

MENU_PROMPT:
    _PutStr currentString
    _PutStr input_string
    _PutStr blank
    _PutStr functionPrompt
    call    GetDec

; 1:   Find the index of the first occurrence of a user-input character in the string
CHECK_F1:
    cmp      ax, 1
    jne      CHECK_F2

    _PutStr  charFindPrompt
    _GetCh
    sPutStr  blank
    _IndexOf input_string, al, input_length  ; The index is now in dx
    cmp      dx, 0
    jl       F1_NOT_FOUND
    sPutStr  f1_1
    sPutCh   al
    sPutStr  f1_2
    mov      ax, dx
    call     PutDec
    _PutStr  blank
    jmp      MENU_PROMPT
F1_NOT_FOUND:
    _PutStr  f1_notFound
    jmp      MENU_PROMPT

; 2:   Find the number of occurrences of a certain letter in a string
CHECK_F2:
    cmp      ax, 2
    jne      CHECK_F3

    _PutStr  charFindPrompt
    _GetCh

    sPutStr  blank
    _Count   input_string, al
    sPutStr  f2_1
    sPutCh   al
    sPutStr  f2_2
    mov      ax, dx
    call     PutDec
    _PutStr  f2_3
    jmp      MENU_PROMPT

; 3:   Find the length of the input string
CHECK_F3:
    cmp     ax, 3
    jne     CHECK_F4

    _PutStr f3_1
    xor     dh, dh
    mov     dl, input_length
    call    PutDec
    _PutStr f3_2
    jmp     MENU_PROMPT

; 4:   Find the number of alphanumeric characters of the input string, incl. space
CHECK_F4:
    cmp          ax, 4
    jne          CHECK_F5

    _PutStr      f4_1
    _StrAlphaLen input_string
    call         PutDec
    _PutStr      f4_2
    jmp          MENU_PROMPT


; 5:   Write a routine that replaces every occurrence of a certain letter with another symbol
CHECK_F5:
    cmp         ax, 5
    jne         CHECK_F6

    _PutStr     charFindPrompt
    _GetCh
    sPutStr     blank
    mov         dl, al
    _PutStr     charReplacePrompt
    _StrRepalce input_string, dl, al

    sPutStr     f5_1
    sPutCh      dl
    sPutStr     f5_2
    sPutCh      al
    _PutStr     f5_3

    jmp         MENU_PROMPT

; 6:   Capitalize the letters in the string
CHECK_F6:
    cmp         ax, 6
    jne         CHECK_F7

    _StrToUpper input_string
    _PutStr     f6_1
    jmp         MENU_PROMPT

; 7:   Make each letter lower case
CHECK_F7:
    cmp         ax, 7
    jne         CHECK_F8

    _StrToLower input_string
    _PutStr     f7_1
    jmp         MENU_PROMPT

; 8:   Toggle the case of each letter
CHECK_F8:
    cmp        ax, 8
    jne        CHECK_F9

    _StrToggle input_string
    _PutStr    f8_1
    jmp        MENU_PROMPT

; 9:   input a new string
CHECK_F9:
    cmp     ax, 9
    jne     CHECK_F10

    ; TODO: Don't forget to either clear out the end string or append a '$'
    jmp     PROMPT              ; Function 9: Prompt for a new string

; 10:  undo the last action that modified the string
CHECK_F10:
    cmp     ax, 10
    jne     CHECK_F0

    ;TODO:  Call Function 10
    _PutStr notImplemented
    jmp     MENU_PROMPT

; 0:   exit the program
CHECK_F0:
    cmp     ax, 0
    jne     MENU            ; This will also catch F100 (print the menu)

    ; Function 0 is just to exit
EXIT:
    _Exit   RET_OK
main            ENDP
    END     main
