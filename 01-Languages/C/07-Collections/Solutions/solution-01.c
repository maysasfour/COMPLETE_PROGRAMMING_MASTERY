/* solution-01.c -- hand-rolled dynamic int stack (push/pop) via malloc/realloc. */
#include <stdio.h>
#include <stdlib.h>

typedef struct {
    int* data;
    size_t count;
    size_t capacity;
} IntStack;

IntStack stackCreate(size_t initialCapacity) {
    IntStack s;
    s.data = malloc(initialCapacity * sizeof(int));
    s.count = 0;
    s.capacity = initialCapacity;
    return s;
}

void stackPush(IntStack* stack, int value) {
    if (stack->count == stack->capacity) {
        size_t newCapacity = stack->capacity == 0 ? 1 : stack->capacity * 2;
        int* grown = realloc(stack->data, newCapacity * sizeof(int));
        if (grown == NULL) {
            fprintf(stderr, "realloc failed\n");
            exit(1);
        }
        stack->data = grown;
        stack->capacity = newCapacity;
    }
    stack->data[stack->count++] = value;
}

int stackPop(IntStack* stack) {
    return stack->data[--stack->count];
}

void stackFree(IntStack* stack) {
    free(stack->data);
    stack->data = NULL;
    stack->count = 0;
    stack->capacity = 0;
}

int main(void) {
    IntStack s = stackCreate(2);
    for (int i = 1; i <= 5; i++) stackPush(&s, i);

    for (int i = 0; i < 5; i++) {
        printf("%d ", stackPop(&s));
    }
    printf("\n");

    stackFree(&s);
    return 0;
}
