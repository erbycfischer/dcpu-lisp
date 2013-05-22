(ql:quickload :cl-ppcre)

;; *code* will contain the lisp program being operated one
(defparameter *code* 'nil)
;; *last-match* will contain the type of the last match
(defparameter *last-match* 'nil)

;; this will convert the lisp program into lexemes
(defun lex () 
	(loop for token = (match *code*) until (equal token 'nil) do (progn (print token) (remove-match *last-match*))))

(defun match (string)
	(progn (let ((match (cl-ppcre:scan-to-strings "^\\(" string)))
				(when (> (length match) 0) (progn (setf *last-match* match) (return-from match (cons 'LPAR match)))))
			(let ((match (cl-ppcre:scan-to-strings "^\\)" string)))
				(when (> (length match) 0) (progn (setf *last-match* match) (return-from match (cons 'RPAR match)))))
			(let ((match (cl-ppcre:scan-to-strings "^[a-zA-Z][\\w\\+\\-\\*]+" string)))
				(when (and (> (length match) 0) (equal *last-match* "(")) (progn (setf *last-match* match) (return-from match (cons 'FUNC match)))))
			(let ((match (cl-ppcre:scan-to-strings "^[a-zA-Z][\\w\\+\\-\\*]+" string)))
				(when (> (length match) 0) (progn (setf *last-match* match) (return-from match (cons 'VAR match)))))
			(let ((match (cl-ppcre:scan-to-strings "^[-+]?[0-9]*\\.?[0-9]+" string)))
				(when (> (length match) 0) (progn (setf *last-match* match) (return-from match (cons 'NUM match)))))
			(let ((match (cl-ppcre:scan-to-strings "^\\\"(\\\\.|.)*\\\"" string)))
				(when (> (length match) 0) (progn (setf *last-match* match) (return-from match (cons 'STR match)))))
			(let ((match (cl-ppcre:scan-to-strings "^\\\'(\\w|\\-)+" string)))
				(when (> (length match) 0) (progn (setf *last-match* match) (return-from match (cons 'SYM match)))))
			(let ((match (cl-ppcre:scan-to-strings "^\\s+" string)))
				(when (> (length match) 0) (return-from match (match (remove-match match)))))))

(defun remove-match (match)
	(setf *code* (subseq *code* (length match))))

;; reads a file given a filename
(defun read-file (file-name)
	;; credits due -- takes a file as a stream
	;; and reads the whole file at onece
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
	;; if we have less than 2 arguments then they definiely did not provide a filename
	(if (< (length *posix-argv*) 2)
		(format t "You need to provide a lisp file to compile ~%")
		;; sets *code* to the whole lisp program
		(setf *code* (read-file (cadr *posix-argv*))))
	(if (equal *code* 'nil)
		(return-from main)
		(lex)))
