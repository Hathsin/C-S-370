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

*/


	/* begin specs */
#include <stdio.h>
#include <ctype.h>

int yylex(); //returns token/variable/integer to be used in program

int verbose; //toggle the data stream
int regs[26];
int base, debugsw;

//PRE 
//POST
void yyerror (s)  /* Called by yyparse on error */
     char *s;
{
  printf ("%s\n", s);
}


%}
/*  defines the start symbol, what values come back from LEX and how the operators are associated  */

%start list

%token INTEGER
%token  VARIABLE


%left '|'
%left '&'
%left '+' '-'
%left '*' '/' '%'
%left UMINUS


%%	/* end specs, begin rules */

list	:	/* empty */
	|	list stat '\n'
	|	list error '\n'
			{ yyerrok; }
	;

stat	:	expr
			{ fprintf(stderr,"the answer is %d\n", $1); }
	|	VARIABLE '=' expr
			{ regs[$1] = $3; }
	;

expr	:	'(' expr ')'
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
			{ $$ = regs[$1]; if (verbose) fprintf(stderr,"found a variable value =%d\n",$1); }
	|	INTEGER {$$=$1; if (verbose) fprintf(stderr,"found an integer\n");}
	;



%%	/* end of rules, start of program */

//PRE valid math equation or variable assignment
//POST
int main()
{ yyparse();
}
