; a java-like package system for newLISP

; this is the shortest way I know of to:
; 1) create and switch to the com.example.Test namespace
; 2) create the ObjNL class com.example.Test
(new-class (sym (term (context (ns-create 'com.example.Test))) MAIN))

; a constructor. yes, unfortunately we have no choice
; but to write out its name fully. :-\
(define (com.example.Test:com.example.Test _a)
	(setf a _a)
	true
)

(define (foo bar)
	(println (context) ":foo -> " bar))

(println (context) " loaded. Test = " Test)