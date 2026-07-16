# Solution 01 — FizzBuzz with a Range-Based For

[Back to exercise](../Exercises/exercise-01.md)

## Explanation

- The `%15` check runs first, before `%3`/`%5`, since `if`/`return` short-circuits — checking `%3`/`%5` first would incorrectly return `"Fizz"`/`"Buzz"` for multiples of 15 before ever reaching a combined check.
- `std::to_string(n)` converts the fallback `int` to a `std::string` explicitly, so every return path has a consistent `std::string` return type.
- The range-based `for (const auto& n : numbers)` in `main` iterates the vector without copying each `int` unnecessarily (admittedly immaterial for a plain `int`, but the habit matters for non-trivial element types, per this lesson's guidance).

## Verification

Ran with the MSVC compile-and-run helper; actual output matches the exercise's expected output exactly, line for line, for all values 1 through 15.
