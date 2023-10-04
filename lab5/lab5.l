/*
   LEX routine which returns tokens, integers, special characters, variable names and strings. 
   Also, handles formatting for new lines in code, counts lines, ignores whitespace
   in the program and comments.

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
int      { return (T_INT);} //int token creator   --- all reserved words for tokens in following list
void     { return (T_VOID);} //void token creator
boolean  { return (T_BOOLEAN);} //boolean token creator
end      { return (T_END);} //end token creator
begin    { return (T_BEGIN);} //begin token creator
return    { return (T_RETURN);} //return token creator
and    { return (T_AND);} //and token creator
or    { return (T_OR);} //or token creator
"<="    { return (T_LE);} 
">="    { return (T_GE);}
"=="    { return (T_EQ);}
"!="    { return (T_NE);}
not    { return (T_NOT);}
true    { return (T_TRUE);}
false    { return (T_FALSE);}
if        { return (T_IF);}
else     { return (T_ELSE);} 
then     { return (T_THEN);} 
endif    { return (T_ENDIF);} 
write    { return (T_WRITE);} 
while    { return (T_WHILE);} 
do       { return (T_DO);} 
read     { return (T_READ);}


[a-zA-Z][a-zA-Z0-9_]* { //reads variable name, starts with char, then char, num, and _ or more
                        yylval.string=strdup(yytext); 
                        return(T_ID);
                     }

[0-9][0-9]*	{//int reader, for any num any size
             yylval.value=atoi((const char *)yytext); 
             return(T_NUM);
            }

[ \t]		{ //ignores whitespace aside from newline
            }

[=\-+*/%&,|[\]()<>;] 	{//additional tokens, (special symbols)
                 return (*yytext);
                }

\n 		{ //tracks new lines and helps with formatting
            linenum++;
         }

\/\/.* {} //ignores single line comments in code

\"[^"\n]*["]     { yylval.string=strdup(yytext); 
                  return(T_STRING);}


%%

//PRE 
//POST
int yywrap(void)
{ return 1;}
