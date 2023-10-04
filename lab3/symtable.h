/*
  * Defines functions for symbol table
  * Benjamin Widner
  * September 2023 
  */

struct SymbTab; // linked list which holds symbol and address
void Insert(char * sym, int address); // takes a symbol and address and inserts if symbol is not there
void Delete(char *s); // takes a symbol and removes it if present
int Search(char *s); //takes a symbol and states if present or not returns 0 or 1.
void Display(); //displays symbol and address in order they are input