// Define a grammar called Smoola
grammar Smoola;

@members{
  void print(String str){
    System.out.println(str);
  }
}

prog:	(COMMENT)* (main_class)(class_block)* (COMMENT)* ;

main_class : 'class' ID '{' (main_method) '}';

main_method : ('def')('main()')(COLON) INT '{' (main_body) '}';


main_body : // return statement and function call 



class_block:
       ('Class') ID '{' (inner) + ('\n')* '}' ;
var:
	'var' ID ':' type ';'
	;      

inner:
       (if_block | method_block | body_block | var)+ ;  
type:
       ('int') | ('char') |('boolean')|('string')| ('Class')|{print("type");};

if_block: 'if' (expr) 'then' (condition_block) | 'if' (expr) (condition_block) 'else' (condition_block);

condition_block : ('{' (statement)+ '}') | statement
      {print("condition block");};

//expr :

statement : (( assignment  | if_block ) NEWLINE)*;


assignment: (ID ASSIGN {print("assignment");} ( operation | array_init | ID | STRING | CHARACTER | ARITHNUM | assignment));

//operation : 


while_block : 'while' LPAR expr RPAR '{' (statement)+ '}' ;


body_block:
		(ID)*;

return_val:
		ID
		;       

method_block:
            ('def') ID '(' (vardef ',')* (vardef) ')' ':' type  '{' ('\n') ( if_block | body_block ) + 'return' return_val '}';   
vardef:
         type ID ////parameter of argumant function
       ;   

writeln : 'writeln' LPAR (STRING | INT | ID) RPAR SEMICOLON  ; /////array


NEWLINE: ('\n')+;   
COMMENT: '#'(~[\r\n])* -> skip;     
INT : [0-9]+;
ID  : [a-zA-Z-][a-zA-Z0-9-]* {System.out.println("ID "+getText());};
EQUAL: '==';
NOTEQUAL: '<>';
LT: '<';
GT: '>';
ADD: '+';
SUB: '-';
MULT: '*';
DIV: '/';
ASSIGN:'=';
LBRAC: '[';
RBRAC: ']';
RPAR : ')';
LPAR : '(';
STRING : '"' ' .*? ' '"';
SEMICOLON : ';';
COLON : ':';
LOGICALAND : '&&';
LOGICALOR : '||';
WS:
    	[ \t] -> skip
;





