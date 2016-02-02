; Nathan Lowe
; EECS 2110 - Computer Architecture and Organization
; Spring 2016 at the University of Toledo
;
; Description: Given the length, width, and height in feet and inches,
;			   calculate the volume in cubic feet and inches or total
;			   cubic inches
;

; ==============================================================================
; | Include libraries and macros (Include path is setup by the build script)   |
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
INCH_PER_FOOT	EQU 12		; The number of inches per foot
INCH3_PER_FOOT3 EQU 1728	; The number of cubic inches per cubic foot

; ===========================	  Start of Setup	============================
.model small		; Small Memory MODEL
.586				; Pentium Instruction Set
.stack 100h			; Stack area - 256 bytes
; ===========================	   End of Setup		 ===========================

; ===========================  Start of Data Segment ===========================
.data
; ---------------------------  Input Prompt Strings	 ---------------------------
widthPrompt		DB	'Width> ', EOS
heightPrompt	DB	'Height> ', EOS
lengthPrompt	DB	'Length> ', EOS
; ------------------------------------------------------------------------------

; ---------------------------		Variables		 ---------------------------
inputWidth	  DW  0000h						   ; The input width
inputHeight	  DW  0000h						   ; The input height
inputLength	  DW  0000h						   ; The input length
resultFeet	  DW  0000h						   ; Calculated result (feet)
resultPartial DW  0000h						   ; Calculated remainder (inches)
resultInches  DW  0000h						   ; Calculated result (inches)
; ------------------------------------------------------------------------------

; ---------------------------	  Output Message	 ---------------------------
output_1	  DB  'Your volume is ', EOS	   ; These four strings are part of
output_2	  DB  ' cu. ft. and ', EOS		   ; the output message. They are
output_3	  DB  ' cu. inches or ', EOS	   ; broken up to substitute the
output_4	  DB  ' cu. inches', CR, LF, EOS   ; calculated values in the output
; ------------------------------------------------------------------------------

; ---------------------------	 Output Message		 ---------------------------
greeting		DB	'Enter input as <feet> <inches>', CR, LF, EOS
err_overflow	DB	'Input too large', CR, LF, EOS
blank			DB	CR, LF, EOS
; ------------------------------------------------------------------------------

; ===========================	End of Data Segment	 ===========================

.code

; ---------------------------	 UTIL.LIB Imports	 ---------------------------
EXTRN GetDec: NEAR
EXTRN PutDec: NEAR
; ------------------------------------------------------------------------------

start:
main			PROC
  _LdSeg	ds, @data			; Setup the data segment

  _PutStr	greeting			; Tell the user how to input the data
  _PutStr	widthPrompt			; Prompt the user for the width (feet)
  call		GetDec
  mov		bx, INCH_PER_FOOT
  mul		bx					; Multiply by 12 to convert to inches
  jo		OVERFLOW		; Check if the number was too large
  mov		inputWidth, ax		; Store the intermediate result
  
  call		GetDec				; Now get the partial inches
  add		ax, inputWidth		; Add the inches from the feet component
  mov		inputWidth, ax		; And store the total input width

  _PutStr	heightPrompt		; Prompt the user for the height (feet)
  call		GetDec
  mov		bx, INCH_PER_FOOT
  mul		bx					; Multiply by 12 to convert to inches
  jo		OVERFLOW		; Check if the number was too large
  mov		inputHeight, ax		; Store the intermediate result
  
  call		GetDec				; Now get the partial inches
  add		ax, inputHeight		; Add the inches from the feet component
  mov		inputHeight, ax		; And store the total input height

  _PutStr	lengthPrompt		; Prompt the user for the length (feet)
  call		GetDec
  mov		bx, INCH_PER_FOOT
  mul		bx					; Multiply by 12 to convert to inches
  jo		OVERFLOW		; Check if the number was too large
  mov		inputLength, ax		; Store the intermediate result
  
  call		GetDec				; Now get the partial inches
  add		ax, inputLength		; Add the inches from the feet component
  mov		inputLength, ax		; And store the total input length

  ; Calculate result
  mov		dx, 0000h
  mov		ax, inputWidth		; dx:ax = inputWidth
  mul		inputLength			; dx:ax *= inputLenght
  jo		OVERFLOW		; Check if the number was too large
  mul		inputHeight			; dx:ax *= inputHeight
  jo		OVERFLOW		; Check if the number was too large

  mov		resultInches, ax	; Store the total result in inches

  mov		bx, INCH3_PER_FOOT3 ; We will be comparing the intermediate to a cubic foot
  cmp		ax, bx
  jl		RESULT				; We have less than one cubic foot, just print the result
DIVMOD:
  inc		resultFeet			; Increment the feet count by one
  sub		ax, bx				; Subtract one cubic foot
  cmp		ax, bx				; Compare the remaining inches to a cubic foot
  jl		RESULT				; Break out if we have less than a cubic foot remaining
  jmp		DIVMOD
OVERFLOW:
  _PutStr	blank
  _PutStr	err_overflow
  _Exit		RET_OVERFLOW
RESULT:
  mov		resultPartial, ax	; Store the remaining inches

  _PutStr	output_1			; Print total cubic feet...
  mov		ax, resultFeet
  call		PutDec

  _PutStr	output_2			; and inches
  mov		ax, resultPartial
  call		PutDec

  _PutStr	output_3			; or total cubic inches
  mov		ax, resultInches
  call		PutDec

  _PutStr	output_4

  _Exit		RET_OK
main			ENDP
  END		main
