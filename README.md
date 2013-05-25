dcpu-lisp
=========

dcpu-lisp is a simple lisp programming language for the DCPU-16 processor.

  prog := stmts </br> 
	stmts := stmts stmt </br>  
		| stmt  </br>
	stmt := '( 'value terms ') </br>  
		| '( 'value ')  </br>
	terms := terms term  </br>
		| term </br>
  term := stmt | 'symbol | 'number | 'value | 'string | '( ') </br>
