# 05 — Control Flow

[Back to course overview](../README.md) | [Previous: Operators](../04-Operators/README.md)

## Beginner: `if` / `elif` / `else`

```python
temperature = 15

if temperature > 30:
    print("hot")
elif temperature > 15:
    print("warm")
else:
    print("cool")   # 15 is not > 30 and not > 15, so this branch runs
```

Python has no `switch` statement in the C/Java sense (it does have `match`, see below). Conditions don't need parentheses, and there's no braces — indentation *is* the block structure, so a wrongly indented line silently belongs to the wrong block instead of raising a compile error the way a misplaced brace would.

Any value can be used as a condition, not just `bool`. Python's **truthiness** rules: `0`, `0.0`, `""`, `[]`, `{}`, `set()`, and `None` are all falsy; virtually everything else is truthy.

```python
items = []
if items:
    print("has items")
else:
    print("empty")   # this branch runs - an empty list is falsy
```

## Beginner: `for` Loops

Python's `for` iterates directly over a sequence's elements — it's a "for-each" loop, not a C-style counter loop with an index variable you manage yourself.

```python
for fruit in ["apple", "banana", "cherry"]:
    print(fruit)

for i in range(3):        # range(3) -> 0, 1, 2
    print(i)

for index, fruit in enumerate(["apple", "banana"]):
    print(index, fruit)   # 0 apple / 1 banana
```

