#!/usr/bin/sbcl --script

(load "~/.sbclrc")

(load "./src/lexer.lisp")
(load "./src/parser.lisp")
(load "./src/symbol-table.lisp")
(load "./src/dcpu-lisp.lisp")

(in-package :edu.cis.uab.dcpu-lisp)

(sb-ext:save-lisp-and-die "dcpulisp" :executable t :toplevel 'main)
