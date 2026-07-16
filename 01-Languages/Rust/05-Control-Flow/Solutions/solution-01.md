# Solution 01 — FizzBuzz with an Exhaustive Match

[Back to exercise](../Exercises/exercise-01.md)

## Explanation

- Matching on the tuple `(n % 3, n % 5)` lets a single `match` express all four cases cleanly: `(0, 0)` (divisible by both 3 and 5), `(0, _)` (divisible by 3 only — the `_` matches any remainder for `n % 5`), `(_, 0)` (divisible by 5 only), and a final catch-all `_` for neither.
- `(0, 0)` is listed **first** — `match` arms are checked top-to-bottom, and since a multiple of 15 also has `n % 3 == 0`, it would incorrectly match `(0, _)` if that arm came first.
- `n.to_string()` converts the fallback `u32` to a `String` explicitly, keeping every match arm's return type consistently `String`.

## Verification

Ran with `rustc main.rs -o main.exe && ./main.exe`; actual output matches the exercise's expected output exactly, line for line, for all values 1 through 15.
