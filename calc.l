%{
#include "y.tab.h"
#include "symtbl.h"
#include <math.h>
%}

%%
(\?){
    return PRINT;
}

([0-9]+|([0-9]*\.[0-9]+)([eE][+-]?[0-9]+)?) {
    yylval.dval = atof(yytext);
    return NUMBER;
    }

[ \t] ; /* ignore whitespace */

[A-Za-z][A-Za-z0-9]* {
        struct sym *symbol = list_lookup(yytext);
        if(symbol != NULL){
            yylval.symptr = symbol;
            //puts("symbol is old");
            return EXISTING_NAME;
        } else {
            yylval.name = strdup (yytext);
            //puts("symbol is new");
            return NEW_NAME;
        }
    }

"$" { return 0; }
\n |
. { return yytext[0]; };
%%
int yywrap() { return 1; }
