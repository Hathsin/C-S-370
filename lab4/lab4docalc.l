/*             Small LEX routine which returns two formal tokens (INTEGER and VARIABLE)
               along with single string elements like '+'.
 
               This LEX definition is the companion to the docalc.y YACC routine which
               is a simple calculator

               Shaun Cooper
               January 2015

               Added verbose option to toggle statements of found characters and type.
               Included paraenthesis to token list and fixed minor spelling mistakes.
                    
               Benjamin Widner
               August 2023

               /////////////////////////////////////////////////////
               
               token for "int" added, increased options for variable names. ';' added.
               Line counter added.

               Benjamin Widner
               September 2023
                    
*/
%{

int verbose = 0; //toggle the data stream
int mydebug=1;
int linenum = 0;
#include "y.tab.h"
%}


%%

"int" { return (T_INT);} //int token creator

[a-zA-Z][a-zA-Z0-9_]* { //reads variable name, starts with char, then char, num, and _ 0 or more
                        if (mydebug) 
                        if (verbose) fprintf(stderr,"ID found %s\n",yytext); 
                        yylval.string=strdup(yytext); 
                        return(VARIABLE);
                     }

[0-9][0-9]*	{if (mydebug) //int reader, for any num any size
                if (verbose) fprintf(stderr,"Digit found\n"); 

             yylval.num=atoi((const char *)yytext); 
             return(INTEGER);
            }

[ \t]		{if (mydebug)  //ignores whitespace aside from newline
                if (verbose) fprintf(stderr,"Whitespace found\n");
            }

[=\-+*/%&|();] 	{ if (mydebug)   //additional tokens, (special symbols)
                    if (verbose) fprintf(stderr,"return a token %c\n",*yytext); 
                 return (*yytext);
                }

\n 		{ if (mydebug) //tracks new lines and helps with formatting
            if (verbose) fprintf(stderr,"carriage return %c\n",*yytext); 
            linenum++;
         return (*yytext);
         }

%%

//PRE 
//POST
int yywrap(void)
{ return 1;}
