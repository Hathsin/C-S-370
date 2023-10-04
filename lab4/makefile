#
#   Benjamin Widner III
#   September 08, 2023
#   Lab4 Calculator plus symtable
#



all: lab4

lab4: lab4docalc.l lab4docalc.y symtable.c symtable.h
		lex lab4docalc.l
		yacc -d lab4docalc.y  
		gcc symtable.c lex.yy.c y.tab.c -o lab4

clean:
	rm -f lab4