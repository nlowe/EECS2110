; Take Home Test

; ==============================================================================
; | Include libraries and macros                                               |
; ==============================================================================
include ..\lib\pcmac.inc
includelib ..\lib\UTIL.LIB

; ==============================================================================
; | Constants used in this file                                                |
; ==============================================================================
RET_OK              EQU 00h         ; Return code for OK
CR                  EQU 13          ; Carriage Return
LF                  EQU 10          ; Line Feed
EOS                 EQU '$'         ; DOS End of string terminator

OPTION_1_LOW        EQU 'a'         ; The lower range for add/sub
OPTION_1_HIGH       EQU 'm'         ; The upper range for add/sub

OPTION_2_LOW        EQU 'n'         ; The lower range for mul/div
OPTION_2_HIGH       EQU 'z'         ; The upper range for mul/div

ASCII_TO_LOWER_MASK EQU 00100000b   ; The bitmask to convert a character to lower

; ===========================     Start of Setup    ============================
.model small        ; Small Memory MODEL
.586                ; Pentium Instruction Set
.stack 100h         ; Stack area - 256 bytes
; ===========================      End of Setup      ===========================

; ===========================  Start of Data Segment ===========================
.data
p_num_1     DB 'Enter the first number: ', EOS
p_num_2     DB 'Enter the second number: ', EOS
p_letter    DB 'Enter a letter: ', EOS
p_continue  DB 'Do you wish to repeat? (Enter y or Y to repeat, any other key exits) [yY|nN] ', EOS

out_a_1     DB 'The sum is ', EOS
out_a_2     DB ', and the difference is ', EOS

out_b_1     DB 'The product is ', EOS
out_b_2     DB ', and the division is ', EOS
out_b_3     DB ' remainder ', EOS

blank       DB CR, LF, EOS

num_1       DW 0000h
abs_num_1   DW 0000h
num_2       DW 0000h
abs_num_2   DW 0000h

; ===========================   End of Data Segment  ===========================

; In general, the absolute value of an n-bit signed number can be found like so:
;       abs(x) = (x ^ y) - y
; where: y is x >>> (n-1) and '>>>' is an arithmetic right shift (handled by cwd here)
_abs MACRO dst, src
    mov     ax, src
    cwd                                 ; Fill dx with the sign bit of ax
    xor     ax, dx
    sub     ax, dx
    mov     dst, ax
ENDM

.code

; ---------------------------    UTIL.LIB Imports    ---------------------------
EXTRN GetDec: NEAR
EXTRN PutDec: NEAR
; ------------------------------------------------------------------------------

start:
main            PROC
  _LdSeg    ds, @data                   ; Setup the data segment
  
TOP:
  _PutStr   p_num_1                     ; Prompt for and store the first number
  call      GetDec
  mov       num_1, ax
  
  _PutStr   p_num_2                     ; Prompt for and store the second number
  call      GetDec
  mov       num_2, ax

GET_LETTER:
  _PutStr   p_letter                    ; Get the option letter
  _GetCh
  _PutStr   blank
  or        al, ASCII_TO_LOWER_MASK     ; Convert the read character to lower case
  
  cmp       al, OPTION_1_LOW            ; If we're not in the lower half, jump to mul/div
  jnae      CHECK_2
  cmp       al, OPTION_1_HIGH
  jnbe      CHECK_2
  
  _PutStr   out_a_1
  
  _abs      abs_num_2, num_2            ; Calculate the absolute value of the second number
  _abs      abs_num_1, num_1            ; first, so we can re-use ax in the next instruction
  
  add       ax, abs_num_2               ; ax = abs(num_2) + abs(num_1)
  call      PutDec
  
  _PutStr   out_a_2
  mov       ax, abs_num_1               ; PutDec and _PutStr alter ax and dx
  sub       ax, abs_num_2
  call      PutDec
  
  _PutStr   blank
  
  jmp       CHECK_CONTINUE
CHECK_2:
  cmp       al, OPTION_2_LOW            ; If it wasn't a letter, prompt again
  jnae      GET_LETTER
  cmp       al, OPTION_2_HIGH
  jnbe      GET_LETTER
  
  _PutStr   out_b_1
  mov       ax, num_1
  imul      num_2
  
  call      PutDec
  
  _PutStr   out_b_2
  mov       ax, num_1                   ; restore ax for the div
  cwd                                   ; extend a's sign bit for the div
  idiv      num_2
  mov       bx, dx                      ; Save the remainder in bx, since PutDec and _PutStr
  call      PutDec                      ; alter dx
  
  _PutStr   out_b_3
  mov       ax, bx
  call      PutDec
  
  _PutStr   blank
CHECK_CONTINUE:
  _PutStr   p_continue
  _GetCh
  _PutStr   blank
  or        al, ASCII_TO_LOWER_MASK     ; Convert the read character to lower case
  
  cmp       al, 'y'
  je        TOP                         ; The user entered 'y', go again
  cmp       al, 'n'
  je        EXIT                        ; The user entered 'n', exit
  jmp       CHECK_CONTINUE              ; ask again...
  
EXIT: 
  _Exit     RET_OK
main            ENDP
  END       main
