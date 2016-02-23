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
include .\utils.inc

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

; Special characters accepted are broken into 5 ranges
; This excludes non-printable characters
SPECIAL_1_LOWER		EQU ' '
SPECIAL_1_UPPER		EQU '/'

SPECIAL_2_LOWER		EQU ':'
SPECIAL_2_UPPER		EQU '@'

SPECIAL_3_LOWER		EQU '['
SPECIAL_3_UPPER		EQU '`'

SPECIAL_4_LOWER		EQU '{'
SPECIAL_4_UPPER		EQU '~'

SPECIAL_EXTRA		EQU 80h			; Anything from the extended set

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
; ------------------------------------------------------------------------------

; ===========================	End of Data Segment	 ===========================

.code

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
	
	cmp al, CR							; Check if the enter key was pressed
	je  CHECKPW
	cmp al, LF
	je  CHECKPW
	
	; Start checking for character sets
	_CheckChar NUMERIC_LOWER, NUMERIC_UPPER, numberCount, CMP_SPECIAL, CMP_UPPER, CHAR_OK

CMP_UPPER:
	_CheckChar UPPERCASE_LOWER, UPPERCASE_UPPER, upperCount, CMP_SPECIAL, CMP_LOWER, CHAR_OK

CMP_LOWER:
	_CheckChar LOWERCASE_LOWER, LOWERCASE_UPPER, lowerCount, CMP_SPECIAL, CMP_SPECIAL, CHAR_OK

CMP_SPECIAL:
	_CheckChar SPECIAL_1_LOWER, SPECIAL_1_UPPER, specialCount, CMP_SPECIAL_2, CMP_SPECIAL_2, CHAR_OK

CMP_SPECIAL_2:
	_CheckChar SPECIAL_2_LOWER, SPECIAL_2_UPPER, specialCount, CMP_SPECIAL_3, CMP_SPECIAL_3, CHAR_OK

CMP_SPECIAL_3:
	_CheckChar SPECIAL_3_LOWER, SPECIAL_3_UPPER, specialCount, CMP_SPECIAL_4, CMP_SPECIAL_4, CHAR_OK

CMP_SPECIAL_4:
	_CheckChar SPECIAL_4_LOWER, SPECIAL_4_UPPER, specialCount, CMP_SPECIAL_EXT, CMP_SPECIAL_EXT, CHAR_OK

CMP_SPECIAL_EXT:
	cmp al, SPECIAL_EXTRA
	jnae PW_GET_CHAR
	inc specialCount

CHAR_OK:
	inc totalCount						; Increment the total character count
	_PutStr pw_placeholder				; Print '*' for feedback
	jmp PW_GET_CHAR

CHECKPW:
	_PutStr blank

	_AssertOne numberCount, CHECKPW_LOWER, missing_number, validationErrors
CHECKPW_LOWER:
	_AssertOne lowerCount, CHECKPW_UPPER, missing_lower, validationErrors
CHECKPW_UPPER:
	_AssertOne upperCount, CHECKPW_SPECIAL, missing_upper, validationErrors
CHECKPW_SPECIAL:
	_AssertOne specialCount, CHECKPW_MIN, missing_special, validationErrors
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
	
	or al, ASCII_TO_LOWER_MASK			; Convert the read character to lower case
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
