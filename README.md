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
	                 | (define 'ID <formals> <body>)
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
	                 | (if <expression> <expression>)
	                 | (set! 'ID <expression>)
	                 | <application>
	<constant>      -> 'BOOL | 'NUM | 'CHAR | 'STR
	<formals>       -> (<variables>) | ()
	<application>   -> (<expressions>)

	'ID 	=~ m/+|-|[a-zA-Z!$%&*/:<=>?~_^][\w!$%&*/:<=>?~^.+-]*/
	'BOOL	=~ m/^#t|^#f/
	'NUM	=~ m/^[-+]?[0-9]*\.?[0-9]+/
	'CHAR	=~ m/^#\newline|^#\space|^#\\./
	'STR 	=~ m/^\"[\"\\[^"\]]*\"/
