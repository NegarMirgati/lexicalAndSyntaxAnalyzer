// Define a grammar called Smoola
grammar Smoola;

prog:	(COMMENT)* (class_block)* (COMMENT)* ;

COMMENT: '#'(~[\r\n])* -> skip; 

class_block:
       ('Class') ID '{' (inner)+ ('\n')* '}';
var:
	'var' ID ':' type ';'
	;      

inner:
       (if_block | method_block | body_block | var)+ ;  
type:
       ('int') | ('char') |('boolean')|('string')| ('Class')|{System.out.println("type");};

if_block:
		'if'
       ;
elseif_block:
		'else'
		;

body_block:
		(ID)*
       ;
return_val:
		ID
		;       

method_block:
            ('def') ID '(' (vardef ',')* (vardef) ')' ':' type  '{' ('\n') ( if_block | body_block )+ 'return' return_val '}';   
vardef:
         type ID ////parameter of argumant function
       ;            







//Operation : ('*') | ('+') | ('/') | ('-') | ('&&') | ('||') | ('==') | ('=') | ('<>') | ('!') |{System.out.println("operator");};	
INT : [0-9]+;


ID  : [a-zA-Z-][a-zA-Z0-9-]* {System.out.println("ID "+getText());};
WS  : [ \t\r\n] -> skip ;




