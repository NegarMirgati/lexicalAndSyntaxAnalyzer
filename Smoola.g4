// Define a grammar called Smoola
grammar Smoola;

@members{
  void print(String str){
    System.out.println(str);
  }
}

prog: (main_class)(class_def)* ;

/*main class and main method*/
main_class : 'class' (classname = ID) { print("ClassDec:" + $classname.text); } '{' (main_method) '}';

main_method : ('def')('main') {print("MethodDec:main");} (LPAR) (RPAR) (COLON) INT '{' (main_method_body) '}' ; 

// main method can't have any function calls rather that writeln because those are expressions
// and we don't have any variables in main class and main method 
main_method_body : ((writeln | function_call) SEMICOLON)* ('return') (expr_tot) SEMICOLON;  

/*class*/
class_def:
       (('class') classname = ID { print("ClassDec:" + $classname.text); } '{' (class_body) '}') 
	   | (('class') classname = ID ('extends') fatherclass = ID { print("ClassDec:" + $classname.text + "," + $fatherclass.text); } '{' (class_body) '}') ;

class_body:
       (stm_vardef)* (method_block)* ;  

method_block:
            ('def')(methodname = (ID | 'main')){System.out.printf("MethodDec:" + $methodname.text);} 
			'(' (({System.out.printf(",");} (funcvardef',')*  funcvardefprime) 
			 | ){print("");}  ')' ':' (primitivetype | arraytype | ID) '{'(statement)* ('return')(return_val) SEMICOLON '}';
			

funcvardef:
		argname = ID  {System.out.printf($argname.text + ",");} ':'
		(   primitivetype
			| arraytype  
			|  ID  ) 
		;	
funcvardefprime:
		argname = ID  {System.out.printf($argname.text);} ':'
		(   primitivetype
			| arraytype  
			|  ID  ) 
		;	


// this is a expression
function_call : func_call | (ID)('.')('length');
func_call : (class_object_init) '.' (ID | 'main') (LPAR)(function_arguments)(RPAR)
				| 'this.' (ID)(LPAR)(function_arguments)(RPAR)
				| (ID) ('.')(ID) (LPAR)(function_arguments)(RPAR); 


function_arguments : (expr_tot (',') )* expr_tot | ;

primitivetype:  ('int') | ('boolean') | ('string') ;

array_init : ('new') 'int' ('[') expr_tot (']');   // expr_tot return value must be an int, will be checked in next phases.

class_object_initprime : ('new') ID LPAR RPAR ;
class_object_init :  '('class_object_init')' | class_object_initprime ;

arraytype : ('int') (LBRAC) (RBRAC);

statement_for_if : stm_vardef 
		   | stm_assign SEMICOLON
		   | stm_while 
		   | writeln (SEMICOLON)
		   | function_call (SEMICOLON)
		   | '{' statement '}';

statement: stm_vardef 
		   | stm_assign SEMICOLON
		   | stm_while 
		   | writeln (SEMICOLON)
		   | stm_if
		   | stm_ifelse
		   | function_call (SEMICOLON)
		   | '{' statement '}';	

/* IF */
stm_if: 'if' {print("Conditional:if");} LPAR expr_tot RPAR 
		'then' ((statement) | '{' statement+ '}') ;
stm_ifelse : 'if' {print("Conditional:if");} LPAR expr_tot RPAR  'then' 
			((statement_for_if | stm_ifelse) | '{' (statement_for_if | stm_ifelse)+ '}') 'else' {print("Conditional:else");} ( statement | '{' (statement)+ '}')  ; 

stm_while : ('while') { print("LOOP:While"); }  (LPAR) (expr_tot) (RPAR) '{' (statement)+ '}' ;

stm_assign: (expr_tot) ASSIGN {print("Operator:=");} expr_tot; 

// int, boolean, string, arraytype, class-type
stm_vardef : 'var' (name = ID) {System.out.printf("VarDec:" + $name.text + ",");} COLON 
			( ('int') {print("int");}
			 | ('boolean') {print("boolean");}
			 | ('string') {print("string");}
			 | arraytype {print("int[]");} | 
			 classname = ID {print($classname.text);}) SEMICOLON;


expr_tot : assign_op;

assign_op : or_op | (or_op ASSIGN {print("Operator:=");} assign_op);

or_op: and_op | (and_op LOGICALOR {print("Operator:||");} or_op);

and_op: (equality_op LOGICALAND {print("Operator:&&");} and_op) | equality_op;

equality_op: (comparison_op (EQUAL {print("Operator:==");} | NOTEQUAL {print("Operator:<>");}) equality_op) | comparison_op;

comparison_op: (add_op (GT {print("Operator:>");} | LT {print("Operator:<");}) comparison_op) | add_op;

add_op: (mult_op (ADD {print("Operator:+");} | SUB {print("Operator:-");}) add_op) | mult_op;

mult_op: (unary_op (MULT {print("Operator:*");} | DIV {print("Operator:/");}) mult_op) | unary_op;

unary_op: (operands(NOT {print("Operator:!");}  | (SUB) {print("Operator:-");}) unary_op) | operands;

operands: ( LPAR (expr_tot ) RPAR) 
	      | (ID (LBRAC (expr_tot | ID ) RBRAC))
 	      | CONST_INT 
		  | CONST_STR 
		  | CONST_BOOLEAN 
		  | function_call 
		  | class_object_init 
		  | array_init 
		  | ID;

																															
return_val : expr_tot;  // in this phase we do not check the statement type after return

// this is a statement, doesn't have return value  	 
writeln : 'writeln' LPAR (expr_tot) RPAR; 

CONST_INT : [0-9]+;
CONST_STR : '"' ~'\n'*? '"';
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

ID  : [a-zA-Z_][a-zA-Z0-9_]*;

EQUAL: '==' ;/* { print("Operator:=="); }; */
NOTEQUAL: '<>';// {print("Operator:<>"); };  */
LT: '<' ;/*  //{print("Operator:<"); }; */
GT: '>' ; /* //{print("Operator:>"); }; */
ADD: '+'; /*  //{print("Operator:+"); }; */
SUB: '-' ; /* //{print("Operator:-"); }; */
MULT: '*' ; /*  //{print("Operator:*"); }; */
DIV: '/'  ;/* //{print("Operator:/"); };  */
ASSIGN:'=' ; /* // {print("Operator:="); }; */
NOT: '!'  ; /* //{print("Operator:!"); }; */
LBRAC: '[' ;
RBRAC: ']';
RPAR : ')';
LPAR : '(';
SEMICOLON : ';' ;
COLON : ':';
LOGICALAND : '&&'; /*{print("Operator:&&"); }; */
LOGICALOR : '||' ; /* {print("Operator:||"); }; */
COMMENT: '#'(~[\r\n])* -> skip;
NEWLINE: ('\n')+ -> skip;
NEWLINEPRIME : ('\r\n')+ -> skip ;   
WS: [ \t\r] -> skip ;