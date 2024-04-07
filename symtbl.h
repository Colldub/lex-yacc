#ifndef SYMTBL_H
#define SYMTBL_H __DATE__ " "__TIME__

#define NSYMS (3)

struct sym {
  char *name;
  double value;
  struct sym *next;
}; //sym_tbl[NSYMS];

int sym_count(void);
int list_count(void);
struct sym *sym_lookup(char *);
struct sym *list_lookup(char *);

#endif /* SYMTBL_H */
