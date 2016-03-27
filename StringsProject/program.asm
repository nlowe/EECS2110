; Nathan Lowe
; EECS 2110 - Computer Architecture and Organization
; Spring 2016 at the University of Toledo
;
; Description: Given an input string, perform one of the following operations:
;   1:   Find the index of the first occurrence of a user-input character in the string
;   2:   Find the number of occurrences of a certain letter in a string
;   3:   Find the length of the input string.
;   4:   Find the number of alphanumeric characters of the input string.
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
input_buffer    DB  50 DUP('$')
padding         DB  '$'
; ------------------------------------------------------------------------------

; ===========================   End of Data Segment  ===========================

.code

EXTRN GetDec:NEAR


start:
main            PROC
    _LdSeg  ds, @data               ; Load the data segment
    
PROMPT:
    _PutStr newStringPrompt
    
    xor     bx, bx                  ; Clear bx
PROMPT_CONTINUE:
    _GetCh  noecho
    cmp     al, CR
    je      MENU
    cmp     al, LF
    je      MENU
    
    cmp     al, 1Fh
    jle     PROMPT_CONTINUE
    cmp     al, 7Fh
    jge     PROMPT_CONTINUE
    
    mov     input_buffer[bx], al    ; Store the character in the buffer
    inc     bx
    
    mov     dl, al                  ; Echo it out to the screen
    _PutCh
    
    cmp     bx, MAX_LENGTH
    je      MENU
    jmp     PROMPT_CONTINUE

MENU:
    _PutStr blank
    _PutStr functionMenu

MENU_PROMPT:
    _PutStr currentString
    _PutStr input_buffer
    _PutStr blank
    _PutStr functionPrompt
    call    GetDec
    
    cmp     ax, 1
    jne     CHECK_F2
    ; TODO: Call Function 1
    _PutStr notImplemented
    jmp     MENU_PROMPT
    
CHECK_F2:
    cmp     ax, 2
    jne     CHECK_F3
    ;TODO:  Call Function 2
    _PutStr notImplemented
    jmp     MENU_PROMPT
    
CHECK_F3:
    cmp     ax, 3
    jne     CHECK_F4
    ;TODO:  Call Function 3
    _PutStr notImplemented
    jmp     MENU_PROMPT
    
CHECK_F4:
    cmp     ax, 4
    jne     CHECK_F5
    ;TODO:  Call Function 4
    _PutStr notImplemented
    jmp     MENU_PROMPT
    
CHECK_F5:
    cmp     ax, 5
    jne     CHECK_F6
    ;TODO:  Call Function 5
    _PutStr notImplemented
    jmp     MENU_PROMPT
    
CHECK_F6:
    cmp     ax, 6
    jne     CHECK_F7
    ;TODO:  Call Function 6
    _PutStr notImplemented
    jmp     MENU_PROMPT
    
CHECK_F7:
    cmp     ax, 7
    jne     CHECK_F8
    ;TODO:  Call Function 7
    _PutStr notImplemented
    jmp     MENU_PROMPT
    
CHECK_F8:
    cmp     ax, 8
    jne     CHECK_F9
    ;TODO:  Call Function 8
    _PutStr notImplemented
    jmp     MENU_PROMPT
    
CHECK_F9:
    cmp     ax, 9
    jne     CHECK_F10
    ; TODO: Don't forget to either clear out the end string or append a '$'
    jmp     PROMPT              ; Function 9: Prompt for a new string
    
CHECK_F10:
    cmp     ax, 10
    jne     CHECK_F0
    ;TODO:  Call Function 100
    _PutStr notImplemented
    jmp     MENU_PROMPT
    
CHECK_F0:
    cmp     ax, 0
    jne     MENU            ; This will also catch F100 (print the menu)

    ; Function 0 is just to exit
EXIT:
    _Exit   RET_OK
main            ENDP
    END     main
