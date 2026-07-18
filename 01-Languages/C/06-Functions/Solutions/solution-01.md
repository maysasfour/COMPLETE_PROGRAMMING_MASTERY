# Solution 01 — A Function-Pointer Dispatch Table

[Back to exercise](../Exercises/exercise-01.md)

## Explanation

- `typedef int (*BinOp)(int, int);` names the function pointer type once, so `static const BinOp table[4]` reads cleanly instead of repeating the raw `int (*table[4])(int, int)` syntax.
- `table[opCode](a, b)` is the entire dispatch: indexing the array selects which function's address to call, and the call syntax is identical either way — no `if`/`switch` needed inside `calculate` at all, since the array *is* the branch.
- `static const` on the table means it's initialized once (not rebuilt on every call) and its four function-pointer entries can never be reassigned — the C-level equivalent of "this dispatch table is fixed forever."

## Verification

Compiled with `cl /std:c17 /W4 solution-01.c` — zero warnings. Ran `solution-01.exe`; output matched the exercise's expected output exactly for all four operator codes.
