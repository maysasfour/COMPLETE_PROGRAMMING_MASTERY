# 03 — Variables and Data Types

[Back to course overview](../README.md) | [Previous: Syntax](../02-Syntax/README.md)

## Beginner: There Is No Scalar — Everything Is a Vector

This is the single most distinctive fact about R's type system: **there is no standalone "scalar" type**. A single number is a **vector of length 1**. This is verified live in `example.R`:

```r
x <- 42
is.vector(x)   # TRUE
length(x)      # 1 - a "single number" is a length-1 vector
class(x)       # "numeric"
```

Every arithmetic operation, every comparison, is defined in terms of vectors — a "scalar" is just the degenerate one-element case. This is *why* R's arithmetic is vectorized by default (Lesson 04): there's no special-casing needed between "one number" and "many numbers," they're the same kind of thing.

## Beginner: The Basic Atomic Types

```r
n <- 42          # numeric (double-precision, the default for any number)
i <- 42L         # integer (the L suffix forces integer storage)
s <- "hello"     # character
b <- TRUE        # logical (TRUE/FALSE, not True/False)
cplx <- 2+3i     # complex (rare in everyday code, exists for completeness)
```

```r
class(42)     # "numeric"
class(42L)    # "integer"
class("hi")   # "character"
class(TRUE)   # "logical"
```

Note the naming: R calls its string type `character`, not `string`.

## Beginner: `NA` — The Explicit "Missing Value" Marker

`NA` represents a **missing / unknown value in a specific slot of data** — it is R's answer to "we have a data point here, but we don't know what it is," which is central to statistical computing (a survey respondent who skipped a question, a sensor reading that failed).

```r
x <- c(1, 2, NA, 4)
sum(x)             # NA - any operation touching NA propagates it
sum(x, na.rm = TRUE)  # 7 - explicitly tell R to skip NA values
is.na(x)           # FALSE FALSE TRUE FALSE
```

## Beginner: `NA` vs `NULL` — Genuinely Different Things

This distinction trips up almost everyone new to R:

- **`NA`** is a placeholder for a *missing value within a vector* — the vector still has that slot, it's just unknown. `NA` has a length of 1 and occupies a position.
- **`NULL`** represents the *absence of a value entirely* — "there is nothing here at all," not even a placeholder slot. `NULL` has length 0.

```r
length(NA)     # 1   - NA occupies a slot
length(NULL)   # 0   - NULL is nothing, not even a slot

x <- c(1, 2, NA, 4)
length(x)      # 4 - NA counts as an element

y <- c(1, 2, NULL, 4)
length(y)      # 3 - NULL simply vanishes when combined into a vector!
```

That last line is a genuine gotcha: `c()` silently drops `NULL` values rather than keeping a "slot" for them, while `NA` always keeps its slot. This is verified live in `example.R`.

## Intermediate: `typeof()` vs `class()`

`typeof()` reports R's low-level internal storage type; `class()` reports the higher-level object-oriented class (Lesson 11). For atomic vectors they often look similar but aren't always identical:

```r
typeof(42)      # "double"
class(42)       # "numeric"
typeof(42L)     # "integer"
class(42L)      # "integer"
typeof(TRUE)    # "logical"
class(TRUE)     # "logical"
```

## Intermediate: Dynamic Typing and Coercion

Like Python, a variable name has no fixed type — it can be reassigned to any type. Combining mixed types into one vector **coerces everything to the least restrictive common type** (logical → integer → numeric → character):

```r
c(1, "two", TRUE)   # all become character: "1" "two" "TRUE"
c(1, TRUE)          # all become numeric: 1 1  (TRUE becomes 1)
```

## Real-World Usage

- `NA` handling is central to nearly every real R data-analysis script — raw datasets (CSVs, survey exports, sensor logs) are full of missing values, and functions like `mean()`, `sum()`, `sd()` all default to propagating `NA` unless you pass `na.rm = TRUE`, forcing you to make an explicit decision rather than silently guessing.
- Because every value is "a vector," functions written for a single value automatically work on many values with no code changes — this underlies R's vectorization idiom (Lesson 04, Lesson 14).

## Summary

- There is no scalar type in R — a single value is a length-1 vector; verified live with `length()`/`is.vector()`.
- Core atomic types: `numeric` (double by default), `integer` (`L` suffix), `character`, `logical`, `complex`.
- `NA` marks a missing value *within* a vector (occupies a slot, propagates through operations unless `na.rm = TRUE`); `NULL` means "nothing at all" (length 0, and vanishes when combined into a vector with `c()`).
- `typeof()` is the low-level storage type; `class()` is the higher-level class used for dispatch (Lesson 11).
- Combining mixed types with `c()` coerces to the least restrictive common type.

## Key Terms

- **Atomic vector** — R's fundamental data structure; a length-1-or-more sequence of values all of the same type.
- **`NA`** — missing-value marker; occupies a slot, has a length of 1, propagates through most operations.
- **`NULL`** — represents "no value at all"; has length 0 and is dropped when combined into a vector.
- **Coercion** — automatic conversion to a common type when mixing types in one vector.
- **`typeof()` / `class()`** — low-level storage type vs. higher-level object class.

## Common Mistakes

- Assuming `NA` and `NULL` are interchangeable — they behave completely differently in `length()` and inside `c()`.
- Forgetting `sum()`/`mean()` return `NA` by default when the data contains any `NA`, and not knowing about `na.rm = TRUE`.
- Believing a single number is a fundamentally different kind of object from a vector — in R it's the same thing, just length 1.
- Expecting `c(1, "two")` to keep `1` numeric — it silently becomes the character `"1"`.

## Best Practices

- Always decide deliberately how to handle `NA` (`na.rm = TRUE`, `is.na()` filtering, imputation) rather than letting it silently propagate into a result.
- Use `NULL` to represent "this argument/slot is absent," and `NA` to represent "this data point is missing" — don't conflate the two in your own function design.
- Use `L` suffix (`5L`) when you specifically need integer storage (e.g., for interfacing with code that distinguishes integer from double).

## Interview Questions

1. **Is there a scalar type in R?**
   No — every value, including a single number, is a vector; a "scalar" is just a vector of length 1.

2. **What's the difference between `NA` and `NULL`?**
   `NA` marks a missing value within a data structure — it occupies a slot and has length 1. `NULL` represents the complete absence of a value — it has length 0 and disappears when combined into a vector with `c()`.

3. **Why does `sum(c(1, 2, NA))` return `NA` instead of `3`?**
   Because R propagates missingness by default — arithmetic touching an unknown value is itself unknown, unless you explicitly opt out with `na.rm = TRUE`, which forces an intentional decision rather than a silent guess.

4. **What happens when you combine values of different types with `c()`?**
   R coerces every element to the least restrictive common type present (logical → integer → numeric → character), so `c(1, "two")` produces two character strings, not a mixed-type vector.

## Suggested Next Lesson

[04 — Operators](../04-Operators/README.md)
