         /* simple lex program which removes comments from a source program
            The main key is that a variable "comment" is set when the start of a comment
            is seen and then unset when the ending set is seen.  It is possible to have
            two starts closed by on end.

            Shaun Cooper
            January 2015

            Outpu is printed with comments successfully removed and errors due to possible
            nested comments are indicatied with line number. Added code to run when new line 
            found, added variable to track lines, adjusted code that ran from "/*" to incorperate
            additional features. defined main return type.

            Benjamin Widner
            August 2023
 
         */ 
        int comment = 0;
        int debug=1;  /* prints out debug statements if desired */
        int line=1; //line number tracker var
%%

[\n] { if (!comment) printf("%s",yytext); line++; } //checks for new line to update line number and does not print out new line

"/*"	{
	if (comment && debug) fprintf(stderr,
		" >>>>>>>> line %d: Possible Nested comment <<<<<<<<<<\n", line);
	comment = 1;
	}

"*/"	{
          if (!comment) printf("%s",yytext); /*print out if it is not in a comment */
  	  comment = 0;
	}

.       { if (!comment) printf("%s",yytext);}

%%


//PRE 
//POST
int yywrap(void)
{ return 1;
}

//PRE 
//POST
int main()
{
  yylex();
  
}
