# Exercise 01 — FizzBuzz with a Twist

[Back to lesson](../README.md)

## Task

Write a function `classify(n)` that, for a given positive integer `n`, returns:

- `"FizzBuzz"` if `n` is divisible by both 3 and 5
- `"Fizz"` if `n` is divisible by 3 only
- `"Buzz"` if `n` is divisible by 5 only
- the string form of `n` otherwise (e.g., `"7"`)

Then write a loop that prints `classify(n)` for every `n` from 1 to 20.

## Constraints

- Use `elif`, not separate stacked `if` statements — think about why stacking would be wrong here (re-read the "Common Mistakes" section of the lesson if unsure).
- Use a `for` loop over the range 1–20, not a `while` loop — justify in a comment why `for` is the right tool here (tie it back to the Beginner section on `for` vs `while`).

## Bonus (ties to Control Flow's "expressions vs statements")

Rewrite the 1–20 printing loop as a **list comprehension** that builds a list of the 20 classification strings, then print the list. Compare: which version (loop with prints, or comprehension) is easier to read, and why might you prefer one over the other depending on whether you need to print immediately vs. use the results later?

## Deliverable

A `.py` file with `classify()`, the loop version, and the bonus comprehension version. No solution is provided here — check your work against `Solutions/solution-01.py` and `Solutions/solution-01.md` only after attempting it.
