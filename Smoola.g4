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
		
;



class_block:
       ('Class') ID '{' (inner) + ('\n')* '}' ;

vardef:			//type baraye vardef mitooneh name ye class dige bash && 
        ID ':' type
       ;          
var:
	'var' vardef ';'
	;      

inner:
       (if_block | method_block | statement | while_block | var | COMMENT)+ ;  
      
type:
       ('int') | ('char') |('boolean')|('string')| ('Class')|{print("type");};


///*********IF********************

if_block: 'if' (expr) 'then' (condition_block) | 'if' (expr)  (condition_block) 'else' (condition_block); // if dovom 'then' nemikhaaad?? 


condition_block : ('{' (statement)+ '}') | statement
      {print("condition block");};

///*******************************


//expr :

statement : (( (assignment ';')  | if_block | var | COMMENT ) NEWLINE)*; /// Akhar har assignment ';' mikhad
//inja faghat assign mikonad?? kar e dige nadareh?

assignment: (ID ASSIGN {print("assignment");} ( operation | new_form | ID '.' function| ID | STRING | BOOLEAN | CHARACTER | ARITHNUM )); //ARITHNUM ,operation??
																																	///added BOOLEAN 

//ID '.' function  --->  e.g: x=s.constructor();
																																	 
//****for new class var ,...******************
new_form:
		array_init | class_new
		;
///e.g:  s= new Regtangle();
class_new:
		('new') ID '(' ')' 
		;
	
array_init :
		('new') type ID '[' INT ']'
		;

///********************************

while_block : ('while') '(' ID LPAR RPAR  INT ')' '{' (statement)+ '}' ; ///while_block changed!!


body_block:
		(ID)*;

///****method**********************	

variable:
		ID | INT | BOOLEAN
		;	

function:
		ID '(' ((variable ',')* variable |) ')'
		;	

return_val:
		('0' | operation_expr | ID '.' function) ';'
		;     
operation:
		ADD | SUB | MULT | DIV 
		;		  
operation_expr:
		ID (operation ID)*
		;
method_declare:
		('def') ID '(' (vardef ',')* (vardef) ')' |  ID '(' ')'
		;		
method_block:
            method_declare ':' type  '{' (NEWLINE)* ( statement | while_block) + 'return' return_val '}'
            ; 

///********************************



writeln : 'writeln' LPAR (STRING | INT | ID) RPAR SEMICOLON  ; /////array


NEWLINE: ('\n')+;   
COMMENT: '#'(~[\r\n])* -> skip;     
INT : [0-9]+;
ID  : [a-zA-Z-][a-zA-Z0-9-]* {System.out.println("ID "+getText());};
BOOLEAN: 'true' | 'false' ;
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





