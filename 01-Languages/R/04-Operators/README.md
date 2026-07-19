# 04 — Operators

[Back to course overview](../README.md) | [Previous: Variables and Data Types](../03-Variables-and-Data-Types/README.md)

## Beginner: Vectorized Arithmetic — No Loop Needed

Because every value is a vector (Lesson 03), arithmetic operators work **element-wise across entire vectors** with no explicit loop:

```r
a <- c(1, 2, 3)
b <- c(10, 20, 30)
a + b   # 11 22 33 - element-wise, verified live
a * b   # 10 40 90
```

Compare this to a language without vectorization, where you'd write `for (i in seq_along(a)) result[i] <- a[i] + b[i]`. In R, `a + b` already *is* that loop, implemented internally in fast compiled code (Lesson 14 measures exactly how much faster).

## Beginner: Standard Operators

```r
5 + 3    # 8
5 - 3    # 2
5 * 3    # 15
5 / 3    # 1.666667 - always returns a double, even for two integers
5 %% 3   # 2  - modulo
5 %/% 3  # 1  - integer division
5 ^ 2    # 25 - exponentiation (** also works but ^ is idiomatic)

5 > 3    # TRUE
5 == 5   # TRUE
5 != 3   # TRUE
```

## Intermediate: The Recycling Rule — A Genuine Gotcha

When two vectors of **different, unevenly-divisible lengths** are combined, R **recycles** (repeats) the shorter one to match the longer one's length — silently, with only a warning (not an error) when the lengths don't divide evenly:

```r
c(1, 2, 3, 4) + c(10, 20)          # 11 22 13 24 - shorter vector (10,20) recycled: (10,20,10,20)
c(1, 2, 3, 4) + c(10, 20, 30)      # WARNING: longer object length is not a multiple of shorter object length
                                     # still computes something, but it's a real bug in your logic if unintended
```

The rule: if `length(longer) %% length(shorter) == 0`, recycling happens silently with no warning at all (e.g. length 4 + length 2). If it does *not* divide evenly, R still recycles but **emits a warning** — it does not stop execution. This is verified live in `example.R`, including capturing the actual warning text R produces.

This is a genuine, well-known R gotcha: forgetting vector lengths must match (or evenly divide) can silently produce wrong results with no error, only an easy-to-miss warning.

## Advanced: Logical Operators — `&`/`|` vs `&&`/`||`

R has two families of logical operators that are **not interchangeable**:

- `&` and `|` are **vectorized** — they compare element-wise across entire vectors.
- `&&` and `||` only look at the **first element** of each side and are used for single-value conditions, such as inside `if()`.

```r
c(TRUE, FALSE) & c(TRUE, TRUE)   # TRUE FALSE - element-wise
TRUE && FALSE                     # FALSE - single logical value only

if (c(TRUE, FALSE) && TRUE) { }   # ERROR in modern R - && requires length-1 operands
```

Since R 4.3, using `&&`/`||` with a vector of length > 1 raises an **error**, not just a warning (this was a warning in earlier R versions) — a deliberate tightening precisely because mixing these up used to silently do the wrong thing.

## Real-World Usage

- Vectorized arithmetic is the backbone of any real R data-analysis script: computing a new column as a function of existing columns (`df$total <- df$price * df$quantity`) touches every row in one vectorized expression, never a manual loop.
- The recycling rule is genuinely dangerous in real code when you *intend* two same-length vectors but a bug (a filtering step that accidentally dropped rows) leaves them different lengths — R won't stop you, it will just silently produce wrong numbers unless the lengths happen not to divide evenly (in which case at least you get a warning).

## Summary

- Arithmetic operators (`+ - * / %% %/% ^`) are vectorized: they apply element-wise across whole vectors, with no explicit loop.
- The recycling rule repeats a shorter vector's values to match a longer vector's length; a warning (not an error) is emitted only when lengths don't divide evenly — verified live, including the actual warning text.
- `&`/`|` are element-wise vectorized logical operators; `&&`/`||` are single-value only and now (R 4.3+) error on vectors longer than 1.

## Key Terms

- **Vectorized operation** — an operation applied element-wise across an entire vector without an explicit loop.
- **Recycling rule** — R's behavior of repeating a shorter vector's elements to match a longer vector's length during element-wise operations.
- **`&`/`|`** — vectorized (element-wise) logical AND/OR.
- **`&&`/`||`** — single-value (short-circuiting) logical AND/OR, used in `if()` conditions.

## Common Mistakes

- Assuming mismatched-length vector arithmetic always errors — it usually just recycles silently or with a warning, never stopping execution outright.
- Using `&`/`|` inside an `if()` condition on vectors longer than 1 (should use `&&`/`||`, and only on length-1 conditions).
- Forgetting `/` always returns a double even between two integers — use `%/%` for integer division.

## Best Practices

- Before combining two vectors arithmetically, verify their lengths match (or that recycling is genuinely intended) — `length(a) == length(b)` as a sanity check in non-trivial code.
- Use `&&`/`||` only for single-value conditions (`if` guards); use `&`/`|` for element-wise vector logic.
- Treat any recycling warning as a signal to check your data pipeline for an unexpected length mismatch, not noise to ignore.

## Interview Questions

1. **What is R's recycling rule?**
   When two vectors of different lengths are combined in an element-wise operation, R repeats (recycles) the shorter vector's values to match the longer vector's length. If the longer length isn't an exact multiple of the shorter one, R still computes a result but emits a warning.

2. **What's the difference between `&` and `&&` in R?**
   `&` is vectorized and compares element-wise across entire vectors; `&&` only evaluates the first element of each side and is meant for single-value conditions like `if()` guards. As of R 4.3, using `&&`/`||` on a vector longer than 1 is an error, not just a warning.

3. **Why does `5 / 3` return a double even with two whole numbers?**
   R's `/` always performs floating-point division regardless of operand types; use `%/%` explicitly if you want integer (floor) division.

## Suggested Next Lesson

[05 — Control Flow](../05-Control-Flow/README.md)
