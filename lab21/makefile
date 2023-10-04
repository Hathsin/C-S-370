#
#   Benjamin Widner III
#   August 18, 2023
#   Lab21- makefile


all: lab21

lab21: lab2remove.l
	lex lab2remove.l
	gcc lex.yy.c -o lab21
	
clean:
	rm -f lab21