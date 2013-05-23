(ql:quickload :cl-ppcre)

;; *code* will contain the lisp program being operated one
(defparameter *code* 'nil)
;; *last-match* will contain the type of the last match
(defparameter *last-match* 'nil)

(defparameter *tokens* '(("^\\(" 'LPAR)
					("^\\)" 'RPAR)
					("^[\\w\\+\\-\\*:<>]+" 'FUNC)
					("^[a-zA-Z][\\w\\+\\-\\*:]+" 'VAR)
					("^[-+]?[0-9]*\\.?[0-9]+" 'NUM)
					("^\\\"(\\\\.|.)*\\\"" 'STR)
					("^\\\'\\w+" 'SYM)))

(defun match (string) (flet ((check-match (token-pair string)
								(let ((match-to-check (cl-ppcre:scan-to-strings (car token-pair) string)))
									(when (> (length match-to-check) 0) (progn (setf *last-match* match-to-check) (return-from match (cons (cadr token-pair) match-to-check)))))
								(let ((match-to-check (cl-ppcre:scan-to-strings "^\\s+" string)))
									(when (> (length match-to-check) 0) (return-from match (match (remove-match match-to-check)))))))
				(loop for token in *tokens* do (let ((match-found (check-match token string)))
					(when (not (equal match-found 'nil)) (progn (remove-match *last-match*) (return-from match match-found)))))))

;; this will convert the lisp program into lexemes
(defun lex () 
	(loop for token = (match *code*) until (equal token 'nil) do (progn (print token) (remove-match *last-match*))))


(defun remove-match (match)
	(setf *code* (subseq *code* (length match))))

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
