// Define a grammar called Smoola
grammar Smoola;
prog:	(expr NEWLINE)* ;
expr:	ID
    |	INT
    |	type

    ;
type:
       ('int') | ('char') |('boolean')|('string')| ('Class')|{System.out.println("type");};	//
//Operation : ('*') | ('+') | ('/') | ('-') | ('&&') | ('||') | ('==') | ('=') | ('<>') | ('!') |{System.out.println("operator");};	
INT : [0-9]+;

ELSE : 'else' ID {System.out.println("else");};
COMMENT: '#'(~[\r\n])* -> skip; 
ID  : [a-zA-Z-][a-zA-Z0-9-]* {System.out.println("ID "+getText());};
WS  : [ \t\r\n] -> skip ;
NEWLINE : [\r\n]+ ;
//string: '"' '\'' .*? '\'' '"' {print("String"); };


