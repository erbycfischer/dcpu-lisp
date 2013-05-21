#!/usr/bin/sbcl --script

(defparameter *files* '("./src/lexer.lisp"))
(loop for file in *files*
			do (load file))

(sb-ext:save-lisp-and-die "dcpulisp" :executable t :toplevel 'main)
