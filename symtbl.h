#ifndef SYMTBL_H
#define SYMTBL_H __DATE__ " "__TIME__

#define NSYMS (3)


//int sym_count(void);
//int list_count(void);
//struct sym *sym_lookup(char *);
//struct sym *list_lookup(char *);
//void AddSym(char*, double);

using namespace std;

class symList {
public:
    symList(); // Constructor
    ~symList(); // Destructor
    void AddSym(char *name, double value);
    struct sym *list_lookup(char *name);
    int list_count(void);

private:
    struct sym {
        char* name;
        double value;
        sym* next;
    };
    sym* sym_head;
};

#endif /* SYMTBL_H */
