# Solution 01 — FizzBuzz as a Switch Expression

[Back to exercise](../Exercises/exercise-01.md)

## Explanation

- The `x % 15 == 0` guard is checked **first**, before the individual `%3`/`%5` guards — checking `%3` or `%5` alone first would incorrectly return `"Fizz"` or `"Buzz"` for multiples of 15 before the combined case ever had a chance to match, since C# `switch` expression arms are evaluated top-to-bottom and the first match wins.
- `_ => n.ToString()` is the discard-pattern fallback, converting the plain-number case to a string explicitly so every arm returns the same `string` type.

## Verification

Ran with `dotnet run Solutions/solution-01.cs`; actual output matches the exercise's expected output exactly, line for line, for all values 1 through 15.
