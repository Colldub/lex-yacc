%{
#include "symtbl.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
extern void yyerror(char*);
extern int yylex();

//Global Pointer//


//Prototypes//



    struct sym {
        char* name;
        double value;
        struct sym* next;
    };
    struct sym* sym_head;

//void yyerror(const char* s);

%}



%union {
    double dval;
    char *name;
}

%token <symptr> NAME
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
    : NAME '=' expression { AddSym($1, $3); }
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
    | NAME { $$ = list_lookup($1)->value; }
    ;

%%

/*
struct sym * sym_lookup(char * s)
{
    char * p;
    struct sym * sp;

    for (sp=sym_tbl; sp < &sym_tbl[NSYMS]; sp++)
    {
        if (sp->name && strcmp(sp->name, s) == 0)
            // it's already here
            return sp;

        if (sp->name)
            // skip to next 
            continue;

        sp->name = strdup(s);
        return sp;
    }

    yyerror("Too many symbols");
    exit(-1);
    return NULL; // unreachable 
}
*/

struct sym * list_lookup(char * s)
{
    struct sym *ptr = sym_head;
    while(ptr != NULL){
        if(strcmp(ptr->name, s) == 0){
            return ptr;
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
        if(ptr == NULL){ break; }
        count ++;
    }
}
/*
int sym_count(void)
{
    int i, cnt;

    for (cnt=i=0; i<NSYMS; i++)
        if (sym_tbl[i].name)
            cnt++;

    return cnt;
}
*/

void AddSym(char *name, double value) {
        struct sym *ptr = (struct sym *)malloc(sizeof(struct sym));
        //node_t *p= (node_t *)malloc(sizeof(node_t)
        //List * listPointer = (List *) malloc(sizeof(List));
    
        ptr->name = strdup(name);
        ptr->value = value;

        if (sym_head == NULL) {
            ptr->next = NULL;
        } else {
            ptr->next = sym_head;
        }
        sym_head = ptr;
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
