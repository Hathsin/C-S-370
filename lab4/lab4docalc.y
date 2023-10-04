%{

/*
 *			**** CALC **** 
 *
 * This routine will function like a desk calculator
 * There are 26 integer registers, named 'a' thru 'z'
 *
 */

/* This calculator depends on a LEX description which outputs either VARIABLE or INTEGER.
   The return type via yylval is integer 

   When we need to make yylval more complicated, we need to define a pointer type for yylval 
   and to instruct YACC to use a new type so that we can pass back better values
 
   The registers are based on 0, so we substract 'a' from each single letter we get.

   based on context, we have YACC do the correct memmory look up or the storage depending
   on position

   Shaun Cooper
    January 2015

  		//problems  fix unary minus, fix parenthesis, add multiplication
   		//problems  make it so that verbose is on and off with an input argument instead of compiled in

   Unary minus rule fixed. Paraenthesis added to token table and additional rule added to complete 
   functionality. Multiplication rule added. Verbose variable/option added. Spelling/spacing adjusted

   Benjamin Widner
   August 2023

   ///////////////////////////////////////////

   Vairable creation redesigned. variable must be defined properly then assigned a value. Max for number
   of variables adjusted, is modifiable. Linenum output with errors. Now uses symbol table to store symbols
   and addresses. regs holds values. 

   Benjamin Widner
   September 2023

*/


	/* begin specs */
#include <stdio.h>
#include <ctype.h>
#include "symtable.h"

int yylex(); //returns token/variable/integer to be used in program
#define MAX 26
int verbose; //toggle the data stream
int regs[MAX];
int base, debugsw;
int ONEUP = 0;
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

%start P

%union { //allows tokens to be defined as int and char *
	int num;
	char * string;
}


%token <num>INTEGER
%token <string>VARIABLE
%token T_INT

%type <num> expr


%left '|'
%left '&'
%left '+' '-'
%left '*' '/' '%'
%left UMINUS


%%	/* end specs, begin rules */

P		: DECLS list  //decleration of variable
		;
DECLS	: DECLS DECL  //allows multiple declerations
		| /* empty */
		;

DECL	: T_INT VARIABLE ';' '\n' //format must be int x; for some variable x (whitespace not nesessary)
		{
			if(Search($2) == 1){ //checks if variable exists in table
				printf("symbol %s already in table on line %d.\n",$2,linenum);
			}
			else{
				if(ONEUP < MAX){ // ensures there is room in table
					Insert($2, ONEUP);
					ONEUP++;
					Display();
				}
				else{
					printf("table is full\n");
				}
			}
		}
		;//end DECL

list	:	/* empty */  //error checker/will print error if found
	|	list stat '\n'
	|	list error '\n'
			{ yyerrok; }
	;

stat	:	expr //evaluates expression
			{ fprintf(stderr,"the answer is %d\n", $1); }
	|	VARIABLE '=' expr //assigns variable a value
			{
				if(Search($1) == 0){
					printf("variable %s not found at line %d\n",$1,linenum);
				}
				else{
					regs[FetchAddress($1)] = $3;
				}
			}

	;

expr	:	'(' expr ')' //evaluates expressions using PEMDAS rules
			{ $$ = $2; }
	|	expr '(' expr ')' //added additional rule for parenthesis
			{ $$ = $1 * ($3); } 
	|	expr '-' expr
			{ $$ = $1 - $3; }
	|	expr '+' expr
			{ $$ = $1 + $3; }
	|	expr '/' expr
			{ $$ = $1 / $3; }
	|	expr '%' expr
			{ $$ = $1 % $3; }
	|	expr '&' expr
			{ $$ = $1 & $3; }
	|	expr '|' expr
			{ $$ = $1 | $3; }
	|	expr '*' expr  //added functionality for multiplication
			{ $$ = $1 * $3; }
	|	'-' expr	%prec UMINUS  //removed preceeding expr, making this different from subtraction
			{ $$ = -$2; }
	|	VARIABLE
			{ //when vaiable is used, makes sure it is in the table and
				if(Search($1) == 0){
					printf("variable not found at line %d\n", linenum);
					$$ = 0;
				}
				else{
					$$ = regs[FetchAddress($1)]; 
					if (verbose) fprintf(stderr,"found a variable value =%d\n",$1); 
				} 
			}
	|	INTEGER {$$=$1; if (verbose) fprintf(stderr,"found an integer\n");}
	;//end of expr



%%	/* end of rules, start of program */

//PRE valid math equation or variable assignment
//POST
int main()
{ yyparse();
}
