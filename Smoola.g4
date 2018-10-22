// Define a grammar called Smoola
grammar Smoola;
prog :	(expr NEWLINE)* ;
expr:
	(Operation|type|ID)*
	;
type:
       ('int') | ('char') |('boolean')|('Class')|{print("type");};	//|('string')
Operation : ('*') | ('+') | ('/') | ('-') | ('&&') | ('||') | ('==') | ('=') | ('<>') | ('!') |{print("operator");};	
INT : [0-9]+;

ELSE : 'else' ID {System.out.println("else");};
COMMENT: '#'(~[\r\n])* -> skip;
ID  : [a-zA-Z-][a-zA-Z0-9-]* {System.out.println("ID "+getText());};
WS  : [ \t\r\n] -> skip ;
NEWLINE : [\r\n]+ ;
//string: '"' '\'' .*? '\'' '"' {print("String"); };


