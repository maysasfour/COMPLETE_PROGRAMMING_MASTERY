# Exercises - Functions

1. Write `make_multiplier(n)`, a closure factory returning a function that multiplies its argument by `n`. Create `times3` and `times5` and prove they're independent.
2. Write a variadic `max_of(...)` that returns the largest of any number of numeric arguments (use `select`/`ipairs`/`{...}`).
3. Write `divide(a, b)` returning two values: the quotient and a boolean `ok` that is `false` (with quotient `nil`) when `b == 0`, instead of erroring.
4. Write a function `first_and_rest(...)` that returns the first argument and a table of the remaining arguments as two separate return values.
