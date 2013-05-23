(ql:quickload :cl-ppcre)

;; *code* will contain the lisp program being operated one
(defparameter *code* 'nil)
;; this is a list of regular expressions paired with their token type
;; pairs near the front of the list will have higher priority
(defparameter *tokens* '(("^\\(" 'LPAR)
						("^\\)" 'RPAR)
						("^[\\w\\+\\-\\*:<>]+" 'VAL)
						("^[-+]?[0-9]*\\.?[0-9]+" 'NUM)
						("^\\\"(\\\\.|.)*\\\"" 'STR)
						("^\\\'\\w+" 'SYM)))

;; this method will return the next token in *code*
(defun get-token ()
	;;this method will check if the given token is at the front of *code*
	(flet ((check-match (token-pair)
				(let ((match-to-check (cl-ppcre:scan-to-strings (car token-pair) *code*)))
					(when (> (length match-to-check) 0)
						(remove-match match-to-check)
						(return-from check-match (cons (cadr token-pair) match-to-check))))
				(let ((match-to-check (cl-ppcre:scan-to-strings "^\\s+|^;.*\\n" *code*)))
					(when (> (length match-to-check) 0)
						(remove-match match-to-check)
						(return-from check-match (get-token))))))
	;;loops over *tokens* until it finds a token at the front of *code*
	(loop for token in *tokens* do
		(let ((match-found (check-match token)))
			(when (not (equal match-found 'nil))
				(return-from get-token match-found))))))

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
		(setf *code* (read-file (cadr *posix-argv*)))))
