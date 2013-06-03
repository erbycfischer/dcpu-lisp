(defpackage :edu.cis.uab.dcpu-lisp
	(:use
		:common-lisp
		:edu.cis.uab.dcpu-lisp
		:edu.cis.uab.dcpu-lisp.parser))

(in-package :edu.cis.uab.dcpu-lisp)

;; Stolen from: https://github.com/smanek/common-lisp-utils/blob/master/random.lisp
(defun get-random-string (length &key (alphabetic nil) (numeric nil) (punctuation nil))
	  (assert (or alphabetic numeric))
		  (let ((alphabet nil))

				    (when alphabetic
							      (setf alphabet (append alphabet (concatenate 'list "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"))))
						    (when numeric
									      (setf alphabet (append alphabet (concatenate 'list "0123456789"))))
								    (when punctuation
											      (setf alphabet (append alphabet (concatenate 'list "!?;:\".,()-"))))

										    (setf alphabet (make-array (length alphabet) :element-type 'character :initial-contents alphabet))
												    (loop for i from 1 upto length
																	       collecting (string (elt alphabet (random (length alphabet)))) into pass
																				        finally (return (apply #'concatenate 'string pass)))))

(defun negate ()
	(emit-line "SET A, 0 ~%SUB A, POP"))

(defun clear ()
	(emit-line "SET A, 0"))

(defun not-b ()
	(emit-line "XOR A, -1"))

(defun load-val (a)
	(emit-line "SET A, ~a" a))

(defun push-stack ()
	(emit-line "SET PUSH, A"))

(defun pop-add ()
	(emit-line "ADD A, POP"))

(defun pop-sub ()
	(emit-line "SUB A, POP")
	(negate))

(defun pop-mul ()
	(emit-line "MUL A, POP"))

(defun pop-div ()
	(emit-line "SET B, POP")
	(emit-line "DIV B, A")
	(emit-line "SET A, B"))

(defun pop-mod ()
	(emit-line "SET B, POP")
	(emit-line "MOD B, A")
	(emit-line "SET A, B"))

(defun pop-and ()
	(emit-line "AND A, POP"))

(defun pop-or ()
	(emit-line "BOR A, POP"))

(defun pop-shl ()
	(emit-line "SET B, POP")
	(emit-line "SHL B, A")
	(emit-line "SET A, B"))

(defun pop-shr ()
	(emit-line "SET B, POP")
	(emit-line "SHR B, A")
	(emit-line "SET A, B"))

(defun pop-compare ()
	(emit-line "SET B, POP")
	(emit-line "SET C, 1"))

(defun set-equal ()
	(emit-line "IFG 0x8000, A")
	(emit-line "IFG B, 0x7fff")
	(call "comparestr")
	(emit-line "IFE A, B")
	(emit-line "SET C, 0"))

(defun set-notequal ()
	(emit-line "IFG 0x8000, A")
	(emit-line "IFG B, 0x7fff")
	(call "comparestr")
	(emit-line "IFN A, B")
	(emit-line "SET C, 0"))

(defun set-greater ()
	(emit-line "IFG B, A")
	(emit-line "SET C, 0"))

(defun set-less ()
	(emit-line "IFG A, B")
	(emit-line "SET C, 0"))

(defun set-greater-or-equal ()
	(set-greater)
	(set-less))

(defun call (s)
	(emit-line (format nil "JSR ~a" s)))

(defun branch (s)
	(emit-line (format nil "SET PC, ~a" s)))

(defun branch-false (s)
	(emit-line "IFN C, 0")
	(branch s))

(defun store (val)
	(emit-line (format nil "SET [~a], A" (+ ffff0D val))))

(defun ret ()
	(emit-line "SET PC, POP"))
