(defpackage :edu.cis.uab.dcpu-lisp.symbol-table
	(:use 
		:common-lisp
		:edu.cis.uab.dcpu-lisp.parser)
	(:export
		:make-symbol-table))

(in-package :edu.cis.uab.dcpu-lisp.symbol-table)

(defparameter *symbol-table* (make-hash-table))
(defparameter *lexemes* 'nil)

(defun make-symbol-table ()
		(setf *lexemes* (get-lexemes)))

(defun add-symbol (key value tables)
	(let ((current-table *symbol-table*))
	(loop for table in tables
		do (setf current-table (gethash table current-table)))
	(setf (gethash key current-table) value)))

(defun get-symbol (key tables)
	(let ((current-table *symbol-table*))
	(loop for table in tables
		do (setf current-table (gethash table current-table)))
	(gethash key current-table)))