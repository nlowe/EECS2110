; Nathan Lowe
; EECS 2110 - Computer Architecture and Organization
; Spring 2016 at the University of Toledo
;
; Description: Given the length, width, and height in feet and inches,
;			   calculate the volume in cubic feet and inches or total
;			   cubic inches
;

; ==============================================================================
; | Include libraries and macros                                               |
; ==============================================================================
include ..\lib\pcmac.inc

; ==============================================================================
; | Constants used in this file												   |
; ==============================================================================
TAB					EQU 09			; Horizontal Tab
CR					EQU 13			; Carriage Return
LF					EQU 10			; Line Feed
EOS					EQU '$'			; DOS End of string terminator

MIN_LENGTH			EQU 8			; The minimum length of a password
MAX_LENGTH			EQU 20			; The maximum length of a password

ASCII_TO_LOWER_MASK	EQU 00100000b	; The bitmask to convert a character to lower

NUMERIC_LOWER		EQU '0'			; The lower bound for the numeric characters
NUMERIC_UPPER		EQU '9'			; The upper bound for the numeric characters

LOWERCASE_LOWER		EQU 'a'			; The lower bound for lower-case characters
LOWERCASE_UPPER		EQU	'z'			; The upper bound for lower-case characters

UPPERCASE_LOWER		EQU 'A'			; The lower bound for upper-case characters
UPPERCASE_UPPER		EQU 'Z'			; The upper bound for upper-case characters

RET_OK				EQU 00h			; Return code for OK

; ===========================	  Start of Setup	============================
.model small		; Small Memory MODEL
.586				; Pentium Instruction Set
.stack 100h			; Stack area - 256 bytes
; ===========================	   End of Setup		 ===========================

; ===========================  Start of Data Segment ===========================
.data
; ---------------------------  Input Prompt Strings	 ---------------------------
passwordPrompt			DB	'Enter a Password to Check> ', EOS
continuePrompt			DB	'Continue? [y/n] ', EOS
continueInvalidPrompt	DB	'Project specification dictates you enter either one of (Y,y,N,n), so I will ask again. ', EOS
; ------------------------------------------------------------------------------

; ---------------------------		Variables		 ---------------------------
lowerCount		 DW 0000h				; The number of lower-case characters
upperCount		 DW	0000h				; The number of upper-case characters
numberCount		 DW	0000h				; The number of numerical characters
specialCount	 DW 0000h				; The number of special characters
totalCount		 DW	0000h				; The total number of characters so far
validationErrors DW	0000h				; The number of validation errors
; ------------------------------------------------------------------------------

; ---------------------------	  Output Message	 ---------------------------
policy_1		DB	'Policy: 8-20 characters, and at least one of:', CR, LF, EOS
policy_2		DB	TAB, '* Lower Case (a-z)', CR, LF, EOS
policy_3		DB	TAB, '* Upper Case (A-Z)', CR, LF, EOS
policy_4		DB	TAB, '* Numbers (0-9)', CR, LF, EOS
policy_5		DB	TAB, '* Special Characters', CR, LF, EOS
pw_placeholder	DB	'*', EOS
pw_ok			DB	'Nice password! Everything checks out', CR, LF, EOS
missing_number	DB	'At least one letter is required', CR, LF, EOS
missing_lower	DB	'At least one lower case character is required', CR, LF, EOS
missing_upper	DB	'At least one upper case character is required', CR, LF, EOS
missing_special	DB  'At least one special character is required', CR, LF, EOS
too_short		DB	'Password must be at least 8 characters', CR, LF, EOS
too_long		DB	'Corporate dictates your password must be no longer than 20 characters...', CR, LF, EOS
blank			DB	CR, LF, EOS

debug_1			DB	'Your password had ', EOS
debug_2			DB	' numbers, ', EOS
debug_3			DB	' lower case letters, ', EOS
debug_4			DB	' upper case letters, ', EOS
debug_5			DB	' special characters, and was ', EOS
debug_6			DB	' characters long', CR, LF, EOS
; ------------------------------------------------------------------------------

; ===========================	End of Data Segment	 ===========================

.code

