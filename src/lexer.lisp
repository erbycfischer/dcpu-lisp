(defparameter *code* nil)

(defun lex () 
	(format t "Made it to lex! ~%"))

(defun read-file (file-name)
	;; credits due
	(flet	((slurp-stream (stream) 
					(let ((seq (make-string (file-length stream)))) 
						(read-sequence seq stream) seq)))
		(if (probe-file file-name)
				(slurp-stream (open file-name))
				(progn
					(format t "File not found ~%")
					(finish-output)
					'nil))))

(defun main () 
	(if (< (length *posix-argv*) 2)
		(format t "You need to provide a lisp file to compile ~%")
		(setf *code* (read-file (cadr *posix-argv*))))
	(if (equal *code* 'nil)
		(return-from main)
		(lex)))
