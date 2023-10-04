#
#   Benjamin Widner III
#   September 15, 2023
#   Lab5 Algol-C into YACC and LEX 
#



all: lab5

lab5: lab5.l lab5.y
		lex lab5.l
		yacc -d lab5.y  
		gcc lex.yy.c y.tab.c -o lab5

clean:
	rm -f lab5