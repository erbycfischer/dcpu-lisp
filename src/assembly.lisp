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
	(emit-line (format nil "SET A, 0~%SUB A, POP")))

(defun clear ()
	(emit-line "SET A, 0"))

(defun not-b ()
	(emit-line "XOR A, -1"))

(defun load-val (a)
	(emit-line (format nil "SET A, ~a" a)))

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

(defun inline-assembly-one-arg (instr x)
	(if (symbol-name x)
		(emit-line (format nil "~a, ~a" instr (symbol-value x)))
		(emit-line (format nil "~a, ~a" instr x))))

(defun inline-assembly (instr x y)
	(if (symbol-name x)
		(if (symbol-name y)
			(emit-line (format nil "~a ~a, ~a" instr (symbol-value x) (symbol-value y)))
			(emit-line (format nil "~a ~a, ~a" instr (symbol-value x) y)))
		(if (symbol-name y)
			(emit-line (format nil "~a ~a, ~a" instr x (symbol-value y)))
			(emit-line (format nil "~a ~a, ~a" instr x y)))))

(defun _SET (x y)
	(inline-assembly "SET" x y))

(defun _ADD (x y)
	(inline-assembly "ADD" x y))

(defun _SUB (x y)
	(inline-assembly "SUB" x y))

(defun _MUL (x y)
	(inline-assembly "MUL" x y))

(defun _MLI (x y)
	(inline-assembly "MLI" x y))

(defun _DIV (x y)
	(inline-assembly "DIV" x y))

(defun _DVI (x y)
	(inline-assembly "DVI" x y))

(defun _MOD (x y)
	(inline-assembly "MOD" x y))

(defun _MDI (x y)
	(inline-assembly "MDI" x y))

(defun _AND (x y)
	(inline-assembly "AND" x y))

(defun _BOR (x y)
	(inline-assembly "BOR" x y))

(defun _XOR (x y)
	(inline-assembly "XOR" x y))

(defun _SHR (x y)
	(inline-assembly "SHR" x y))

(defun _ASR (x y)
	(inline-assembly "ASR" x y))

(defun _SHL (x y)
	(inline-assembly "SHL" x y))

(defun _IFB (x y)
	(inline-assembly "IFB" x y))

(defun _IFC (x y)
	(inline-assembly "IFC" x y))

(defun _IFE (x y)
	(inline-assembly "IFE" x y))

(defun _IFN (x y)
	(inline-assembly "IFN" x y))

(defun _IFG (x y)
	(inline-assembly "IFG" x y))

(defun _IFA (x y)
	(inline-assembly "IFA" x y))

(defun _IFL (x y)
	(inline-assembly "IFL" x y))

(defun _IFU (x y)
	(inline-assembly "IFU" x y))

(defun _ADX (x y)
	(inline-assembly "ADX" x y))

(defun _SBX (x y)
	(inline-assembly "SBX" x y))

(defun _STI (x y)
	(inline-assembly "STI" x y))

(defun _STD (x y)
	(inline-assembly "STD" x y))

(defun _JSR (x)
	(inline-assembly-one-arg "JSR" x))

(defun _INT (x)
	(inline-assembly-one-arg "INT" x))

(defun _IAG (x)
	(inline-assembly-one-arg "IAG" x))

(defun _IAS (x)
	(inline-assembly-one-arg "IAS" x))

(defun _RFI (x)
	(inline-assembly-one-arg "RFI" x))

(defun _IAQ (x)
	(inline-assembly-one-arg "IAQ" x))

(defun _HWN (x)
	(inline-assembly-one-arg "HWN" x))

(defun _HWQ (x)
	(inline-assembly-one-arg "HWQ" x))

(defun _HWI (x)
	(inline-assembly-one-arg "HWI" x))
