# 07 — Vectors, Lists, and Data Frames

[Back to course overview](../README.md) | [Previous: Functions](../06-Functions/README.md)

## Beginner: Vectors — Homogeneous Sequences

A vector holds elements that are **all the same type** (Lesson 03 established every value is already a vector; this lesson focuses on multi-element vectors):

```r
nums <- c(10, 20, 30)
names_vec <- c("Ann", "Bob", "Cid")

nums[2]        # 20 - 1-based indexing (Lesson 05)
length(nums)   # 3
```

## Beginner: Lists — Heterogeneous Containers

A list can hold elements of **different types**, including other lists and vectors of different lengths — R's answer to Python's mixed-type list/dict-ish needs:

```r
person <- list(name = "Ada", age = 36, active = TRUE)

person$name    # "Ada" - $ accesses a named element
person[["age"]]  # 36 - [[ ]] also accesses by name or position, returns the raw element
person["age"]    # a LIST containing just "age" - single brackets return a sub-list, not the raw value!
```

`[[` vs `[` on a list is a real distinction: `person[["age"]]` unwraps to the actual value (`36`), while `person["age"]` returns a **list of length 1** still wrapping it. This mirrors (in spirit) Python's difference between indexing a dict directly vs. slicing.

## Beginner: Data Frames — R's Signature Structure

A data frame is R's core structure for **tabular data** — conceptually a list of equal-length vectors (columns), each of which can be a different type, displayed as rows and columns like a spreadsheet or SQL table:

```r
df <- data.frame(
  name = c("Ann", "Bob", "Cid"),
  age  = c(28, 34, 41),
  active = c(TRUE, FALSE, TRUE)
)

print(df)
#   name age active
# 1  Ann  28   TRUE
# 2  Bob  34  FALSE
# 3  Cid  41   TRUE
```

## Intermediate: Real Column and Row Operations

```r
df$age              # the age column as a plain numeric vector: 28 34 41
df[["age"]]          # same thing, [[ ]] form
df[, "age"]           # same thing again, matrix-style column selection

df[1, ]                # the first ROW (a one-row data frame)
df[df$age > 30, ]       # ROWS where age > 30 - boolean row filtering, very common

df$is_senior <- df$age >= 35   # add a new column computed from an existing one, vectorized
nrow(df)   # 3
ncol(df)   # now 4, after adding is_senior
```

`df[row, col]` follows matrix-style `[row, column]` indexing; leaving either side blank (`df[1, ]` or `df[, "age"]`) means "all of that dimension." This is verified live in `example.R`, including adding a computed column and filtering rows by a condition.

## Advanced: `str()` and Inspecting Structure

```r
str(df)   # compact display of a data frame's structure: column names, types, first few values
```

`str()` is the single most useful "what am I actually looking at" command in R — it's the first thing experienced R users run on any unfamiliar object.

## Real-World Usage

- Data frames are the central object in almost every real R script: reading a CSV (Lesson 10) produces a data frame, and the vast majority of data-analysis code is column selection, row filtering, and computed columns exactly as shown above.
- Lists are the standard way to return **multiple, differently-typed values** from a function (e.g., a fitted model's coefficients, residuals, and call all bundled in one list) — R functions can only return one object, so a list is how you bundle several results together.

## Summary

- Vectors hold homogeneous elements; lists hold heterogeneous elements (including nested lists/vectors of any length).
- `$` and `[[ ]]` access a list element directly (unwrapped); `[ ]` on a list returns a sub-list, not the raw value.
- Data frames are R's tabular data structure — a list of equal-length columns, displayed as rows and columns.
- `df$col`, `df[["col"]]`, and `df[, "col"]` all select a column; `df[row, ]` selects rows; boolean row filtering (`df[condition, ]`) and computed columns (`df$new <- expr`) are the everyday idioms.
- `str()` is the standard way to quickly inspect any R object's structure.

## Key Terms

- **Vector** — a homogeneous, ordered sequence of values.
- **List** — a heterogeneous, ordered collection that can nest lists/vectors of differing types and lengths.
- **Data frame** — R's tabular structure: a list of equal-length columns of (possibly differing) types, indexed like a matrix by `[row, column]`.
- **`str()`** — prints a compact summary of an object's structure.

## Common Mistakes

- Using `person["age"]` when you meant `person[["age"]]` or `person$age` — single brackets on a list return a wrapping sub-list, not the raw value, which silently breaks arithmetic on the result.
- Forgetting `df[, "col"]` and `df["col"]` behave differently for data frames vs. plain lists — for data frames, `df["col"]` actually *does* return a one-column data frame (not identical to `df[["col"]]`'s plain vector), a subtlety worth checking with `class()` when in doubt.
- Assuming a data frame column stays the same type after a filter that produces zero rows — inspect with `str()`/`nrow()` rather than assuming.

## Best Practices

- Use `str()` on any unfamiliar object before writing code against it.
- Prefer `df$col` or `df[["col"]]` when you want the raw vector; only use single-bracket subsetting when you deliberately want a smaller data frame/list back.
- Build new columns with vectorized expressions (`df$new <- df$a + df$b`) rather than row-by-row loops.

## Interview Questions

1. **What's the difference between a vector and a list in R?**
   A vector holds elements that are all the same type; a list can hold elements of different types (including nested lists and vectors of different lengths).

2. **What's the difference between `person["age"]` and `person[["age"]]` on a list?**
   `person[["age"]]` returns the raw, unwrapped value (`36`). `person["age"]` returns a list of length 1 that still wraps that value — a common source of confusion for beginners.

3. **What is a data frame, structurally?**
   A list of equal-length vectors (the columns), each potentially a different type, presented and indexed like a table with rows and columns.

4. **How do you filter a data frame's rows based on a condition?**
   `df[df$column > value, ]` — a boolean vector (from the condition) inside the row position of `[row, col]` indexing, keeping only the rows where the condition is `TRUE`.

## Suggested Next Lesson

[08 — Strings](../08-Strings/README.md)
