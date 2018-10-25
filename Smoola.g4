// Define a grammar called Smoola
grammar Smoola;

@members{
  void print(String str){
    System.out.println(str);
  }
}

prog:	(main_class)(class_stm)* ;

main_class : 'class' ID '{' ( main_method)  '}';

main_method : ('def')('main()')(COLON) INT '{' (main_method_body) '}';

main_method_body : (function_call |statement | primitivevardef)* ('return')(return_val); // functoin_call??

function_call_stm : 'new' (ID)(LPAR)'.'(METHODNAME)(LPAR)(function_arguments)(RPAR)(SEMICOLON);

function_arguments : (ID(','))*ID | ;

class_stm:
       (('Class') ID '{' (class_body) + ('\n')* '}') {print('ClassDec: + getText());} | (('Class') ID ('extends') ID '{' (class_body) + ('\n')* '}') ;

class_body:
       (primitivevardef)* (method_block)* ;  
      
primitivetype:
       ('int') | ('boolean') | ('string')| CLASS {print("type");};

arraytype : ('int') (LBRAC) (RBRAC);

if_stm: 'if' '(' expr ')' 'then' (condition_block1) | 'if' '(' expr ')' 'then' (condition_block1) 'else' (condition_block2); 


condition_block1 : ('{' (statement)+ '}') 
      {print("condition block");};

condition_block2 : statement
      {print("condition block");};      

expr : boolean_expr | (expr) ; // TODO complete this part

boolean_term : ((ID | STRING | INT) (EQUAL | NOTEQUAL) (ID | STRING | INT )) | (INT) | (ID) ;
boolean_expression : (boolean_term) | (boolean_expression (LOGICALAND) boolean_term) | (boolean_expression (LOGICALOR) boolean_term) | ('!')boolean_term;

statement : (( (assignment)  | if_stm | while_stm))*; 
//inja faghat assign mikonad?? kar e dige nadareh?

assignment: (ID ASSIGN {print("assignment");} ( operation | array_init | ID | STRING | BOOLEAN | INT)); 
																																

array_init : 
		('new') 'int' ID '[' INT ']';

while_stm : ('while') (LPAR) (boolean_expression) (RPAR) '{' (statement)+ '}' {print('LOOP : While');} ;


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
            ('def') ID '(' (vardef ',')* (vardef |) ')' ':' primitivetype  '{' (NEWLINE)* ( statement | while_stm) ('return')(return_val) '}'; 


primitivevardef:			//type baraye vardef mitooneh name ye class dige bash && 
         ('var') ID (COLON) (primitivetype) (SEMICOLON)
       ;   

writeln : 'writeln' LPAR (STRING | INT | ID | function_call) RPAR SEMICOLON  ; /////array


/* primitive types */   
INT : [0-9]+;
STRING : '"' ' .*? ' '"';
BOOLEAN:  TRUE | FALSE ;
TRUE : 'true';
FALSE : 'false';

/* non-primitive types */
CLASS : 'class';

ID  : [a-zA-Z-][a-zA-Z0-9-]* {print("ID "+getText());};

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
SEMICOLON : ';' -> skip;
COLON : ':';
LOGICALAND : '&&';
LOGICALOR : '||';
COMMENT: '#'(~[\r\n])* -> skip;
NEWLINE: ('\n')+ -> skip;   
WS:
    	[ \t] -> skip
;





