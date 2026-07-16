# Solution 01 — A `swap` Function Using References

[Back to exercise](../Exercises/exercise-01.md)

## Explanation

- `swapValues(int& a, int& b)` takes references, so `a` and `b` inside the function are genuine aliases for the caller's `x`/`y` — swapping them through the local `temp` variable modifies `x`/`y` themselves.
- `swapValuesBroken(int a, int b)` takes plain value parameters — `a`/`b` inside the function are independent copies of `p`/`q`. The swap logic is identical, but it only swaps the local copies; `p`/`q` in `main` are completely untouched, exactly demonstrating Lesson 06's core point about pass-by-value vs. pass-by-reference.

## Verification

Ran with the MSVC compile-and-run helper; actual output:

```
After swapValues: x=2, y=1
After swapValuesBroken: p=1, q=2
```

Matches the exercise's expected output exactly — `swapValues` genuinely swapped its arguments, `swapValuesBroken` did not, despite identical internal logic.
