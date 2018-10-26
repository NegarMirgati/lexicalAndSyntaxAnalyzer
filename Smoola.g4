// Define a grammar called Smoola
grammar Smoola;

@members{
  void print(String str){
    System.out.println(str);
  }
}

prog: (main_class)(class_def)* ;

/*main class and main method*/
main_class : 'class' ID '{' (main_method)  '}';

main_method : ('def')('main') (LPAR) (RPAR) (COLON) INT '{' (main_method_body) '}' {print("MethodDec:main");}; 

// main method can't have any function calls rather that writeln because those are expressions
// and we don't have any variables in main class and main method 
main_method_body : (writeln SEMICOLON)* ('return') (expr_tot)SEMICOLON;  

/*class*/
class_def:
       (('class') classname = ID '{' (class_body) '}') { print("ClassDec:" + $classname.text); } 
	   | (('class') classname = ID ('extends') fatherclass = ID '{' (class_body) '}') { print("ClassDec:" + $classname.text + "," + $fatherclass.text); }  ;

class_body:
       (stm_vardef)* (method_block)* ;  

method_block:
            ('def') methodname = ID '(' ((funcvardef ',')* (funcvardef |))  ')' ':' (primitivetype | arraytype | ID) '{'(statement)* ('return')(return_val) SEMICOLON '}'
			{print("MethodDec:" + $methodname.text);}; 

funcvardef:
		argname = ID ':' (primitivetype | arraytype | ID) { System.out.printf($argname.text + ",");}
		;	

// this is a expression
function_call : get_length;
get_length : func_call | (ID)('.')('length');
func_call : (class_object_init) '.' (ID) (LPAR)(function_arguments)(RPAR)
				| 'this.' (ID)(LPAR)(function_arguments)(RPAR)
				| (ID) ('.')(ID) (LPAR)(function_arguments)(RPAR); 


function_arguments : (expr_tot (',') )* expr_tot | ;

primitivetype:  ('int') | ('boolean') | ('string') {print("type");};

array_init : ('new') 'int' ('[') expr_tot (']');   // expr_tot return value must be an int, will be checked in next phases.

class_object_initprime : ('new') ID LPAR RPAR ;
class_object_init :  '('class_object_initprime')' | class_object_initprime ;

arraytype : ('int') (LBRAC) (RBRAC){print("type");};

statement: stm_vardef 
		   | stm_assign SEMICOLON 
		   | stm_while 
		   | writeln 
		   | stm_if
		   | '{' statement '}';

/* IF */
stm_if: 'if' LPAR expr_tot RPAR 'then' (statement) {print("Conditional:if");}
		| 'if' LPAR expr_tot RPAR {print("Conditional:if");} 'then' (statement) 'else' (statement) {print("Conditional:else");} ; 

stm_while : ('while') (LPAR) (expr_tot) (RPAR) '{' (statement)+ '}' { print("LOOP:While"); } ;

stm_assign: (ID ASSIGN {print("assignment");} expr_tot ); 

// int, boolean, string, arraytype, class-type
stm_vardef : 'var' (name = ID) {print("VarDec:" + $name.text + ",");} COLON (primitivetype | arraytype {print("int[]");} | classname = ID) SEMICOLON;


expr_tot : or_op;

or_op: and_op | (and_op LOGICALOR {print("'or' operator");} or_op);

and_op: (equality_op LOGICALAND {print("'and' operator");} and_op) | equality_op;

equality_op: (comparison_op (EQUAL {print("'==' operator");} | NOTEQUAL {print("'<>' operator");}) equality_op) | comparison_op;

comparison_op: ((add_op (GT {print("'>' operator");} | LT {print("'<' operator");}) comparison_op)) | add_op;

add_op: (mult_op (ADD {print("'+' operator");} | SUB {print("'-' operator");}) add_op) | mult_op;

mult_op: (unary_op (MULT {print("'*' operator");} | DIV {print("'/' operator");}) mult_op) | unary_op;

unary_op: (operands (NOT {print("'not' operator");}| SUB {print("'-' operator");}) unary_op) | operands;

operands: ( LPAR ( stm_assign | expr_tot ) RPAR) 
	      | (ID (LBRAC (expr_tot | ID ) RBRAC))
 	      | CONST_INT 
		  | CONST_STR 
		  | CONST_BOOLEAN 
		  | class_object_init 
		  | function_call 
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

ID  : [a-zA-Z-][a-zA-Z0-9-]*;

EQUAL: '==' { print("Operator:=="); };
NOTEQUAL: '<>' {print("Operator:<>"); }; 
LT: '<' {print("Operator:<"); };
GT: '>' {print("Operator:>"); };
ADD: '+' {print("Operator:+"); };
SUB: '-' {print("Operator:-"); };
MULT: '*' {print("Operator:*"); };
DIV: '/' {print("Operator:/"); }; 
ASSIGN:'=' {print("Operator:="); };
NOT: '!' {print("Operator:!"); };
// no need to print these.
LBRAC: '[' ;
RBRAC: ']';
RPAR : ')';
LPAR : '(';
SEMICOLON : ';' ;
COLON : ':';
LOGICALAND : '&&' {print("Operator:&&"); };
LOGICALOR : '||' {print("Operator:||"); };
COMMENT: '#'(~[\r\n])* -> skip;
NEWLINE: ('\n')+ -> skip;
NEWLINEPRIME : ('\r\n')+ -> skip ;   
WS: [ \t\r] -> skip ;