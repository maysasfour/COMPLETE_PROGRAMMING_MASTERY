# Solution 01 — FizzBuzz with a Twist

[Back to lesson](../README.md) | [Exercise](../Exercises/exercise-01.md)

Full runnable code is in `solution-01.py`. Verified output:

```
1 2 Fizz 4 Buzz Fizz 7 8 Fizz Buzz 11 Fizz 13 14 FizzBuzz 16 17 Fizz 19 Buzz
Comprehension result matches loop result: True
```

## Walkthrough

```python
def classify(n):
    if n % 3 == 0 and n % 5 == 0:
        return "FizzBuzz"
    elif n % 3 == 0:
        return "Fizz"
    elif n % 5 == 0:
        return "Buzz"
    else:
        return str(n)
```

**Why `elif`, not stacked `if`:** with `elif`, once the "divisible by both" branch matches (e.g., `n = 15`), the rest are skipped. If these were separate `if` statements instead, `15 % 3 == 0` would *also* independently trigger `return "Fizz"` — but since `return` exits the whole function immediately, you'd actually get `"Fizz"` for 15 and never reach the FizzBuzz check at all. Order and branch structure both matter here.

**Why the combined check comes first:** if `elif n % 3 == 0` were checked before the combined `and` condition, every multiple of 15 would match "divisible by 3" first and return `"Fizz"`, and the `"FizzBuzz"` branch would become unreachable dead code. Always check the more specific condition before the more general one when they overlap.

**Why `for`, not `while`:** the range 1–20 is a fixed, known sequence decided before the loop starts — there's no condition being waited on. A `while` version would need a manual counter variable and manual increment, adding a chance to get the boundary wrong (off-by-one) for no benefit.

**Comprehension vs. loop-with-append:** the comprehension `[classify(n) for n in range(1, 21)]` is preferred when you need the resulting list as a value to use later (pass to another function, compare, store). The explicit `for` + `.append()` loop is more natural when you're doing something per-item as you go (like printing immediately, as this exercise also does) rather than collecting a final result.

## Common Pitfalls

- Checking `n % 3 == 0` before the combined `and` condition — silently makes the FizzBuzz case unreachable (a classic guard-clause-ordering mistake, just inverted: here the *specific* case must come first, not last).
- Using `while` with a manual counter for a fixed, known range — works, but adds unnecessary state and an easy-to-get-wrong increment/boundary condition for no benefit over `for`.