; ---------------------------	 UTIL.LIB Imports	 ---------------------------
EXTRN PutDec: NEAR
; ------------------------------------------------------------------------------

start:
main			PROC
	_LdSeg ds, @data
	_PutStr policy_1
	_PutStr policy_2
	_PutStr policy_3
	_PutStr policy_4
	_PutStr policy_5
	_PutStr blank
PROMPT:
	_PutStr passwordPrompt				; Ask for a password
PW_GET_CHAR:
	_GetCh	noEcho						; Get a character from stdin
	sPutStr pw_placeholder				; And print '*' for feedback
	
	cmp al, CR							; Check if the enter key was pressed
	JE  CHECKPW
	cmp al, LF
	JE  CHECKPW
	
	inc totalCount
	
	; Start checking for character sets
	cmp al, NUMERIC_LOWER				; If the character is less than a number
	JNAE CMP_SPECIAL					; It can only be a special character
	cmp al, NUMERIC_UPPER				; If the character is greater than a number
	JNBE CMP_UPPER						; Check upper-case next
	inc	numberCount
	jmp PW_GET_CHAR
CMP_UPPER:
	cmp al, UPPERCASE_LOWER				; If the character isn't a number and is less than 'A'
	JNAE CMP_SPECIAL					; It must be a special character
	cmp al, UPPERCASE_UPPER				; Otherwise, if its greater than 'Z'
	JNBE CMP_LOWER						; It could be a lowercase or special character
	inc upperCount
	jmp PW_GET_CHAR
CMP_LOWER:
	cmp al, LOWERCASE_LOWER				; If it's still not a lower case letter
	JNAE CMP_SPECIAL					; Then it must be a special character
	cmp al, LOWERCASE_UPPER
	JNBE CMP_SPECIAL
	inc lowerCount
	jmp PW_GET_CHAR
CMP_SPECIAL:
	inc specialCount
	jmp PW_GET_CHAR						; Prompt for the next character

CHECKPW:
	_PutStr blank

	cmp numberCount, 0
	jne CHECKPW_LOWER
	_PutStr missing_number
	inc validationErrors
CHECKPW_LOWER:
	cmp lowerCount, 0
	jne CHECKPW_UPPER
	_PutStr missing_lower
	inc validationErrors
CHECKPW_UPPER:
	cmp upperCount, 0
	jne CHECKPW_SPECIAL
	_PutStr missing_upper
	inc validationErrors
CHECKPW_SPECIAL:
	cmp specialCount, 0
	jne CHECKPW_MIN
	_PutStr missing_special
	inc validationErrors
CHECKPW_MIN:
	cmp totalCount, MIN_LENGTH
	jge CHECKPW_MAX
	_PutStr too_short
	inc validationErrors
CHECKPW_MAX:
	cmp totalCount, MAX_LENGTH
	jle STATUS
	_PutStr too_long
	inc validationErrors

STATUS:
	_PutStr blank
	_PutStr debug_1
	mov ax, numberCount
	call PutDec
	
	_PutStr debug_2
	mov ax, lowerCount
	call PutDec
	
	_PutStr debug_3
	mov ax, upperCount
	call PutDec
	
	_PutStr debug_4
	mov ax, specialCount
	call PutDec
	
	_PutStr debug_5
	mov ax, totalCount
	call PutDec
	
	_PutStr debug_6

	_PutStr blank
	cmp validationErrors, 0
	jne CONTINUE_PROMPT
	_PutStr pw_ok

CONTINUE_PROMPT:
	_PutStr continuePrompt				; Prompt the user to continue or exit
	_GetCh
	_PutStr blank
	
	mov totalCount, 0000h				; Reset character counters
	mov numberCount, 0000h
	mov lowerCount, 0000h
	mov upperCount, 0000h
	mov specialCount, 0000h
	mov validationErrors, 0000h
	
	OR al, ASCII_TO_LOWER_MASK			; Convert the read character to lower case
	cmp al, 'y'
	je PROMPT
	cmp al, 'n'
	je EXIT
	_PutStr continueInvalidPrompt		; /snark
	jmp CONTINUE_PROMPT
EXIT:
	_Exit 00h
main   			ENDP
  END main
