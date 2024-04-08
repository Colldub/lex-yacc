%{
#include "symtbl.h"
#include <math.h>
%}

%union {
    double dval;
    struct sym *symptr; // Declare sym pointer type
}

%token <symptr> NAME // Use sym pointer type for NAME token
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
    : NAME '=' expression { AddSym($1->name, $3); } // Use AddSym to add symbols to the list
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
    | NAME { $$ = $1->value; } // Access the value of the symbol
    ;

%%

void yyerror(char *s) {
    printf("%s\n", s);
}
