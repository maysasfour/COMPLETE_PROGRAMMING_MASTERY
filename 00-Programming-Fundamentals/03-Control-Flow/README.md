# 03 — Control Flow

[Back to module overview](../README.md) | [Previous: Variables and Types](../02-Variables-and-Types/README.md)

Control flow is what decides *which lines of code run, and how many times*. Without it, every program is a single straight-line sequence of statements executed exactly once, top to bottom.

## Beginner: Conditions

`if` / `elif` / `else` branch execution based on a boolean expression.

```python
age = 20
if age < 13:
    category = "child"
elif age < 20:
    category = "teenager"
else:
    category = "adult"
```

Only one branch runs. Python evaluates conditions top to bottom and stops at the first `True` one.

## Beginner: Loops

- **`for`** — iterate over a known sequence (list, range, string, dict, file, etc.). Use when you're processing "each item in a collection."
- **`while`** — repeat as long as a condition holds. Use when the number of iterations isn't known ahead of time (waiting for input, retrying until success).

```python
for item in ["a", "b", "c"]:
    print(item)

attempts = 0
while attempts < 3:
    attempts += 1
```

`break` exits a loop immediately; `continue` skips to the next iteration without exiting.

## Intermediate: Expressions vs. Statements

This distinction trips up more people than it should:

- An **expression** *produces a value*. `3 + 4`, `x > 0`, `len(name)`, and even a function call like `greet()` are expressions — you can assign them, pass them as arguments, or print them.
- A **statement** *performs an action* and does not itself produce a usable value. `if`, `for`, `while`, `import`, and assignment (`x = 5`) are statements — you cannot do `y = (x = 5)` in Python.

Python deliberately blurs this line in a few useful, constrained ways:

```python
# Conditional expression (the "ternary" form) - an EXPRESSION, usable anywhere a value is needed
status = "adult" if age >= 18 else "minor"

# Comprehensions are expressions that internally loop - a for LOOP is a statement,
# but a list comprehension is an expression that produces a list value
squares = [n * n for n in range(5)]

# The walrus operator (:=) lets an assignment occur INSIDE an expression context
if (length := len("hello")) > 3:
    print(length)
```

Knowing which is which tells you what's legal where: you can nest expressions arbitrarily deeply, but statements can only appear where the language grammar allows a statement (typically, on their own line/block).

## Advanced: Guard Clauses

A **guard clause** is an early exit at the top of a function that handles an edge case immediately, so the rest of the function can assume that case is already ruled out. This flattens nested conditionals into a linear, readable sequence.

```python
# Deeply nested - each new check indents further
def process_order(order):
    if order is not None:
        if order.items:
            if order.total > 0:
                return ship(order)
            else:
                return None
        else:
            return None
    else:
        return None

# Guard clauses - each check exits immediately, main logic is unindented
def process_order(order):
    if order is None:
        return None
    if not order.items:
        return None
    if order.total <= 0:
        return None
    return ship(order)
```

The guard-clause version reads top to bottom as "rule out the invalid cases, then do the real work" — the "happy path" is never buried three indent levels deep.

## Real-World Usage

- Input validation at the top of a function (guard clauses) is the single most common real-world control-flow pattern — reject bad input immediately instead of nesting the valid-input logic inside it.
- `while True: ... break` is the standard shape for "retry until success or give up," used constantly in networking code, polling, and CLIs.
- Comprehensions (expression-based loops) are preferred in idiomatic Python over manual `for` + `append()` loops when building a new collection from an existing one — they're shorter and signal "I'm transforming a collection" at a glance.

## Summary

- `if`/`elif`/`else` picks one branch; only one runs.
- `for` iterates a known sequence; `while` repeats until a condition becomes false.
- Expressions produce values and can be nested/composed; statements perform actions and are more restricted in where they can appear.
- Guard clauses replace nested conditionals with early returns, keeping the "main" logic unindented and readable.

## Key Terms

- **Condition** — a boolean expression that determines which branch executes.
- **`for` loop** — iterates over a known, finite sequence.
- **`while` loop** — repeats while a condition remains true; iteration count not fixed in advance.
- **Expression** — code that evaluates to a value.
- **Statement** — code that performs an action, not itself a usable value.
- **Guard clause** — an early return/exit that handles an edge case before the main logic runs.
- **`break`** — exits a loop immediately.
- **`continue`** — skips to the next loop iteration.

## Common Mistakes

- Writing an infinite `while` loop by forgetting to update the condition variable inside the loop body.
- Using `for` when a `while` is needed (or vice versa) — a `for` loop over `range()` to fake "loop until a condition" is usually a sign a `while` was the right tool.
- Deep `if` nesting instead of guard clauses, making the "real" logic hard to find.
- Confusing `elif` with a separate `if` — stacking independent `if` statements evaluates *every* condition even after one matched, while `elif` stops at the first match. This matters when conditions have side effects or overlap.

## Interview Questions

1. **What's the difference between `for` and `while` loops, and when would you choose one over the other?**
   `for` iterates a known, finite sequence and is preferred when you're processing "each item in this collection." `while` repeats based on a condition and is preferred when the number of iterations isn't known ahead of time — e.g., reading input until a sentinel value appears.

2. **What's the difference between an expression and a statement?**
   An expression evaluates to a value and can be used anywhere a value is expected (assigned, passed as an argument, nested inside another expression). A statement performs an action and generally cannot be embedded inside an expression. `x + 1` is an expression; `if x:` is a statement.

3. **Why prefer guard clauses over nested `if` statements?**
   Guard clauses handle invalid/edge cases immediately and exit, so the reader never has to hold multiple levels of "what if this branch, and also that branch" in their head to find the main logic. Deep nesting also makes it easy to accidentally write logic that runs when it shouldn't, because a new condition changes what code above it "means."

4. **What happens if you use `elif` vs. separate `if` statements for mutually exclusive conditions?**
   With `elif`, once one branch matches, the rest are skipped entirely. With separate `if` statements, Python evaluates every single one regardless of whether an earlier one matched — wasteful at best, and a correctness bug if conditions overlap or have side effects (e.g., a function call inside the condition running multiple times).

5. **Give an example of Python blurring the expression/statement line, and explain why it's constrained.**
   The conditional expression `x if cond else y` and the walrus operator `(n := compute())` let a value-producing expression appear where you'd otherwise need a full `if` statement. They're intentionally limited in scope (can't contain arbitrary statements) to avoid turning expressions into a way to smuggle multi-step logic into places meant for single values.

## Suggested Next Lesson

[04 — Functions and Scope](../04-Functions-and-Scope/README.md)
