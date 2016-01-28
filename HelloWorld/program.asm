; --------------------------------
; | Include libraries and macros |
; --------------------------------
include ..\lib\pcmac.inc

; =================================================
; Hello World in Intel Assembler
.model small    ; Small Memory MODEL
.586            ; Pentium Instruction Set
.stack 100h     ; Stack area - 256 bytes

.data
Message    DB  'Hello World! Foobar!', 13, 10, '$'

.code
Hello   PROC
  _LdSeg ds, @data
  sPutStr message
  _Exit 00h
Hello   ENDP
  END Hello
