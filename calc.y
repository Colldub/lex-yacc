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
%token <symptr> CONST_NAME
%token <dval> NUMBER
%token <character> PRINT
%left '-' '+'
%left '*' '/'
%nonassoc UMINUS

%type <name> new_name
%type <symptr> existing_name
%type <symptr> const_name
%type <dval> expression
%%



statement_list
    : statement '\n'
    | statement_list statement '\n'
    ;

statement
    : PRINT { printALL(); }
    | new_name '=' expression { addSym($1, $3); }
    | existing_name '=' expression { $1->value = $3; }
    | const_name '=' expression { puts("Can not edit Constant variables"); }
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
    | const_name { $$ = const_getVal ($1->vName); }
    | existing_name { $$ = list_getVal($1->vName); }
    | new_name { $$ = 0; addSym ($1, 0);}
    ;

const_name
    : CONST_NAME { $$ = $1; }
    ;

new_name 
    : NEW_NAME { $$ = $1; }
    ;

existing_name 
    : EXISTING_NAME { $$ = $1; }
    ;
%%



struct sym * list_lookup(char *s)
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

void addSym(char *name, double value){
        struct sym *ptr = (struct sym *)malloc(sizeof(struct sym));
    
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
    printf("Number of Symbols: %d\n", list_count());
    
    // Print consts
    printConsts();

    // Print syms
    listSyms();
}

void listSyms() {
    printf("Entering listSyms()\n");

    struct sym *ptr = sym_head;
    if (ptr == NULL) {
        puts("ptr error");
        exit(1);
    }

    printf("Building array of symbol names...\n");

    char * arr[list_count()];
    int itt = 0;
    int size = list_count();

    while (ptr != NULL) {
        arr[itt++] = ptr->vName;
        ptr = ptr->next;
    }

    printf("Sorting array of symbol names...\n");

    // SORT ARRAY
    sortArray(arr, size);

    for (int i = 0; i < size; i++){
        printf("section: %d = %s", i, arr[i]);
    }

    printf("Printing sorted symbols...\n");

    // PRINT OUT SYMBOLS
    for (int i = 0; i < size; i++) {
        ptr = list_lookup(arr[i]);

        printf("%s = %f\n", ptr->vName, ptr->value);
    }

    printf("Exiting listSyms()\n");
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

void initList(){
    addConst("PI", 3.14159);
    addConst("PHI", 1.61803);
}

void addConst(char *name, double value){
        struct sym *ptr = (struct sym *)malloc(sizeof(struct sym));
    
        ptr->vName = strdup(name);
        ptr->value = value;

        if (const_head == NULL) {
            ptr->next = NULL;
            puts("added first value");
        } else {
            ptr->next = const_head;
            puts("added second value");
        }
        const_head = ptr;
        printf("ptr->vName: %s\n", ptr->vName);
        if(ptr == NULL){
            printf("Allocation error 11");
        }
        printf("setting ptr: %s = %s\n", ptr->vName, const_getVal(ptr->vName));

}

struct sym * const_lookup(char *s){
    struct sym *ptr = const_head;
    while(ptr != NULL){
        if(strcmp(ptr->vName, s) == 0){
            return ptr;
        }
        ptr = ptr->next;
    }
}

double const_getVal(char *s) {
    struct sym *ptr = const_head;
    while(ptr != NULL) {
        printf("Checking constant: %s\n", ptr->vName);
        if(strcmp(ptr->vName, s) == 0) {
            printf("Found constant %s with value %f\n", ptr->vName, ptr->value);
            return ptr->value;
        }
        ptr = ptr->next;
    }
    printf("Constant %s not found\n", s);
    return 0; // Or whatever default value you want to return if the constant is not found
}


void printConsts(){
    puts("Printing out consts");
    struct sym *ptr = const_head;
    printf("ptr: %s = %s\n", ptr->vName, const_getVal(ptr->vName));
    while(ptr != NULL){
        printf("\t%s = %d\n",ptr->vName, const_getVal(ptr->vName));
        ptr = ptr->next;
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
    initialize();
    yyparse();
    freeList(sym_head);
    freeList(const_head);
    return 0;
}

void yyerror(char* s)
{
    printf("%s\n", s);
}

