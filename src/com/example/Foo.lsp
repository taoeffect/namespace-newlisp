; a java-like package system for newLISP

(context (ns-create 'com.example.Foo))

(define (foo bar)
	(println (context) ":foo -> " bar))

(println (context) " loaded")