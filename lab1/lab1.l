%{
     /*  This lex routine uses a counting array to match alphabeticstrings 
         and make a frequency count.
  
         The real item to notice is that yywrap() is called at EOF and then is run
         to do what we need to do.   yywrap() returns true when we have a successful 
         end to the program.  We may want to return false (0) if we want to lexing process 
         to fail 

        Shaun Cooper
        January 2015
   */
	int lgths[100]; /*word counter variable*/
     int nums = 0; /*number counter variable*/
%}


/*PRE: no words with length > 100*/
/*POST*/
%%
[a-z,A-Z]+	     { lgths[yyleng]++; } /*increments when word of lenght index is found*/
[0-9]+              { nums++; } /*increments when number is found*/
.|\n                { /* do nothing */  }


%%

yywrap()
{
	int i;
	printf("Length  No. words\n");
	for (i=1; i<100; i++) {  //prints length of word and how many in given file, using lgths array
		if (lgths[i] > 0) { //prints when non-zero value
			printf("%5d%10d\n",i,lgths[i]); 
		}
	}//end of for
     printf("There are %d numbers\n",nums); //prints count of numbers
	return(1);
}//end of yywrap


main()
{  
     yylex();
}//end of main
