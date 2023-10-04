/* 
  * This C program is designed to create a symbol table that stores a symbol and address.
  * It can add elements, display all elements, delete elements, search for elements, and 
  * end the program. This is implemented via a linked list with fields to store data and
  * reference all objects in the table.
  * 
  * Benjamin Widner
  * September 2023
  */


#include<stdio.h>
/* #include<conio.h> */
#include<malloc.h>
#include<string.h>
#include<stdlib.h>
#include "symtable.h"

int size=0;//global var tracking size of linked list

    
struct SymbTab *first,*last; //initializes first and last for symbol list.


//PRE -- SymbTab correctly made, 
//POST -- modified symbol table
void Insert(char * sym, int address) {// takes a symbol and address and inserts if symbol is not there
    int n;
    n=Search(sym);
    if(n==1){
        printf("\n\tThe symbol exists already in the symbol table\n\tDuplicate can't be inserted");
        return;
    }
    else {
        struct SymbTab *p;
        p=malloc(sizeof(struct SymbTab));
        p->symbol = sym;
        p->addr = address;
        p->next=NULL;
        if(size==0) {
            first=p;
            last=p;
        }
        else {
            last->next=p;
            last=p;
        }
        size++;
        printf("\n\tSymbol inserted\n");
    }
   
}/* end of insert */

//PRE -- SymbTab correctly made
//POST -- prints full symbol table
void Display() { //displays symbol and address in order they are input
    int i;
    struct SymbTab *p;
    p=first;
    printf("\n\tSYMBOL\t\tADDRESS\n");
    for(i=0;i<size;i++) {
        printf("\t%s\t\t%d\n",p->symbol,p->addr);
        p=p->next;
    }
}/* end of display */

//PRE -- SymbTab correctly made
//POST -- returns 1 or 0 for present or not
int Search(char *s) { //takes a symbol and states if present or not returns 0 or 1.
    int i,flag=0;
    struct SymbTab *p;
    p=first;
    for(i=0;i<size;i++) {
        if(strcmp(p->symbol,s)==0)
        flag=1;
        p=p->next;
    }
    return flag;
}/* end of search */

//PRE -- search defined and symbTab correctly made
//POST -- symbol table no longer has symbol
void Delete(char *sym) {// takes a symbol and removes it if present
    int a;
    struct SymbTab *p,*q;
    p=first;
    a=Search(sym);
    if(a==0)
        printf("\n\tSymbol not found\n");
    else {
        if(strcmp(first->symbol,sym)==0)
            first=first->next;
        else if(strcmp(last->symbol,sym)==0) {
            q=p->next;
            while(strcmp(q->symbol,sym)!=0) {
                p=p->next;
                q=q->next;
            }
            p->next=NULL;
            last=p;
        }
        else {
            q=p->next;
            while(strcmp(q->symbol,sym)!=0) {
                p=p->next;
                q=q->next;
            }
            p->next=q->next;
        }
        size--;
        printf("\n\tAfter Deletion:\n");
        Display();
    }
} /* end of delete */

//PRE -- string this is in symboltable
//post -- address assigned
int FetchAddress(char * symbol){ //returns address of symbol
    int i;
    struct SymbTab *p;
    p=first;
    while(strcmp(p->symbol,symbol)) {
        p=p->next;
    }
    return(p->addr);
}/* end of FetchAddress */