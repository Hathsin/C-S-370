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



struct SymbTab { //linked list which holds symbol and address
    char * symbol;
    int addr;
    struct SymbTab *next;
};/* end of SymTab */
    
struct SymbTab *first,*last; //initializes first and last for symbol list.

//PRE
//POST
void main() { //interface for Symbol table, takes input and uses auxiliary methods to interact with linked list that stores the data
    int op,y, addy;
    char la[10], s[10];
    do {
        printf("\n\tSYMBOL TABLE IMPLEMENTATION\n");
        printf("\n\t1.INSERT\n\t2.DISPLAY\n\t3.DELETE\n\t4.SEARCH\n\t5.END\n");
        printf("\n\tEnter your option : ");
        scanf("%d",&op);
        switch(op) {
            case 1:
            printf("\n\tEnter the symbol : ");
            scanf("%s", s);
            printf("\n\tEnter the address : ");
            scanf("%d", &addy);
            Insert(strdup(s), addy);
            break;
            case 2:
            Display();
            break;
            case 3:
            printf("\n\tEnter the symbol to be deleted : ");
            scanf("%s",s);
            Delete(s);
            break;
            case 4:
            printf("\n\tEnter the symbol to be searched : ");
            scanf("%s",la);
            y=Search(la);
            printf("\n\tSearch Result:");
            if(y==1)
            printf("\n\tThe symbol is present in the symbol table\n");
            else
            printf("\n\tThe symbol is not present in the symbol table\n");
            break;
            case 5:
            exit(0);
        }
    }
    while(op<6);

}  /* end of main */

//PRE does not duplicate address, if to be used as symboltable(?)
//POST
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

//PRE
//POST
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

//PRE
//POST
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

//PRE
//POST
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

