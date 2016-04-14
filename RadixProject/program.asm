; Nathan Lowe
; EECS 2110 - Computer Architecture and Organization
; Spring 2016 at the University of Toledo
;
; Description: Given an input radix, output radix, and two numbers in the
;               specified input radix, perform the following operations:
;              A+B
;              A-B
;              A*B
;              A/B
;              A^B

; ==============================================================================
; | Include libraries and macros                                               |
; ==============================================================================
include ..\lib\pcmac.inc
include .\functions.inc

; ==============================================================================
; | Constants used in this file                                                |
; ==============================================================================
TAB                 EQU 09          ; Horizontal Tab
CR                  EQU 13          ; Carriage Return
LF                  EQU 10          ; Line Feed
EOS                 EQU '$'         ; DOS End of string terminator

MIN_RADIX           EQU 2
MAX_RADIS           EQU 35

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
inputRadix           DB ?
outputRadix          DB ?
inputA               DW ?
inputB               DW ?
mathscratch          DW ?
; ------------------------------------------------------------------------------

; ===========================   End of Data Segment  ===========================

.code

EXTRN PutDec:NEAR

start:
main            PROC
    _LdSeg  ds, @data               ; Load the data segment

PROMPT:
    _PutStr inputRadixPrompt
    _PickRadix inputRadix, EXIT, INVALID_RADIX
    _PutStr blank

    _PutStr outputRadixPrompt
    _PickRadix outputRadix, EXIT, INVALID_RADIX
    _PutStr blank

    _PutStr debug_1
    _PutRadix 1234, 16, radixTable
    _PutStr blank

    _PutStr debug_2
    _PutRadix -1234, 16, radixTable
    _PutStr blank

    _PutStr numberPrompt_A
    ; TODO: Get number A

    _PutStr numberPrompt_B
    ; TODO: Get number B

    _PutStr outAdd
    ; TODO: Add

    _PutStr outSub
    ; TODO: sub

    _PutStr outMul
    ; TODO: mul

    _PutStr outDiv
    ; TODO: div

    _PutStr outPow
    ; TODO: pow

    jmp     PROMPT

INVALID_RADIX:
    _PutStr blank
    _PutStr errBadRadix
    jmp     PROMPT

EXIT:
    _Exit   RET_OK
main            ENDP
    END     main
