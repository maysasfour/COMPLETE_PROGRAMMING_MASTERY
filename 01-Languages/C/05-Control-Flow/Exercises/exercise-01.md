# Exercise 01 — FizzBuzz Bit Pattern With `switch`

[Back to lesson](../README.md)

## Task

Write a function `void fizzBuzz(int n)` that prints `"FizzBuzz"` for multiples of 15, `"Fizz"` for multiples of 3 (but not 15), `"Buzz"` for multiples of 5 (but not 15), and the number itself otherwise. Implement it using a `switch` on a small "bit pattern" integer computed as `(n % 3 == 0) * 1 + (n % 5 == 0) * 2` (giving 0, 1, 2, or 3), **not** a chain of `if`/`else if`. Then call it in a `for` loop for `n` from 1 to 15, stored first in a fixed-size `int numbers[15]` array (Lesson 07 previews fixed-size arrays here).

## Constraints

- Use `switch`, with explicit `break` in every case (no fall-through — this exercise is about correct, deliberate `switch` usage, not the fall-through pitfall itself).
- Populate `numbers[15]` with 1 through 15 using a `for` loop before the FizzBuzz loop.

## Starter Code

```c
#include <stdio.h>

void fizzBuzz(int n) {
    int pattern = (n % 3 == 0) * 1 + (n % 5 == 0) * 2;
    switch (pattern) {
        /* your cases here */
    }
}

int main(void) {
    int numbers[15];
    for (int i = 0; i < 15; i++) numbers[i] = i + 1;

    for (int i = 0; i < 15; i++) {
        fizzBuzz(numbers[i]);
    }
    return 0;
}
```

## Expected Output

```
1
2
Fizz
4
Buzz
Fizz
7
8
Fizz
Buzz
11
Fizz
13
14
FizzBuzz
```

## Solution

See [Solutions/solution-01.md](../Solutions/solution-01.md) and [Solutions/solution-01.c](../Solutions/solution-01.c).
