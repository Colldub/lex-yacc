/*
	Palandrome Assignment	CS 121
	Header File
	
	Collin Worth	9-25-2023
*/

#ifndef LIST_H
#define LIST_H

#include <string>

using namespace std;

class List {
public:
    List(); // Constructor
    ~List(); // Destructor

    void PrintList();
    void Delete();
    void AddNode(string);
    void AddNodeToEnd(string);

private:
    struct Node {
        string data;
        Node* next;
    };
    Node* head;
};

#endif