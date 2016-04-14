.XLIST

;; strings.inc
;; Input, output, and message strings and prompts for the Strings project
;;
;; EECS 2110 - Computer Architecture and Organization
;; Spring 2016 at the University of Toledo

radixTable              DB  '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ', EOS
radixTableLength        DB  36

; ---------------------------    Input Prompt Strings    ---------------------------
inputRadixPrompt        DB  'Enter input radix (8=Octal, 16,h,H=hex, x to exit)> ', EOS
outputRadixPrompt       DB  'Enter output radix (8=Octal, 16,h,H=hex, x to exit)> ', EOS
numberPrompt_A          DB  'Enter number A> ', EOS
numberPrompt_B          DB  'Enter number B> ', EOS
; ----------------------------------------------------------------------------------

; ---------------------------       Output Message       ---------------------------
outAdd           DB  'A+B=', EOS
outSub           DB  'A-B=', EOS
outMul           DB  'A*B=', EOS
outDiv           DB  'A/B=', EOS
outRemainder     DB  ' remainder ', EOS
outPow           DB  'A^B=', EOS

debug_1          DB  'inputA in hex: ', EOS
debug_2          DB  'inputB in hex: ', EOS

errBadRadix      DB  'Invalid Radix', CR, LF, EOS
errBadSymbol     DB  'Invalid Symbol for input radix', CR, LF, EOS

notImplemented   DB  'Not Implemented Yet', CR, LF, EOS
blank            DB  CR, LF, EOS
; ----------------------------------------------------------------------------------

.LIST
