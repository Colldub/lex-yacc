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
    struct sym* const_head;

    void initialize(){
        initList();
    }

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
    : PRINT { printALL(); }
    | new_name '=' expression { addSym($1, $3, sym_head); }
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
    | new_name { $$ = 0; addSym ($1, 0, sym_head);}
    ;

new_name 
    : NEW_NAME { $$ = $1; }
    ;

existing_name 
    : EXISTING_NAME { $$ = $1; }
    ;
%%

void initList(){
    addSym("PI", 3.14159, const_head);
    addSym("PHI", 1.61803, const_head);
}

void printConsts(){

}

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


void addSym(char *name, double value, struct sym* head){
        struct sym *ptr = (struct sym *)malloc(sizeof(struct sym));
        //node_t *p= (node_t *)malloc(sizeof(node_t)
        //List * listPointer = (List *) malloc(sizeof(List));
    
        ptr->vName = strdup(name);
        ptr->value = value;

        if (head == NULL) {
            ptr->next = NULL;
        } else {
            ptr->next = head;
        }
        head = ptr;
}

void printALL(){
    // Print count
    printf("Number of Symbols: %d\n", list_count());
    
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
       ptr = ptr->next;
    }
/*
    puts("array moved");
    for(int i = 0; i < size; i ++){ // Print out array for test
        printf("[%s] ", arr[i]);   //
    }                               // 
    printf("\n");                   //////
*/

    //SORT ARRAY////////////
    sortArray(arr, size);
    
    //PRINT OUT SYMBOLS////////
    for(int i = 0; i < size; i ++){
        ptr = list_lookup(arr[i]);

        printf("%s = %d\n", ptr->vName, ptr->value);
    }
}

void sortArray(char **array, int size) {
    // Bubble sort algorithm
    for (int i = 0; i < size - 1; i++) {
        for (int j = 0; j < size - i - 1; j++) {
            if (strcmp(array[j], array[j + 1]) > 0) {
                // Swap the strings
                char *temp = array[j];
                array[j] = array[j + 1];
                array[j + 1] = temp;
            }
        }
    }
}

void freeList(struct sym* head){
    struct sym* current = head;
    struct sym* next;
    
    while(current != NULL){
        next = current->next;
        free(current->vName);
        free(current);
        current = next;
    }
}

int main()
{
    yyparse();
    freeList(sym_head);
    return 0;
}

void yyerror(char* s)
{
    printf("%s\n", s);
}

