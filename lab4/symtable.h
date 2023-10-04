/*
  * Defines functions for symbol table
  * Benjamin Widner
  * September 2023 
  */

#ifndef symboltable

struct SymbTab { //linked list which holds symbol and address
    char * symbol;
    int addr;
    struct SymbTab *next;
};/* end of SymTab */
void Insert(char * sym, int address); // takes a symbol and address and inserts if symbol is not there
void Delete(char *s); // takes a symbol and removes it if present
int Search(char *s); //takes a symbol and states if present or not returns 0 or 1.
void Display(); //displays symbol and address in order they are input
int FetchAddress(char * symbol);//write comment for dis_____________________________________________________________


#endif