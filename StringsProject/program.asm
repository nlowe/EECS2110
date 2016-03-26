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
input_buffer    DB  50 '$'
; ------------------------------------------------------------------------------

; ===========================   End of Data Segment  ===========================

.code

start:
main            PROC
    _LdSeg  ds, @data               ; Load the data segment
    _PutStr newStringPrompt
    _PutStr blank
PROMPT:
    

CONTINUE_PROMPT:
    _PutStr      continuePrompt              ; Prompt the user to continue or exit
    _GetCh
    sPutStr      blank

    
    _CharToLower al                          ; Convert the read character to lower case
    cmp          al, 'y'
    je           PROMPT                      ; The user entered 'y', prompt for another PW
    cmp          al, 'n'
    je           EXIT                        ; The user entered 'n', exit
    _PutStr      continueInvalidPrompt       ; /snark
    jmp          CONTINUE_PROMPT             ; ask again...
EXIT:
    _Exit   RET_OK
main            ENDP
    END     main
