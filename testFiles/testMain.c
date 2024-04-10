
struct sym {
  char *name;
  double value;
  struct sym *next;
}; //sym_tbl[NSYMS];

void AddSym(char *name, double value) {
        struct sym *ptr = new struct sym;
        ptr->name = strdup(name);
        ptr->value = value;

        if (head == NULL) {
            ptr->next = NULL;
        } else {
            ptr->next = sym_head;
        }
        sym_head = ptr;
    }