# Solution 01 — FizzBuzz Bit Pattern With `switch`

[Back to exercise](../Exercises/exercise-01.md)

## Explanation

- `(n % 3 == 0) * 1 + (n % 5 == 0) * 2` computes a small integer "bit pattern": `1` if only divisible by 3, `2` if only by 5, `3` if both (divisible by 15), `0` if neither — this is exactly the kind of C idiom that leans on booleans-as-integers (`(n % 3 == 0)` evaluates to `0` or `1`) rather than a boolean type, since the expression is used arithmetically, not just logically.
- Every `case` ends with an explicit `break`, so there is no fall-through here — deliberately, in contrast with Lesson 05's main example which demonstrates fall-through happening.
- The fixed-size `int numbers[15]` array previews Lesson 07's coverage of C's fixed-size, no-bounds-checking arrays: its size is a compile-time constant baked into the type, unlike a growable container.

## Verification

Compiled with `cl /std:c17 /W4 solution-01.c` — zero warnings. Ran `solution-01.exe`; output matched the exercise's expected output exactly, line for line, for `n` from 1 through 15.
