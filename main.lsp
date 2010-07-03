#!/usr/bin/newlisp

;; @author Greg Slepak
;; @description This is just an example you can run from the terminal like so:
;; 
;; 	[prompt]$ newlisp main.lsp
;; 
;; Note that you don't need ObjNL.lsp, this is just demonstrating that the
;; two projects work together just fine.

(load "namespace.lsp" "ObjNL.lsp")
(add-to-load-path "src")

(ns-import 'com.example.*)

(Test:foo)
(Foo:foo 5)
(Bar:foo "hello from Bar!")

; Test, unlike the others, is an ObjNL class
; check to make sure that's true:

(setf obj (instantiate Test "happy"))
(obj:foo "ObjNL works!")

(println "obj implements: " obj:@interfaces)
(println "value of obj:a -> " obj:a)

(release obj)

; notice if we call it again nothing's loaded since it has already been loaded
; and load is being overwritten with our fancy load-once
(ns-import 'com.example.*)
(ns-import 'com.example.Test)

(exit)