#!/usr/bin/sbcl --script

(defpackage :edu.cis.uab.unit-tests
	(:use 
		:edu.cis.uab.lexer 
		:edu.cis.uab.parser))

(defvar +lexer-tests+ '(("lexer")
											 ("(+ 2 (* 3 5))")
											 ("(define test (a b c)
													 (+ c (+ a b))
													 ;; This is a string within a string!
													 \"field test, on the Common Lisp field. ;; not a comment\n\")
												(test 1 2 3)
												;; Comment on the last line -- This should break.")))

(defvar +parser-tests+ 'nil)

(defun unit-test (identifier)
	(when (equal (car identifier) "lexer")
		(loop for i in (cdr +lexer-tests+)
					do (print (lex i))))
	(when (equal (car identifier) "parser")
		(loop for i in (cdr +parser-tests+)
			do ((print (parse i))))))


(unit-test (cadr *posix-argv*))
