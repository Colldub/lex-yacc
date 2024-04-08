#ifndef SYMTBL_H
#define SYMTBL_H __DATE__ " "__TIME__

#include <stdlib.h>
#include <string.h>

struct sym {
    char *name;
    double value;
    struct sym *next;
}; //sym_tbl[NSYMS];

extern struct sym *sym_head; // Declare sym_head as an external variable

int sym_count(void);
struct sym *sym_lookup(char *);
void AddSym(char *, double);

#endif /* SYMTBL_H */
