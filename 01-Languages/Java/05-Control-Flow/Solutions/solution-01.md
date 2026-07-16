# Solution 01 — FizzBuzz as a Switch Expression

[Back to exercise](../Exercises/exercise-01.md)

## Explanation

- The `%15` guard is checked first, before `%3`/`%5`, since switch arms are evaluated top-to-bottom and the first match wins — checking `%3`/`%5` first would incorrectly return `"Fizz"`/`"Buzz"` for multiples of 15.
- A real compile error was hit and fixed while writing this solution: switching directly on the primitive `int n` with `case Integer i when ...` patterns fails with `primitive patterns are a preview feature and are disabled by default` on the JDK used to verify this course. Reference-type patterns (`case Integer i`) require a reference-typed switch subject — boxing `n` into an `Integer` first (`Integer boxed = n;`) and switching on `boxed` instead resolves it cleanly on a standard (non-preview) JDK, while still satisfying the exercise's "switch expression with pattern matching and `when` guards" requirement.

## Verification

Ran with `java Solutions/Solution01.java`; actual output matches the exercise's expected output exactly, line for line, for all values 1 through 15. The fix above was verified by reproducing the original compile error first, then confirming the boxed-subject version compiles and runs cleanly.
