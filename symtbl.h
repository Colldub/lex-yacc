#ifndef SYMTBL_H
#define SYMTBL_H __DATE__ " "__TIME__

#define NSYMS (3)


//int sym_count(void);
//int list_count(void);
//struct sym *sym_lookup(char *);
//struct sym *list_lookup(char *);
//void AddSym(char*, double);



   
    void addSym(char *name, double value, struct sym*&);
    struct sym * list_lookup(char *name);
    double list_getVal(char *name);
    int list_count(void);
    void listSyms();
    void printAll();
    void sortArray(char**, int);
    void initList();

#endif /* SYMTBL_H */
