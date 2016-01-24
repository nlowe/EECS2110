; Nathan Lowe
; EECS 2110 - Computer Architecture and Organization
; Spring 2016 at the University of Toledo
;
; Description: Given the length, width, and height in feet and inches,
;              calculate the volume in cubic feet and inches or total
;              cubic inches
;

; ==============================================================================
; | Include libraries and macros (Include path is setup by the build script)   |
; ==============================================================================
include pcmac.inc
includelib UTIL.LIB

; ===========================     Start of Setup    ============================
.model small                                          ; Small Memory MODEL
.586                                                  ; Pentium Instruction Set
.stack 100h                                           ; Stack area - 256 bytes
; ===========================      End of Setup      ===========================

; ===========================  Start of Data Segment ===========================
.data
; ---------------------------  Input Prompt Strings  ---------------------------
widthFeetPrompt     DB  'Width (feet)> $'
widthInchesPrompt   DB  'Width (inches)> $'
heightFeetPrompt    DB  'Height (feet)> $'
heightInchesPrompt  DB  'Height (inches)> $'
lengthFeetPrompt    DB  'Length (feet)> $'
lengthInchesPrompt  DB  'Length (inches)> $'
; ------------------------------------------------------------------------------

; ---------------------------       Variables        ---------------------------
inputWidth    DW  1 DUP (0)                     ; The input width
inputHeight   DW  1 DUP (0)                     ; The input height
inputLength   DW  1 DUP (0)                     ; The input length
resultFeet    DW  1 DUP (0)                     ; Calculated result (feet)
resultPartial DW  1 DUP (0)                     ; Calculated remainder (inches)
resultInches  DW  1 DUP (0)                     ; Calculated result (inches)
; ------------------------------------------------------------------------------

; ---------------------------     Output Message     ---------------------------
output_1      DB  'Your volume is $'          ; These four strings are part
output_2      DB  ' cu. ft. and $'            ; of the output message. They
output_3      DB  ' cu. inches or $'          ; are broken up to substitute the
output_4      DB  ' cu. inches', 13, 10, '$'  ; calculated values in the output
; ------------------------------------------------------------------------------

; ---------------------------    Output Message      ---------------------------
err_non_number  DB  'That is not a number!', 13, 10, '$'
err_overflow    DB  'Input too large', 13, 10, '$'
; ------------------------------------------------------------------------------

; ===========================   End of Data Segment  ===========================

.code

; ---------------------------    UTIL.LIB Imports    ---------------------------
;EXTRN GetDec: NEAR
;EXTRN PutDec: NEAR
; ------------------------------------------------------------------------------

start:
main            PROC
  _LdSeg    ds, @data                  ; Setup the data segment

  _PutStr   offset widthFeetPrompt     ; Prompt the user for the width (feet)
  _PutStr   offset widthInchesPrompt   ; Prompt the user for the width (inches)
  ; TODO: Get the width

  _PutStr   offset heightFeetPrompt    ; Prompt the user for the height (feet)
  _PutStr   offset heightInchesPrompt  ; Prompt the user for the height (inches)
  ; TODO: Get the height

  _PutStr   offset lengthFeetPrompt    ; Prompt the user for the length (feet)
  _PutStr   offset lengthInchesPrompt  ; Prompt the user for the length (inches)
  ; TODO: Get the length

  ; Calculate result
  mov       dx, 0000h
  mov       ax, inputWidth          ; dx:ax = inputWidth
  mul       inputLength             ; dx:ax *= inputLenght
  mul       inputHeight             ; dx:ax *= inputHeight

  mov       resultInches, ax
  mov       [resultInches+2], dx          ; Store the result inches

  ; TODO: Calculate the result in cubic feet and remainder inches

  _PutStr   offset output_1           ; Print total cubic feet...
  mov       ax, offset resultFeet
  ;call      PutDec

  _PutStr   offset output_2           ; and inches
  mov       ax, offset resultPartial
  ;call      PutDec

  _PutStr   offset output_3           ; or total cubic inches
  mov       ax, offset resultInches
  ;call      PutDec

  _PutStr   offset output_4

  _Exit     00h
main            ENDP
  END       main
