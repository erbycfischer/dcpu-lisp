(defpackage :edu.cis.uab.dcpu-lisp.parser
	(:use 
		:common-lisp
		:edu.cis.uab.dcpu-lisp.lexer)
	(:export
		:parse))

(in-package :edu.cis.uab.dcpu-lisp.parser)

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

(defun parse ()
	(get-lexemes)
	(simplify)
	(if (equal *symbols* '(stmt))
		(print "Program syntactically correct")
		(print "Syntax errors found")))