`range(stop)`, `range(start, stop)`, and `range(start, stop, step)` generate numbers lazily (they don't build a full list in memory) and `stop` is always **exclusive** — `range(3)` never produces `3`.

## Beginner: `while` Loops

```python
count = 0
while count < 3:
    print(count)
    count += 1
```

A `while` loop keeps running as long as its condition is truthy, re-checking the condition before every iteration (including the first). Unlike `for`, nothing about a `while` loop guarantees termination — you are responsible for making the condition eventually false, or you get an infinite loop.

## Intermediate: `break`, `continue`, and the Loop `else` Clause

- `break` exits the loop immediately, skipping any remaining iterations.
- `continue` skips the rest of the current iteration and moves to the next one.
- Both `for` and `while` loops can have an `else` clause — a feature most languages don't have and most Python developers forget exists.

**The loop's `else` runs only if the loop finished naturally (no `break` occurred).** If a `break` fires, `else` is skipped entirely. This makes it a clean way to express "search, and do something only if nothing was found":

```python
def find_first_negative(numbers):
    for n in numbers:
        if n < 0:
            print(f"found a negative: {n}")
            break
    else:
        print("no negative numbers found")

find_first_negative([1, 2, 3])     # loop completes -> else runs -> "no negative numbers found"
find_first_negative([1, -2, 3])    # break fires -> else is skipped -> "found a negative: -2"
```

A mental model that sticks: think of it as "for/else" meaning **"for, or else (if nothing was found)"** — not "for, then unconditionally else" like an `if`/`else`.

```python
for n in range(5):
    if n == 10:      # never true - loop runs to completion
        break
    print(n)
else:
    print("loop finished without breaking")   # this DOES run
```

## Advanced: Structural Pattern Matching (`match`)

Introduced in Python 3.10, `match` compares a subject against a series of **patterns**, not just equality checks like a C `switch`. The simplest form matches literal values:

```python
def describe_status(code):
    match code:
        case 200:
            return "OK"
        case 404:
            return "Not Found"
        case 500:
            return "Server Error"
        case _:
            return "Unknown status"
```

`case _:` is the **wildcard pattern** — it matches anything, functioning as the "default" branch. Without it, if no case matches, `match` simply falls through and does nothing (no error is raised).

Use `|` for **OR patterns**, matching several literals with one `case`:

```python
def is_weekend(day):
    match day:
        case "Saturday" | "Sunday":
            return True
        case "Monday" | "Tuesday" | "Wednesday" | "Thursday" | "Friday":
            return False
        case _:
            raise ValueError(f"not a valid day: {day}")
```

`match` can also destructure sequences and objects (`case [x, y]:`, `case Point(x=0, y=0):`) and bind variables out of the pattern — that structural destructuring is what distinguishes it from a plain `switch`, though the literal/OR/wildcard forms above cover the everyday use cases.

## Real-World Usage

- The loop `else` clause shows up in search/validation code: iterate over candidates, `break` when you find a match, and use `else` for the "not found" fallback — avoiding a separate `found = False` flag variable.
- `match` is commonly used for parsing command/event types (HTTP methods, CLI subcommands, message types from a queue) where a small closed set of string/enum values maps to different handling branches.
- `while True:` combined with an internal `break` condition is the standard idiom for "loop until some condition met inside the loop body," such as reading input until a sentinel value appears.

## Summary

- `if`/`elif`/`else` branch on truthiness, not just `bool`; empty containers and `0`/`""`/`None` are falsy.
- `for` iterates directly over elements; `range()` is exclusive of its `stop` value and lazy.
- `while` re-checks its condition every iteration and has no built-in termination guarantee.
- `break` exits a loop early; `continue` skips to the next iteration.
- The loop `else` clause runs only when the loop completes without hitting `break` — it does not run after a loop that broke early.
- `match` (3.10+) supports literal patterns, `|` for OR patterns, and `_` as a wildcard/default.

## Key Terms

- **Truthiness** — whether a non-boolean value is treated as `True` or `False` in a boolean context.
- **Loop `else` clause** — code that runs only if the loop ran to completion without a `break`.
- **`break`** — immediately exits the enclosing loop.
- **`continue`** — skips the remainder of the current iteration and proceeds to the next.
- **Structural pattern matching** — `match`/`case`, comparing a subject against patterns (literals, OR patterns, wildcards, and destructuring patterns) rather than only equality.
- **Wildcard pattern (`_`)** — a `case` pattern that matches anything, used as the default/catch-all.

## Common Mistakes

- Assuming the loop `else` behaves like an `if`/`else` (always runs) — it only runs when no `break` occurred.
- Writing a `while` loop and forgetting to update the condition variable, causing an infinite loop.
- Treating `range(n)` as inclusive of `n` — it stops one before `n`.
- Forgetting `case _:` in a `match` and being surprised when no branch runs for an unhandled value instead of getting an error.
- Using `match` where a simple `if`/`elif` chain would be clearer for a small number of non-literal, overlapping conditions — `match` shines with clean, mutually exclusive patterns.

## Best Practices

- Use the loop `else` clause for "search and report not-found" logic instead of a manual `found` boolean flag.
- Prefer `for item in collection` over manually indexing with a counter; reach for `enumerate()` only when you actually need the index.
- Always include `case _:` in a `match` unless you deliberately want unmatched values to silently do nothing.
- Keep `while True:` loops readable by putting the exit condition's `break` near the top of the loop body, not buried deep inside nested logic.

## Interview Questions

1. **What does the `else` clause on a `for`/`while` loop actually do?**
   It runs only if the loop completed all its iterations without hitting a `break`. If the loop never executes a `break`, `else` runs after the loop finishes (including the case where the loop body never ran at all, e.g. an empty iterable). If `break` fires, `else` is skipped.

2. **How is `range(stop)` different from a hand-written counter loop that goes up to and including `stop`?**
   `range(stop)` produces values from `0` up to but **excluding** `stop` — `range(5)` yields `0, 1, 2, 3, 4`, never `5`. This exclusive-upper-bound convention matches slicing and is a common off-by-one trap for people expecting an inclusive range.

3. **What's the difference between `break` and `continue`?**
   `break` terminates the loop entirely — no further iterations run. `continue` only skips the rest of the *current* iteration's body and moves on to the next iteration; the loop keeps running.

4. **How does Python's `match` statement differ from a `switch` statement in C or Java?**
   `switch` only compares a value for equality against constants. `match` supports full **structural pattern matching** — literal patterns, `|` OR patterns, wildcards, and destructuring patterns that can pull values out of sequences or objects and bind them to names as part of the match itself, not just branch on a scalar value.

5. **What happens if a `match` statement has no matching `case` and no wildcard `_`?**
   Nothing — `match` simply does nothing and execution continues after the statement, no error is raised. This is why omitting `case _:` is a common bug source: unmatched inputs fail silently instead of loudly.

## Suggested Next Lesson

[06 — Functions](../06-Functions/README.md)
