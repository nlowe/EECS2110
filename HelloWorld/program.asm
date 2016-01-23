; --------------------------------
; | Include libraries and macros |
; --------------------------------
include pcmac.inc
includelib UTIL.LIB

; =================================================
; Hello World in Intel Assembler
.model small    ; Small Memory MODEL
.586            ; Pentium Instruction Set
.stack 100h     ; Stack area - 256 bytes

.data
Message    DB  'Hello World! Foobar!', 13, 10, '$'

.code
Hello   PROC
  mov ax, @data
  mov ds, ax
  sPutStr offset message
  mov ax, 4c00h
  int 21h
Hello   ENDP
  END Hello
