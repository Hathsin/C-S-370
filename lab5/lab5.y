%{

/*
	Defines a basic grammer for a program, implements variable usage, parameters,
	statements, and math and logic comparisons. Checks that the given code is syntatically
	correct and if not, returns error with line number. Additionally can print process
	of 'reading' through the code.

   Benjamin Widner
   September 2023

*/


	/* begin specs */
#include <stdio.h>
#include <ctype.h>

int yylex(); //returns token/variable/integer to be used in program
int debugsw;
extern int linenum;

//PRE 
//POST
void yyerror (s)  /* Called by yyparse on error */
     char *s;
{
  printf ("%s on line %d\n",s,linenum+1);
}


%}
/*  defines the start symbol, what values come back from LEX and how the operators are associated  */

%start Program

%union { //allows tokens to be defined as int and char *
	int value;
	char * string;
}


%token <value>T_NUM
%token <string>T_ID T_STRING
%token T_INT
%token T_BOOLEAN T_VOID T_BEGIN T_END T_RETURN T_AND T_OR T_LE T_GE T_EQ T_NE T_TRUE T_FALSE T_NOT
%token T_IF T_ELSE T_THEN T_ENDIF T_WRITE T_WHILE T_DO T_READ



%left '|'
%left '&'
%left '+' '-'
%left '*' '/' '%'
%left '<' '>' '='
%left UMINUS


%%	/* end specs, begin rules */

Program 		: DeclarationList  //begins program
				;

DeclarationList : Declaration   //allows unbounded Declarations
				| Declaration DeclarationList
				;

Declaration 	: VarDeclaration //Declarations are var or function
				| FunDeclaration 
				;

VarDeclaration 	: TypeSpecifier VarList ';'  //var requires type, id, and ';'
				;

VarList 		: T_ID   //name and value checked here for var
				{
					printf("VARLIS ID NAME IS %s\n", $1);  //prints to user
				}
				| T_ID '[' T_NUM ']'
				{
					printf("VARLIS ID NAME IS %s\n", $1);  //prints to user
				}
				| T_ID ',' VarList 
				{
					printf("VARLIS ID NAME IS %s\n", $1);  //prints to user
				}
				| T_ID '[' T_NUM ']' ',' VarList
				{
					printf("VARLIS ID NAME IS %s\n", $1);  //prints to user
				}
				;

TypeSpecifier 	: T_INT   //types allowed in code
				| T_VOID
				| T_BOOLEAN
				;

FunDeclaration 	: TypeSpecifier T_ID '(' Params ')' CompoundStmt //function must have type, name, parameters, then enclosed statement
				{
					printf("FUNDEC ID NAME is %s\n", $2);  //prints string
				}
				;

Params 			: T_VOID //parameters can be none or unbounded
				| ParamList
				;

ParamList 		: Param ParamList //implements unbounded parameters
				| ',' Param 
				;

Param 			: TypeSpecifier T_ID   //checks type, name and if array or not
				{
					printf("PARAM T_ID value %s\n", $2);  //prints to user
				}
				| TypeSpecifier T_ID '[' ']'
				{
					printf("PARAM T_ID array value %s\n", $2);  //prints to user
				}
				;

CompoundStmt 	: T_BEGIN LocalDeclarations StatementList T_END //must have begin and end, with statements inbetween(statements can be empty)
				;

LocalDeclarations 	: /* empty */   //unbounded VarDeclaration
					| VarDeclaration LocalDeclarations
					;

StatementList 	: Statement StatementList //unbounded Statements
				|/*mty*/
				;

Statement 		: ExpressionStmt  //all types of statements valid
				| CompoundStmt
				| SelectionStmt
				| IterationStmt
				| AssignmentStmt
				| ReturnStmt
				| ReadStmt
				| WriteStmt
				;

ExpressionStmt 	: Expression ';' //statement to be evaluated
				| ';'
				;

SelectionStmt 	: T_IF Expression T_THEN Statement SelectionStmt //if then execution
				| T_ENDIF
				| T_ELSE Statement SelectionStmt
				;

IterationStmt 	: T_WHILE Expression T_DO Statement //loop
				;

ReturnStmt 		: T_RETURN ';'  //return function
				| T_RETURN Expression ';'
				;

ReadStmt 		: T_READ Var ';' //read in var
		 		;

WriteStmt 		: T_WRITE Expression ';' //write something
				| T_WRITE T_STRING ';' 
				{
					printf("write string with value: %s\n", $2);  //prints string
				}
				;

AssignmentStmt 	: Var '=' SimpleExpression ';' // assign var to Expression
				;

Expression 		: SimpleExpression //keeps grammar unambigious
				;

Var 			: T_ID //holds value or array value
				{
					printf("Inside a var with value %s\n", $1);  //prints string
				}
				| T_ID '[' Expression ']'
				{
					printf("Inside a var array with value %s\n", $1);  //prints string
				}
				;

SimpleExpression 	: AdditiveExpression //AdditiveExpression unbounded when combined with relop
                	| SimpleExpression Relop AdditiveExpression 
                  	;  

Relop 			: T_LE //comparison operator
				| '<' 
				| '>' 
				| T_GE 
				| T_EQ 
				| T_NE 
				; 

AdditiveExpression 	: Term //unbounded term when combined with addop
                    | AdditiveExpression Addop Term 
                    ; 

Addop 			: '+' //simple addition or subtraction
				| '-'
				; 

Term 			: Factor //unbounded Factor when combined with multop
				| Term Multop Factor 
				; 

Multop 			: '*' //multiplication, division, and operator, and or operator
				| '/' 
				| T_AND 
				| T_OR 
				; 

Factor 			: '(' Expression ')'  //types of acceptable factors
				| T_NUM 
				| Var 
				| Call 
				| T_TRUE Factor
				| T_FALSE Factor
				| T_NOT Factor
				;

Call 			: T_ID '(' Args ')' //calls function with given args
				{
					printf("CALL ID name is %s\n", $1);  //prints string
				}
				;
	
Args 			: ArgList //args can be none or unbounded
				| /*empty*/
				;
	
ArgList 		: Expression //implements unbounded args
				| Expression ',' ArgList
				;

%%	/* end of rules, start of program */

//PRE valid math equation or variable assignment
//POST
int main()
{ yyparse();
}
