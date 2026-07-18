# Exercise 01 — A Function-Pointer Dispatch Table

[Back to lesson](../README.md)

## Task

Write four functions matching the signature `int (*)(int, int)`: `opAdd`, `opSub`, `opMul`, `opDiv` (integer division; assume divisor is never 0 for this exercise). Build a small "dispatch table" — a fixed-size array of function pointers indexed by an operator code (`0`=add, `1`=sub, `2`=mul, `3`=div) — and write a function `int calculate(int a, int b, int opCode)` that looks up and calls the right one through the array, **without** an `if`/`switch` chain inside `calculate` itself (the array lookup *is* the dispatch).

## Constraints

- Use a `typedef` for the function pointer type to keep the array declaration readable.
- `calculate` must be a single array-index-and-call, not a branch.

## Starter Code

```c
#include <stdio.h>

typedef int (*BinOp)(int, int);

int opAdd(int a, int b) { return a + b; }
int opSub(int a, int b) { return a - b; }
int opMul(int a, int b) { return a * b; }
int opDiv(int a, int b) { return a / b; }

int calculate(int a, int b, int opCode) {
    /* your dispatch-table lookup here */
}

int main(void) {
    printf("calculate(10, 3, 0) = %d\n", calculate(10, 3, 0));
    printf("calculate(10, 3, 1) = %d\n", calculate(10, 3, 1));
    printf("calculate(10, 3, 2) = %d\n", calculate(10, 3, 2));
    printf("calculate(10, 3, 3) = %d\n", calculate(10, 3, 3));
    return 0;
}
```

## Expected Output

```
calculate(10, 3, 0) = 13
calculate(10, 3, 1) = 7
calculate(10, 3, 2) = 30
calculate(10, 3, 3) = 3
```

## Solution

See [Solutions/solution-01.md](../Solutions/solution-01.md) and [Solutions/solution-01.c](../Solutions/solution-01.c).
