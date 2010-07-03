; a java-like package system for newLISP

(context (ns-create 'com.example.Bar))

(define (foo bar)
	(println (context) ":foo -> " bar))

(println (context) " loaded")