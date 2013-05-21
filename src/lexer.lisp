;; *code* will contain the lisp program being operated one
(defparameter *code* nil)

;; this will convert the lisp program into lexemes
(defun lex () 
	(format t "Made it to lex! ~%"))

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

(defun main () 
	;; if we have less than 2 arguments then they definitely did not provide a filename
	(if (< (length *posix-argv*) 2)
		(format t "You need to provide a lisp file to compile ~%")
		;; sets *code* to the whole lisp program
		(setf *code* (read-file (cadr *posix-argv*))))
	(if (equal *code* 'nil)
		(return-from main)
		(lex)))
