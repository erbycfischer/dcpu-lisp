dcpu-lisp
=========

dcpu-lisp is a simple lisp programming language for the DCPU-16 processor.

	prog := stmts 
	stmts := stmts stmt   
		| stmt  
	stmt := '( 'value terms ')   
		| '( 'value ')  
	terms := terms term  
		| term 
	term := stmt | 'symbol | 'number | 'value | 'string | '( ') 
