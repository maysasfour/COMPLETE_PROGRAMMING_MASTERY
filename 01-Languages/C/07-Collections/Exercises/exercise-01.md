# Exercise 01 — A Hand-Rolled Dynamic `int` Stack

[Back to lesson](../README.md)

## Task

Implement a minimal growable stack of `int` using a `struct IntStack { int* data; size_t count; size_t capacity; };` and three functions:

- `IntStack stackCreate(size_t initialCapacity)` — allocates `data` with `malloc`.
- `void stackPush(IntStack* stack, int value)` — grows (`realloc`, doubling) if `count == capacity`, then appends.
- `int stackPop(IntStack* stack)` — decrements `count` and returns the popped value (assume never popping an empty stack for this exercise).
- `void stackFree(IntStack* stack)` — frees `data` and resets `count`/`capacity` to `0` and `data` to `NULL`.

Push the values 1 through 5, then pop and print all 5 (should come back in reverse: 5, 4, 3, 2, 1), then free the stack.

## Constraints

- Growth must go through `realloc`, checked for `NULL`, exactly like `example.c`'s pattern.
- Call `stackFree` at the end — no leaked allocation.

## Starter Code

```c
#include <stdio.h>
#include <stdlib.h>

typedef struct {
    int* data;
    size_t count;
    size_t capacity;
} IntStack;

IntStack stackCreate(size_t initialCapacity) {
    /* your code */
}

void stackPush(IntStack* stack, int value) {
    /* your code -- grow via realloc if count == capacity */
}

int stackPop(IntStack* stack) {
    /* your code */
}

void stackFree(IntStack* stack) {
    /* your code */
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
```

## Expected Output

```
5 4 3 2 1 
```

## Solution

See [Solutions/solution-01.md](../Solutions/solution-01.md) and [Solutions/solution-01.c](../Solutions/solution-01.c).
