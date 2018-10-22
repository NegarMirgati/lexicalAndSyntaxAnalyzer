// Define a grammar called Smoola
grammar Smoola;
prog:	(ID)* ;
ELSE : 'else' ID {System.out.println("else");};
COMMENT: '#'(~[\r\n])* -> skip;
ID  : [a-zA-Z-][a-zA-Z0-9-]* {System.out.println("ID "+getText());};
WS  : [ \t\r\n] -> skip ;


