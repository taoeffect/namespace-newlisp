;; @module namespace.lsp
;; @description A java-like namespace system for newLISP
;; @version 1.0
;; @author Greg Slepak

;; @syntax (ns-create <sym-ns>)
;; <p>Example: Call like this from within com/example/Foo.lsp:</p>
;; <pre> (context (ns-create 'com.example.Foo))</pre>
;; <p>'Foo' *must* start with a capital letter.</p>
;; <p>You can also just do '(context &apos;com.example.Foo)', but then
;; 'com.example.Foo:Foo' will be 'nil' instead of referring to the context.</p>
(define (ns-create ns)
	(set (sym (last (parse (term ns) ".")) ns) ns))

;; @syntax (ns-import <sym-ns>)
;; <p><pre> (ns-import 'com.example.*)</pre></p>
;; <p>That will import all of the classes/contexts from com/example.
;; They must start with a capital letter or they won't be imported.
;; Aliases are made in the current context to them so that you don't
;; have to write out the fully-qualified name. For example:</p>
;; <pre> (ns-import 'com.example.Test)</pre>
;; <p>Both examples will load the files only once. In the above example,
;; the symbol Test will be set to the context 'com.example.Test' in the 
;; calling context.</p>
(define (ns-import ns , tmp)
	(letn (
			path-l  (parse (term ns) ".")
			pctx    (prefix ns)
			class   (pop path-l -1)
			path    (join path-l "/")
			ld      (fn (file class ns , alias)
			            (load file)
			            ; in context that called this function, make Test refer to com.example.Test
			            (set (sym class pctx) (prefix (sym class ns)))))
		(if (= "*" class)
			(dolist (dir load-once.lp break)
				(when (directory? (setf tmp (string dir "/" path)))
					(setf break true)
					(dolist (file (directory tmp {^[A-Z].+\.lsp$}))
						(setf class (first (parse file ".")))
						(ld (string tmp "/" file) class (sym (string (join path-l "." true) class))))))
			(ld (string path "/" class ".lsp") class ns))))


(global 'ns-package 'ns-import)


; protect against situation where one of the load functions is used to
; load this file, thereby redefining the function itself while it's running
; and causing newlisp to crash.
; This may also speed up the loading of this file the second time around.
(unless load-once
	; empty load path initially
	(setf load-once.lp '())
	(new Tree 'load-once.loaded)
	
;; @syntax (add-to-load-path <str-path-1> <str-path-2> ...)
;; <p>The built-in function 'load' is overwritten so that files
;; are loaded only once. In addition it supports the concept of "load paths"
;; which can be added using this function. This means that you no longer need
;; to modify third-party code that contains 'load' calls to files located in
;; different locations. Simply add a new load path instead.</p>
;; <b>example:</b>
;; <pre> ; the old way
;; (load "MyClass.lsp") ;=> ERROR! MyClass.lsp doesn't exist here!
;; ; we must rewrite the file to point to the new location of MyClass.lsp:
;; (load "../../myfolder/MyClass.lsp")
;; ; -------------------------------
;; ; New way, using add-to-load-path
;; ; -------------------------------
;; (add-to-load-path "../../myfolder")
;; ; no need to update any source files, it just works.</pre>
;; <b>warning:</b> Use this function sparingly as name-conflicts could
;; result in the wrong file being loaded!
	(define (add-to-load-path)
		(doargs (path)
			(setf load-once.lp (unique (push (real-path path) load-once.lp)))))
	
	(define (load-once)
		; check if the last argument is a context (to behave like 'load' does)
		(let (ctx (let (_ctx (last $args)) (if (context? _ctx) _ctx MAIN)) filename nil)
			(doargs (file (context? file))
				(setf filename file)
				(dolist (lp load-once.lp (file? file))
					(setf file (string lp "/" filename))
				)
				(unless (setf file (real-path file))
					(throw-error (string "cannot load file: " filename))
				)
				(when (not (load-once.loaded file))
					(load-once.loaded file true)
					(sys-load file ctx)))))
					
	(global 'load-once 'add-to-load-path)
	
	; swap these functions for ours and save the originals
	(constant (global 'sys-load) load)
	(constant 'load load-once)
)
