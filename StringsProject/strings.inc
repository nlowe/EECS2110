.XLIST

;; strings.inc
;; Input, output, and message strings and prompts for the Strings project
;;
;; EECS 2110 - Computer Architecture and Organization
;; Spring 2016 at the University of Toledo

; ---------------------------    Input Prompt Strings    ---------------------------
newStringPrompt         DB  'Enter a new string> ', EOS
functionPrompt          DB  'Enter a function number> ', EOS

charFindPrompt          DB  'Enter a character to search for> ', EOS
charReplacePrompt       DB  'Enter a character to replace with> ', EOS
; ----------------------------------------------------------------------------------

; ---------------------------  String Function Messages  ---------------------------
functionMenu    DB  'Supported Functions: ', CR, LF
                DB  TAB, '1:   Find the index of the first occurrence of a character', CR, LF
                DB  TAB, '2:   Find the number of occurrences of a certain character', CR, LF
                DB  TAB, '3:   Find the length of the string', CR, LF
                DB  TAB, '4:   Find the number of alphanumeric characters of the string, including spaces', CR, LF
                DB  TAB, '5:   Replaces every occurrence of a certain letter with another symbol', CR, LF
                DB  TAB, '6:   Capitalize the letters in the string', CR, LF
                DB  TAB, '7:   Make each letter lower case', CR, LF
                DB  TAB, '8:   Toggle the case of each letter', CR, LF
                DB  TAB, '9:   Input a new string', CR, LF
                DB  TAB, '10:  Undo the last action that modified the string', CR, LF
                DB  TAB, '100: Output the menu', CR, LF
                DB  TAB, '0:   Exit the program', CR, LF, CR, LF, EOS

f1_1            DB  'The first index of "', EOS
f1_2            DB  '" is at position ', EOS

f2_1            DB  '"', EOS
f2_2            DB  '" occurs ', EOS
f2_3            DB  ' times', CR, LF, EOS

f3_1            DB  'The string length is ', EOS
f3_2            DB  ' characters', CR, LF, EOS

f4_1            DB  'There are ', EOS
f4_2            DB  ' alphanumeric characters in the string', CR, LF, EOS

f5_1            DB  'All occurrences of "', EOS
f5_2            DB  '" have been replaced with "', EOS
f5_3            DB  '"', CR, LF, EOS

f6_1            DB  'The string has been converted to upper-case', CR, LF, EOS

f7_1            DB  'The string has been converted to lower-case', CR, LF, EOS

f8_1            DB  'The casing of the string has been toggled', CR, LF, EOS
; ----------------------------------------------------------------------------------

; ---------------------------       Output Message       ---------------------------
currentString    DB  'The current string is:', CR, LF, EOS
undoNotAvailable DB  'Undo function not available (no actions to undo)', CR, LF, EOS
undoSuccess      DB  'Undo successful. The string is now: ', EOS
notImplemented   DB  'Not Implemented Yet', CR, LF, EOS
blank            DB  CR, LF, EOS

f1_notFound      DB  'That character was not found', CR, LF, EOS
; ----------------------------------------------------------------------------------

.LIST
