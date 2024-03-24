/*
        Linked List CS 121
        Class File

        Collin Worth	9-25-2023
*/

#include "List.h"
#include <iostream>
#include <string>

using namespace std;

List::List() {
  // Initialize your class if needed
  head = NULL;
}

List::~List() {
  // Deconstructor
}

void List::AddNode(string str) {

  Node *ptr = new Node;
  ptr->data = str;

  if (head == NULL) { // empty case
    ptr->next = NULL;
  } else {
    ptr->next = head;
  }
  head = ptr;
}

void List::AddNodeToEnd(string str) {
  Node *ptr = new Node;
  ptr->data = str;

  if (head == NULL) { // empty case
    ptr->next = NULL;
  } else {
    Node *temp = head;
    while (temp->next != NULL) {
      temp = temp->next;
    }
    ptr->next = NULL;
    temp->next = ptr;
  }
}

// Print list in order to test code
void List::PrintList() {
  Node *current = head;
  while (current != nullptr) {
    cout << current->data << " ";
    current = current->next;
  }
  cout << endl;
}

// Implement the Delete function to clean up the list
void List::Delete() {
  while (head != nullptr) {
    Node *temp = head;
    head = head->next;
    delete temp;
  }
}
