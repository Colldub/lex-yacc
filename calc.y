%{
#include "symtbl.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
extern void yyerror(char*);
extern int yylex();

    struct sym {
        char* vName;
        double value;
        struct sym* next;
    };
    struct sym* sym_head;

%}



%union {
    double dval;
    char * name;
    struct sym * symptr;
    char character;
}

%token <name> NEW_NAME
%token <symptr> EXISTING_NAME
%token <dval> NUMBER
%token <character> PRINT
%left '-' '+'
%left '*' '/'
%nonassoc UMINUS

%type <name> new_name
%type <symptr> existing_name
%type <dval> expression
%%



statement_list
    : statement '\n'
    | statement_list statement '\n'
    ;

statement
    : PRINT { puts("Trying to print"); printALL(); }
    | new_name '=' expression { AddSym($1, $3); }
    | existing_name '=' expression { $1->value = $3; }
    | expression { printf("= %g\n", $1); }
    | '?' { printf("num-syms: %d\n", list_count()); }
    ;

expression
    : expression '+' expression { $$ = $1 + $3; }
    | expression '-' expression { $$ = $1 - $3; }
    | expression '*' expression { $$ = $1 * $3; }
    | expression '/' expression {
        if($3 == 0) {
            printf("divide by zero\n");
            $$ = $1;
        }else{
            $$ = $1 / $3;
        }
    }
    | '-' expression %prec UMINUS { $$ = -$2; }
    | '(' expression ')' { $$ = $2; }
    | NUMBER
    | existing_name { $$ = list_getVal($1->vName); }
    | new_name { $$ = 0; AddSym ($1, 0);}
    ;

new_name 
    : NEW_NAME { $$ = $1; }
    ;

existing_name 
    : EXISTING_NAME { $$ = $1; }
    ;
%%

struct sym * list_lookup(char * s)
{
    struct sym *ptr = sym_head;
    while(ptr != NULL){
        if(strcmp(ptr->vName, s) == 0){
            return ptr;
        }
        ptr = ptr->next;
    }
}

double list_getVal(char * s)
{
    struct sym *ptr = sym_head;
    while(ptr != NULL){
        if(strcmp(ptr->vName, s) == 0){
            return ptr->value;
        }
        ptr = ptr->next;
    }
}

int list_count(void)
{
    int count = 0;
    struct sym *ptr = sym_head;
    while(ptr != NULL){
        ptr = ptr->next;
        //if(ptr == NULL){ break; }
        count ++;
    }
    return count;
}

void AddSym(char *name, double value){
        struct sym *ptr = (struct sym *)malloc(sizeof(struct sym));
        //node_t *p= (node_t *)malloc(sizeof(node_t)
        //List * listPointer = (List *) malloc(sizeof(List));
    
        ptr->vName = strdup(name);
        ptr->value = value;

        if (sym_head == NULL) {
            ptr->next = NULL;
        } else {
            ptr->next = sym_head;
        }
        sym_head = ptr;
    }

void printALL(){
    // Print count
    printf("Number of Symbols: %d", list_count());
    
    // Print consts

    // Print syms
    listSyms();
}

void listSyms(){
    struct sym *ptr = sym_head;
    if(ptr == NULL){
        puts("ptr error");
        exit(1);
    }

    char * arr[list_count()];
    int itt = 0;
    int size = list_count();

    while (ptr != NULL){
       arr[itt++] = ptr->vName;
    }
    for(int i = 0; i < size; i ++){ // Print out array for test
        printf("[%s] ", arr[i]);   //
    }                               // 
    printf("\n");                   //////


    //SORT ARRAY////////////
    
    //PRINT OUT SYMBOLS////////
    for(int i = 0; i < size; i ++){
        ptr = list_lookup(arr[i]);

        printf("%s = %d", ptr->vName, ptr->value);
    }
}

int main()
{
    yyparse();
    return 0;
}

void yyerror(char* s)
{
    printf("%s\n", s);
}
