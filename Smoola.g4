// Define a grammar called Smoola
grammar Smoola;

@members{
  void print(String str){
    System.out.println(str);
  }
}

prog:	(main_class)(class_def)* ;

/*main class and main method*/
main_class : 'class' ID '{' (main_method)  '}';

main_method : ('def')('main()')(COLON) INT '{' (main_method_body) '}';     ////// not completed

// main method can't have any function calls rather that writeln because those are expressions
// and we don't have any variables in main class and main method 
main_method_body : (writeln)* ('return') (statement);  

// this is a expression
// are method names the same is identifier names ?
function_call : 'new' (ID)(LPAR)'.'(ID)(LPAR)(function_arguments)(RPAR)(SEMICOLON) 
				| 'this.' (ID)(LPAR)(function_arguments)(RPAR)(SEMICOLON);

function_arguments : (variable (',') )* variable | ;

/*class*/

class_def:
       (('Class') ID '{' (class_body) '}') {print('ClassDec: + getText());} 
	   | (('Class') ID ('extends') ID '{' (class_body) + ('\n')* '}') ;

class_body:
       (primitivevardef)* (method_block)* ;  

primitivetype:
       ('int') | ('boolean') | ('string') | arraytype {print("type");};

arraytype : ('int') (LBRAC) (RBRAC);

array_init : 
		('new') 'int' ID '[' INT ']';

/* IF */
stm_if: 'if' LPAR expr_tot RPAR 'then' (statement)
		| 'if' LPAR expr_tot RPAR 'then' (statement) 'else' (statement); 

stm_while : ('while') (LPAR) (expr_tot) (RPAR) '{' (substatement)+ '}' {print('LOOP : While');} ;

stm_assign: (ID ASSIGN {print("assignment");} expr_tot ) SEMICOLON; 

stm_vardef : 'var' (ID) COLON (primitivetype | ID) ;
// ID for class type

statement: stm_vardef SEMICOLON 
		   | stm_assign SEMICOLON 
		   | stm_while 
		   | writeln SEMICOLON
		   stm_if;

expr: expr_assign;

expr_assign: expr_or (ASSIGN) expr_assign | expr_or;

expr_or: expr_and expr_or_tmp;

expr_or_tmp: (LOGICALOR) expr_and expr_or_tmp| ;

expr_and: expr_eq expr_and_tmp;

expr_and_tmp: (LOGICALAND) expr_eq expr_and_tmp | ;

expr_eq: expr_cmp expr_eq_tmp;

expr_eq_tmp: (EQUAL | NOTEQUAL) expr_cmp expr_eq_tmp | ;

expr_cmp: expr_add expr_cmp_tmp ;

expr_cmp_tmp: ('<' | '>') expr_add expr_cmp_tmp| ;

expr_add: expr_mult expr_add_tmp;

expr_add_tmp : ('+' | '-') expr_mult expr_add_tmp | ;

expr_mult: expr_un expr_mult_tmp;

expr_mult_tmp: ('*' | '/') expr_un expr_mult_tmp | ;

expr_un : ('!' | '-') expr_un | expr_arr ;

expr_arr: expr_other expr_arr_tmp ;

expr_arr_tmp: '[' expr ']' expr_arr_tmp | ;

expr_tot: (CONST_INT | CONST_STR | ID | CONST_BOOLEAN | '(' expr ')');
																															
/* metod  */
function:
		ID '(' ((variable ',')* variable |) ')'
		;	

return_val : statement;  // in this phase we do not check the statement type after return
  
method_declare:
		('def') ID '(' (vardef ',')* (vardef) ')' |  ID '(' ')'
		;		
vardef:
		ID ':' primitivetype
		;		
method_block:
            ('def') ID '(' (vardef ',')* (vardef |) ')' ':' primitivetype  '{' (NEWLINE)* ( statement ) ('return')(return_val) '}'; 

primitivevardef:			//type baraye vardef mitooneh name ye class dige bash && 
         ('var') ID (COLON) (primitivetype) (SEMICOLON)
       ;   

writeln : 'writeln' LPAR (expr_tot) RPAR; //// array

/* primitive types */   
variable: ID | CONST_INT | CONST_BOOLEAN | CONST_BOOLEAN |  ;

CONST_INT : [0-9]+;
CONST_STRING : '"' ' .*? ' '"';
CONST_BOOLEAN:  TRUE | FALSE ;

// KEYWORDS
BOOLEAN : 'boolean';
STRING : 'string';
INT : 'int';
CLASS : 'class';
DEF : 'def';
THEN : 'then';
IF : 'if';
WRITELN : 'writeln';
EXTENDS : 'extends';
VAR : 'var';
THIS : 'this';
TRUE : 'true';
FALSE : 'false';
WHILE : 'while';
ELSE : 'else';
RETURN : 'return';
NEW : 'new';


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
SEMICOLON : ';' ;
COLON : ':';
LOGICALAND : '&&';
LOGICALOR : '||';
COMMENT: '#'(~[\r\n])* -> skip;
NEWLINE: ('\n')+ -> skip;   
WS:
    	[ \t] -> skip
;





