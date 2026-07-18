/* Exercise 5: singly linked list with manual memory management -- every
   listPush's malloc must be matched by exactly one free in listFreeAll,
   proven here via allocation counters, not just asserted. */
#include <stdio.h>
#include <stdlib.h>

static int g_allocs = 0;
static int g_frees = 0;

typedef struct Node {
    int value;
    struct Node* next;
} Node;

static Node* listPush(Node* head, int value) {
    Node* node = (Node*)malloc(sizeof(Node));
    g_allocs++;
    node->value = value;
    node->next = head;   /* push to front */
    return node;
}

static void listPrint(const Node* head) {
    for (const Node* cur = head; cur != NULL; cur = cur->next) {
        printf("%d -> ", cur->value);
    }
    printf("NULL\n");
}

static void listFreeAll(Node* head) {
    while (head != NULL) {
        Node* next = head->next;   /* save before freeing head */
        free(head);
        g_frees++;
        head = next;
    }
}

int main(void) {
    Node* head = NULL;
    int values[] = { 10, 20, 30, 40, 50 };
    size_t n = sizeof(values) / sizeof(values[0]);

    for (size_t i = 0; i < n; i++) {
        head = listPush(head, values[i]);
    }

    listPrint(head);
    listFreeAll(head);

    printf("allocs=%d frees=%d (balanced=%s)\n",
           g_allocs, g_frees, (g_allocs == g_frees) ? "yes" : "no");
    return 0;
}
