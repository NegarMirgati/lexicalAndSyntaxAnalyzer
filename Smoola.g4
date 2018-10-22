// Define a grammar called Smoola
grammar Smoola;
r : 'else' ID {System.out.println("else");};
ID  : [a-zA-Z-][a-zA-Z0-9-]* {System.out.println("ID "+getText());};
WS  : [ \t\r\n] -> skip ;
COMMENT: '#'(~[\r\n])* -> skip;
