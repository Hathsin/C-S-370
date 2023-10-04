/*                 Small LEX routine which returns two formal tokens (INTEGER and VARIABLE)
                   along with single string elements like '+'.
 
                    This LEX definition is the companion to the docalc.y YACC routine which
                   is a simple calculator

                    Shaun Cooper
                    January 2015

                    Added verbose option to toggle statements of found characters and type.
                    Included paraenthesis to token list and fixed minor spelling mistakes.
                    
                    Benjamin Widner
                    August 2023
                    
*/
%{

int verbose = 0; //toggle the data stream
int mydebug=1;
#include "y.tab.h"
%}


%%

[a-z]		{if (mydebug) 
                if (verbose) fprintf(stderr,"Letter found\n"); 

             yylval=*yytext-'a'; 
             return(VARIABLE);
            }

[0-9][0-9]*	{if (mydebug) 
                if (verbose) fprintf(stderr,"Digit found\n"); 

             yylval=atoi((const char *)yytext); 
             return(INTEGER);
            }

[ \t]		{if (mydebug) 
                if (verbose) fprintf(stderr,"Whitespace found\n");
            }

[=\-+*/%&|()] 	{ if (mydebug)   //added parenthesis to possible tokens
                    if (verbose) fprintf(stderr,"return a token %c\n",*yytext); 
                 return (*yytext);
                }

\n 		{ if (mydebug) 
            if (verbose) fprintf(stderr,"carriage return %c\n",*yytext); 
         return (*yytext);
         }

%%

//PRE 
//POST
int yywrap(void)
{ return 1;}


