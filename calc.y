%{
#include "symtbl.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

// Remove the external declarations since we are not using lex
// extern void yyerror(char*);
// extern int yylex();

// Global Pointer
// struct sym * sym_head = NULL;

// Global List
// list symList;

%}

%union {
    double dval;
    char *name;
}

%token <name> NAME
%token <dval> NUMBER
%left '-' '+'
%left '*' '/'
%nonassoc UMINUS

%type <dval> expression

%%

statement_list
    : statement '\n'
    | statement_list statement '\n'
    ;

statement
    : NAME '=' expression { AddSym($1, $3); } // Use AddSym to add symbols to the list
    | expression { printf("= %g\n", $1); }
    | '?' { printf("num-syms: %d\n", list_count()); }
    ;

expression
    : expression '+' expression { $$ = $1 + $3; }
    | expression '-' expression { $$ = $1 - $3; }
    | expression '*' expression { $$ = $1 * $3; }
    | expression '/' expression {
        if ($3 == 0) {
            printf("divide by zero\n");
            $$ = $1;
        } else {
            $$ = $1 / $3;
        }
    }
    | '-' expression %prec UMINUS { $$ = -$2; }
    | '(' expression ')' { $$ = $2; }
    | NUMBER
    | NAME { $$ = list_lookup($1)->value; }
    ;

%%

// Implement the AddSym function to add symbols to the list
void AddSym(char *name, double value) {
    struct sym *ptr = malloc(sizeof(struct sym));
    if (ptr == NULL) {
        printf("Memory allocation failed\n");
        exit(EXIT_FAILURE);
    }
    ptr->name = strdup(name);
    ptr->value = value;
    ptr->next = sym_head;
    sym_head = ptr;
}

// Implement the list_lookup function to look up symbols in the list
struct sym *list_lookup(char *s) {
    struct sym *ptr = sym_head;
    while (ptr != NULL) {
        if (strcmp(ptr->name, s) == 0) {
            return ptr;
        }
        ptr = ptr->next;
    }
    return NULL;
}

// Implement the list_count function to count symbols in the list
int list_count(void) {
    int count = 0;
    struct sym *ptr = sym_head;
    while (ptr != NULL) {
        count++;
        ptr = ptr->next;
    }
    return count;
}

// Define the main function
int main() {
    yyparse();
    return 0;
}

// Define the yyerror function
void yyerror(char *s) {
    printf("%s\n", s);
}
