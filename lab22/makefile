#
#   Benjamin Widner III
#   August 18, 2023
#   Lab22 makefile
#
#
#   Explain how  the following calculator instructions work in DETAIL for the two sentences in the calculator
#   "a = 3 + 5"
#   "a"
#	The calculatopr begins list and waits for a valid stat(statement) to be input.
#	the first character read in is "a" and identifies it is a VARIABLE, which will 
#	take an integer and store it in the regs array. since the variable is a, it goes 
#	in position 0 as calulated by 'a' - 'a'. It is a valid stat (VARIABLE '=' expr) 
#	The next character is a space and is ignored(as will all other spaces), next is 
#	'=', which is what the calculator expected. Next the calculator expects an 
#	expression, which begins with 3, a valid expr(INTEGER), then a '+' token, indicating
#	that addition will be done. Next expr is a 5. this expression returns 8 and is the 
#	value stored that corresponds to the variable a. a new line inicates the stat is finished.
#	since it was assignment, no other action is taken. Finally the nest line is a, a valid stat
#	which is an expr. this returns the value stored in a, which is 8.


all: lab22

lab22: lab2docalc.l lab2docalc.y
		lex lab2docalc.l
		yacc -d lab2docalc.y  
		gcc lex.yy.c y.tab.c -o lab22
	

clean:
	rm -f lab22