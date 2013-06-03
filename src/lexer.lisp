(defpackage :edu.cis.uab.dcpu-lisp.lexer
	(:use 
		:common-lisp)
	(:export
		:lex
		:get-token
		:LPAR
		:RPAR
		:DEFINE
		:LAMBDA
		:IF
		:WHEN
		:DEFUN
		:SET
		:MALLOC
		:FREE
		:WHILE
		:ID
		:NUM
		:STR
		:BOOL
		:CHAR))

(in-package :edu.cis.uab.dcpu-lisp.lexer)

(ql:quickload :cl-ppcre)

;; *code* will contain the lisp program being operated one
(defparameter *code* 'nil)
;; this is a list of regular expressions paired with their token type
;; pairs near the front of the list will have higher priority
(defparameter *tokens* '(("^\\(" LPAR)
						("^\\)" RPAR)
						("^define" DEFINE)
						("^lambda" LAMBDA)
						("^if" IF)
						("^when" WHEN)
						("^defun" DEFUN)
						("^set!" SET)
						("^malloc" MALLOC)
						("^free" FREE)
						("^while" WHILE)
						("^[-+]?[0-9]*\\.?[0-9]+" NUM)
						("^[\\w\\+\\-\\*:<>=/]+" ID)
						("^\\\"(\\\\.|.)*\\\"" STR)
						("^#t|^#f" BOOL)
						("^#\\newline|^#\\space|^#\\." CHAR)))

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

(defun lex (program) 
	(setf *code* program))
