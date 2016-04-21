; Nathan Lowe
; EECS 2110 - Computer Architecture and Organization
; Spring 2016 at the University of Toledo
;
; Description: Given an input radix, output radix, and two numbers in the
;               specified input radix, perform the following operations:
;              A+B
;              A-B
;              A*B
;              A/B if b != 0, otherwise display an error
;              A^abs(b)

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
MAX_RADIX           EQU 36

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
    _PutStr    inputRadixPrompt
    _PickRadix inputRadix, EXIT, INVALID_RADIX
    _PutStr    blank

    _PutStr    outputRadixPrompt
    _PickRadix outputRadix, EXIT, INVALID_RADIX
    _PutStr    blank

    _PutStr    numberPrompt_A
    mov        al, inputRadix
    cbw
    mov        dx, ax
    _PutRadix  dx, 10, radixTable
    _PutStr    numberPrompt_Radix
    _GetRadix  inputA, inputRadix, radixTable, radixTableLength, INVALID_RADIX_SYMBOL

    _PutStr    numberPrompt_B
    mov        al, inputRadix
    cbw
    mov        dx, ax
    _PutRadix  dx, 10, radixTable
    _PutStr    numberPrompt_Radix
    _GetRadix  inputB, inputRadix, radixTable, radixTableLength, INVALID_RADIX_SYMBOL

    _PutStr    outAdd
    mov        ax, inputA
    mov        mathscratch, ax
    mov        bx, inputB
    add        mathscratch, bx
    _PutRadix  mathscratch, outputRadix, radixTable
    _PutStr    blank

    _PutStr    outSub
    mov        ax, inputA
    mov        mathscratch, ax
    mov        bx, inputB
    sub        mathscratch, bx
    _PutRadix  mathscratch, outputRadix, radixTable
    _PutStr    blank

    _PutStr    outMul
    xor        dx, dx
    mov        ax, inputA
    imul       inputB
    mov        mathscratch, ax
    _PutRadix  mathscratch, outputRadix, radixTable
    _PutStr    blank

    _PutStr    outDiv
    cmp        inputB, 0
    jne        OUT_DIV
    _PutStr    errDivByZero
    jmp        OUT_DIV_DONE
OUT_DIV:
    mov        ax, inputA
    cwd
    idiv       inputB
    push       dx
    mov        mathscratch, ax
    _PutRadix  mathscratch, outputRadix, radixTable
    _PutStr    outRemainder
    pop        dx
    mov        mathscratch, dx
    _PutRadix  mathscratch, outputRadix, radixTable
    _PutStr    blank
OUT_DIV_DONE:

    _PutStr    outPow
    mov        ax, inputB
    cwd                                  ; Fill dx with the sign bit of ax
    xor        ax, dx                    ; And compute the absolute value
    sub        ax, dx                    ; of inputB first
    _Pow       inputA, ax, mathscratch
    _PutRadix  mathscratch, outputRadix, radixTable
    _PutStr    blank

    jmp        PROMPT

INVALID_RADIX:
    _PutStr    blank
    _PutStr    errBadRadix
    jmp        PROMPT

INVALID_RADIX_SYMBOL:
    _PutStr    blank
    _PutStr    errBadSymbol
    jmp        PROMPT

EXIT:
    _Exit      RET_OK
main            ENDP
    END        main
