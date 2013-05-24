(ql:quickload :cl-ppcre)

;; *code* will contain the lisp program being operated one
(defparameter *code* 'nil)
;; this is a list of regular expressions paired with their token type
;; pairs near the front of the list will have higher priority
(defparameter *tokens* '(("^\\(" LPAR)
						("^\\)" RPAR)
						("^[\\w\\+\\-\\*:<>]+" VAL)
						("^[-+]?[0-9]*\\.?[0-9]+" NUM)
						("^\\\"(\\\\.|.)*\\\"" STR)
						("^\\\'\\w+" SYM)))

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

(defun main-lex () 
	;; if we have less than 2 arguments then they definitely did not provide a filename
	(if (< (length *posix-argv*) 2)
		(format t "You need to provide a lisp file to compile ~%")
		;; sets *code* to the whole lisp program
		(setf *code* (read-file (cadr *posix-argv*)))))

(defparameter *lexemes* 'nil)
(defparameter *symbols* 'nil)

(defun get-lexemes () 
	(setf *lexemes* (loop for token = (get-token) until (equal token 'nil) collect token))
	(setf *symbols* (mapcar #'car *lexemes*)))

(defun simplify ()
	(setf *symbols* (replace-series *symbols* '(LPAR VAL) '(FUNC)))
	(setf *symbols* (mapcar (lambda (x)
								(if (member x '(SYM NUM VAL STR))
									'term
									x))
							*symbols*))
	(setf *symbols* (replace-series *symbols* '(func RPAR) '(stmt)))
	(setf *symbols* (replace-series *symbols* '(LPAR RPAR) '(term)))
	(let ((initial-symbols 'nil))
		(loop until (equal initial-symbols *symbols*) do
		(setf initial-symbols *symbols*)
		(let ((old-symbols 'nil))
			(loop until (equal old-symbols *symbols*) do
				(setf old-symbols *symbols*)
				(setf *symbols* (replace-series *symbols* '(stmt stmt) '(stmt)))
				(setf *symbols* (replace-series *symbols* '(term stmt) '(term)))
				(setf *symbols* (replace-series *symbols* '(stmt term) '(term)))
				(setf *symbols* (replace-series *symbols* '(term term) '(term)))
				(setf *symbols* (replace-series *symbols* '(func stmt) '(func term)))))
			(simplify-stmt))))

(defun simplify-stmt ()
	(setf *symbols* (replace-series *symbols* '(func term RPAR) '(stmt)))
	(let ((old-symbols 'nil))
		(loop until (equal old-symbols *symbols*) do
			(setf old-symbols *symbols*)
			(setf *symbols* (replace-series *symbols* '(stmt stmt) '(stmt))))))

(defun replace-series (list series replacement)
	(cond ((equal list 'nil)
				'nil)
			((list-begins-with list series)
				(append replacement (replace-series (subseq list (length series)) series replacement)))
			(t 
				(cons (car list) (replace-series (cdr list) series replacement)))))


(defun list-begins-with (list sublist)
	(cond ((equal sublist 'nil)
				t)
		   ((equal (car list) (car sublist))
		   		(list-begins-with (cdr list) (cdr sublist)))
		   (t
		   		'nil)))

(defun main-parser ()
	(get-lexemes)
	(simplify)
	(if (equal *symbols* '(stmt))
		(print "Program syntactically correct")
		(print "Syntax errors found")))

(defun main ()
	(main-lex)
	(main-parser))















