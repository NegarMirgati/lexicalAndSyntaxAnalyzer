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

main_method : ('def')('main') (LPAR) (RPAR) (COLON) INT '{' (main_method_body) '}';     ////// not completed

// main method can't have any function calls rather that writeln because those are expressions
// and we don't have any variables in main class and main method 
main_method_body : (writeln)* ('return') (statement);  

/*class*/
class_def:
       (('Class') ID '{' (class_body) '}') {print('ClassDec: + getText());} 
	   | (('Class') ID ('extends') ID '{' (class_body) + ('\n')* '}') ;

class_body:
       (stm_vardef)* (method_block)* ;  

method_block:
            ('def') ID '(' (funcvardef ',')* (funcvardef |) ')' ':' (primitivetype | arraytype | ID) '{'(statement)* ('return')(return_val) '}'; 

funcvardef:
		ID ':' (primitivetype | arraytype | ID )
		;	

// this is a expression
function_call : get_length;
get_length : func_call | (ID)('.')('length');
func_call : 'new' (ID) (LPAR) '.' (ID) (LPAR)(function_arguments)(RPAR)
				| 'this.' (ID)(LPAR)(function_arguments)(RPAR)
				| (ID) ('.')(ID) (LPAR)(function_arguments)(RPAR);


function_arguments : (expr (',') )* expr | ;

primitivetype:
       ('int') | ('boolean') | ('string') {print("type");};

array_init : 
		('new') 'int' ID '[' CONST_INT ']';

arraytype : ('int') (LBRAC) (RBRAC){print("type");};


/* IF */
stm_if: 'if' LPAR expr_tot RPAR 'then' (statement)
		| 'if' LPAR expr_tot RPAR 'then' (statement) 'else' (statement); 

stm_while : ('while') (LPAR) (expr_tot) (RPAR) '{' (substatement)+ '}' {print('LOOP : While');} ;

stm_assign: (ID ASSIGN {print("assignment");} expr_tot ) SEMICOLON; 

// int, boolean, string, arraytype, class-type
stm_vardef : 'var' (ID) COLON (primitivetype | arraytype | ID) ;


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

expr_arr: expr_tot expr_arr_tmp ;

expr_arr_tmp: '[' expr ']' expr_arr_tmp | ;

expr_tot: (CONST_INT | CONST_STR | ID | CONST_BOOLEAN | function_call | '(' expr ')');
																															
return_val : statement;  // in this phase we do not check the statement type after return
  	 
writeln : 'writeln' LPAR (expr_tot) RPAR; //// array

CONST_INT : [0-9]+;
CONST_STR : '"' ' .*? ' '"';
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
WS: [ \t] -> skip ;