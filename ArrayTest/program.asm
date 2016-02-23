; Nathan Lowe
; EECS 2110 - Computer Architecture and Organization
; Spring 2016 at the University of Toledo
;
; Description: Calculate the sum of an array of words
;

; ==============================================================================
; | Include libraries and macros                                               |
; ==============================================================================
include ..\lib\pcmac.inc
includelib ..\lib\UTIL.LIB

; ==============================================================================
; | Constants used in this file												   |
; ==============================================================================
CR				EQU 13		; Carriage Return
LF				EQU 10		; Line Feed
EOS				EQU '$'		; DOS End of string terminator
RET_OK			EQU 00h		; Return code for OK
RET_OVERFLOW	EQU 01h		; Return code for overflow

; ===========================	  Start of Setup	============================
.model small		; Small Memory MODEL
.586				; Pentium Instruction Set
.stack 100h			; Stack area - 256 bytes
; ===========================	   End of Setup		 ===========================

; ===========================  Start of Data Segment ===========================
.data
; ---------------------------  Input Prompt Strings	 ---------------------------
message_1		DB	'test prog1', CR, LF, EOS
; ------------------------------------------------------------------------------

; ---------------------------		Variables		 ---------------------------
word_array		DW	0006h, 0CADh, 0FFFh, 0123h, 0013h, 0040h,
					0000h, 0052h, 4321h, 2468h, 1BB7h
sum_of_words	DW	?
; ------------------------------------------------------------------------------

; ---------------------------	  Output Message	 ---------------------------
output_1		DB	'The sum is: ', EOS
blank			DB	CR, LF, EOS
; ------------------------------------------------------------------------------

; ===========================	End of Data Segment	 ===========================

.code

; ---------------------------	 UTIL.LIB Imports	 ---------------------------
EXTRN PutDec: NEAR
EXTRN PutHex: NEAR
; ------------------------------------------------------------------------------

start:
main			PROC
  _LdSeg	ds, @data			; Setup the data segment

  _PutStr	output_1
  
  mov		cx, 11
  mov		bx, offset word_array
  mov		ax, [bx]

FOR_1:
  jcxz		END_FOR_1
  add		bx, 2
  dec		cx
  add		ax, [bx]
  jmp		FOR_1
END_FOR_1:

  call		PutHex
  _PutStr	blank
  
  _Exit		RET_OK
main			ENDP
  END		main
