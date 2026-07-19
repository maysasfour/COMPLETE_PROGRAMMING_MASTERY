# 05 — Control Flow

[Back to course overview](../README.md) | [Previous: Operators](../04-Operators/README.md)

## Beginner: `if` / `else`

```r
temperature <- 15

if (temperature > 30) {
  print("hot")
} else if (temperature > 15) {
  print("warm")
} else {
  print("cool")   # runs: 15 is not > 30 and not > 15
}
```

`if`/`else` conditions must evaluate to a single `TRUE`/`FALSE` (length-1 logical) — unlike `&`/`|`, passing a longer vector is an error (Lesson 04).

## Beginner: `for` Loops

```r
for (fruit in c("apple", "banana", "cherry")) {
  print(fruit)
}

for (i in 1:3) {   # 1:3 -> 1, 2, 3 (INCLUSIVE of both ends)
  print(i)
}
```

`for` iterates directly over a vector's (or list's) elements, like Python's `for x in iterable`. `1:3` is R's range operator and is **inclusive on both ends** — unlike Python's `range(3)` (exclusive of the stop value).

## Beginner: `while` Loops

```r
count <- 1
while (count <= 3) {
  print(count)
  count <- count + 1
}
```

## Intermediate: 1-Based Indexing — A Real Gotcha vs. Most Languages

R indexes vectors starting at **1, not 0**. This matches mathematical/statistical convention (a "first observation" is observation 1) but is a genuine, well-documented source of off-by-one bugs for anyone coming from C, Python, Java, JavaScript, or most other mainstream languages (0-indexed):

```r
v <- c("a", "b", "c")
v[1]     # "a" - the FIRST element, not the second
v[0]     # character(0) - an empty vector! Not an error, not the last element - just empty.
v[3]     # "c" - the last element
```

`v[0]` is a real gotcha of its own: it does not error, it silently returns a **zero-length vector**, which can then propagate through further code producing confusing downstream results rather than an immediate loud failure.

Negative indices in R mean **"exclude this position"**, not "count from the end" (unlike Python's `v[-1]` meaning "last element"):

```r
v[-1]    # "b" "c" - everything EXCEPT the first element
v[-c(1,2)]  # "c" - everything except positions 1 and 2
```

This is verified live in `example.R`, comparing directly against what the same expressions would mean in a 0-indexed language.

## Intermediate: `break` and `next`

R uses `next` where Python uses `continue`:

```r
for (i in 1:5) {
  if (i == 3) next    # skip printing 3
  if (i == 5) break    # stop before printing 5
  print(i)
}
# prints: 1 2 4
```

## Advanced: `repeat`

R has a third loop form, `repeat`, which loops forever until an explicit `break` — there's no built-in condition check, you write it yourself:

```r
count <- 1
repeat {
  print(count)
  count <- count + 1
  if (count > 3) break
}
```

## Real-World Usage

- 1-based indexing matters constantly in real data-analysis code: `df[1, ]` is the *first* row of a data frame (Lesson 07), and translating algorithms from 0-indexed pseudocode/other languages requires care at every boundary.
- `vapply`/`sapply` (Lesson 06/12) are generally preferred over hand-written `for` loops for actual computation in idiomatic R, but `for`/`while` remain essential for side-effecting code (printing progress, writing files one at a time).

## Summary

- `if`/`else` requires a length-1 logical condition; `for` iterates directly over vector/list elements; `while` re-checks its condition each iteration; `repeat` loops until an explicit `break`.
- `1:n` is inclusive of both endpoints, unlike Python's exclusive `range()`.
- R vectors are **1-indexed**: `v[1]` is the first element. `v[0]` does not error — it silently returns an empty vector.
- Negative indices mean "exclude this position," not "index from the end."
- `next` skips to the next iteration (Python's `continue`); `break` exits the loop entirely.

## Key Terms

- **1-based indexing** — the first element of a vector is at index 1, not 0.
- **`next`** — R's equivalent of `continue`; skips to the next loop iteration.
- **Negative index** — in R, excludes the given position(s) rather than counting from the end.
- **`repeat`** — an unconditional loop that requires an explicit `break` to terminate.

## Common Mistakes

- Writing `v[0]` expecting either an error or the last element — it silently returns an empty vector instead.
- Assuming `v[-1]` returns the last element (as in Python) — in R it returns everything *except* the first element.
- Off-by-one errors when porting loop logic from a 0-indexed language without adjusting bounds.
- Using `continue` (doesn't exist in R) instead of `next`.

## Best Practices

- When porting algorithms from a 0-indexed language, explicitly re-derive loop bounds rather than assuming a mechanical `-1`/`+1` translation is always correct — check every boundary condition by hand.
- Prefer `seq_along(x)` over `1:length(x)` when writing index-based loops — `1:length(x)` silently misbehaves (counts down from 1 to 0) when `x` has zero elements, while `seq_along(x)` correctly produces an empty sequence.
- Use vectorized alternatives (Lesson 06/12/14) instead of manual loops wherever the loop body has no side effects.

## Interview Questions

1. **Is R 0-indexed or 1-indexed?**
   1-indexed — `v[1]` is the first element of a vector, matching mathematical/statistical convention rather than most mainstream programming languages.

2. **What does a negative index mean in R?**
   Exclusion, not "from the end." `v[-1]` returns every element except the first, unlike Python where `v[-1]` returns the last element.

3. **What happens when you index with `v[0]`?**
   It does not error — it silently returns a zero-length vector, which can cause confusing downstream bugs if not caught early.

4. **Why is `seq_along(x)` preferred over `1:length(x)` in loops?**
   `1:length(x)` breaks silently when `x` is empty: `length(x)` is `0`, and `1:0` produces `c(1, 0)` (R's `:` counts backward when the end is smaller), causing the loop to run with nonsensical indices. `seq_along(x)` correctly returns an empty sequence for an empty `x`, so the loop simply doesn't run.

## Suggested Next Lesson

[06 — Functions](../06-Functions/README.md)
