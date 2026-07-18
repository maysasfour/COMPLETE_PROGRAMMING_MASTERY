# Exercises — Control Flow

Attempt these yourself before checking [../Solutions](../Solutions/README.md).

## Exercise 1 — FizzBuzz via `case`/`when`

Write a method `fizzbuzz(n)` that returns `"Fizz"` for multiples of 3, `"Buzz"` for multiples of 5, `"FizzBuzz"` for multiples of both, and the number itself (as a string) otherwise — implemented with `case`/`when` (not a chain of `if`/`elsif`). Print the results for 1 through 20.

## Exercise 2 — Leap Year Checker with Postfix Conditionals

Write a method `leap_year?(year)` that returns `true`/`false` using the standard rule (divisible by 4, except centuries, unless also divisible by 400), written using postfix `if`/`unless` modifiers rather than a block-style `if`. Test it against 2000 (leap), 1900 (not leap), 2024 (leap), and 2023 (not leap).
