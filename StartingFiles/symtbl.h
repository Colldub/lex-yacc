#ifndef SYMTBL_H
#define SYMTBL_H __DATE__" "__TIME__

#define NSYMS   (3)

struct sym {
    char * name;
    double value;
} sym_tbl[NSYMS];

int sym_count(void);
struct sym * sym_lookup(char *);

#endif /* SYMTBL_H */
