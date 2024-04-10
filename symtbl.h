#ifndef SYMTBL_H
#define SYMTBL_H __DATE__ " "__TIME__

#define NSYMS (3)


//int sym_count(void);
//int list_count(void);
//struct sym *sym_lookup(char *);
//struct sym *list_lookup(char *);
//void AddSym(char*, double);



   
    void AddSym(char *name, double value);
    struct sym *list_lookup(char *name);
    int list_count(void);


    struct sym {
        char* name;
        double value;
        struct sym* next;
    };
    struct sym* sym_head;


#endif /* SYMTBL_H */
