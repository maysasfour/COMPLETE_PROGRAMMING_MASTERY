# Solution 01 — A Hand-Rolled Dynamic `int` Stack

[Back to exercise](../Exercises/exercise-01.md)

## Explanation

- `IntStack` is a plain struct owning a raw `int*` plus manually-tracked `count`/`capacity` — this is exactly the bookkeeping `std::vector<int>` does for you automatically in C++; C has no equivalent, so it's written out by hand here.
- `stackPush` only grows (via `realloc`, doubling capacity) when `count == capacity`, checking the result for `NULL` before overwriting `stack->data` — an unchecked `stack->data = realloc(...)` would leak the original block on failure, exactly the trap the lesson's `example.c` warns about.
- `stackPop` decrements `count` first, then indexes with the *new* (already-decremented) value — `stack->data[--stack->count]` — so it returns the last-pushed value without ever needing a separate "peek then remove" step.
- `stackFree` resets `data` to `NULL` after `free()`, so any accidental subsequent use is a detectable null-pointer access rather than a silent use-after-free.

## Verification

Compiled with `cl /std:c17 /W4 solution-01.c` — zero warnings. Ran `solution-01.exe`; printed `5 4 3 2 1`, matching the exercise's expected LIFO pop order exactly.
