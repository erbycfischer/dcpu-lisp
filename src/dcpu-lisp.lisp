(defpackage :edu.cis.uab.dcpu-lisp
	(:use
		:common-lisp
		:edu.cis.uab.dcpu-lisp.lexer
		:edu.cis.uab.dcpu-lisp.parser
		:edu.cis.uab.dcpu-lisp.symbol-table
		:sb-ext)
	(:export
		:emit-line))`

(in-package :edu.cis.uab.dcpu-lisp)

(defparameter *output* t)

(defun emit-line (line)
	(format *output* "~a~%" line))

;; reads a file given a filename
(defun read-file (file-name)
	;; credits due -- takes a file as a stream
	;; and reads the whole file at once
	(flet	((slurp-stream (stream) 
					(let ((seq (make-string (file-length stream)))) 
						(read-sequence seq stream) seq)))
		;; checks if the file exists
		(if (probe-file file-name)
				(slurp-stream (open file-name))
				(progn
					(format t "File not found ~%")
					(finish-output)
					'nil))))

(defun compile-dcpu-lisp-program (program)
	(lex (read-file program))
	(parse))

(defun main () 
	;; if we have less than 2 arguments then they definitely did not provide a filename
	(if (< (length *posix-argv*) 2)
		(format t "You need to provide a lisp file to compile ~%")
		;; sets *code* to the whole lisp program
		(compile-dcpu-lisp-program (cadr *posix-argv*))))
