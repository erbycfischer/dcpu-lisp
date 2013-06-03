dcpu-lisp
=========

dcpu-lisp is a simple lisp programming language for the DCPU-16 processor.

	<program>       -> <forms> | ϵ
	<forms>         -> <forms> <form>
	                 | <form>
	<form>          -> <definition>
	                 | <expression>
	<definitions>   -> <definitions> <definition>
	                 | <definition>
	<definition>    -> (define 'ID <expression>)
	                 | (defun 'ID <formals> <body>)
	<variables>     -> <variables> 'ID
	                 | 'ID
	<body>          -> <definitions> <expressions>
	                 | <expressions>
	<expressions>   -> <expressions> <expression>
	                 | <expression>
	<expression>    -> <constant>
	                 | 'ID
	                 | (lambda <formals> <body>)
	                 | (if <expression> <expression> <expression>)
	                 | (when <expression> <expression>)
	                 | (set! 'ID <expression>)
	                 | (malloc <expression> <expression>)
	                 | (free <expression>)
	                 | (while <expression> <expression>)
	                 | (<expressions>)
	<constant>      -> 'BOOL | 'NUM | 'CHAR | 'STR
	<formals>       -> (<variables>) | ()
