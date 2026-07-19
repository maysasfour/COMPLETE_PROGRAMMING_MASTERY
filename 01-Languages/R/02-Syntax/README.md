# 02 — Syntax

[Back to course overview](../README.md) | [Previous: Setup](../01-Setup/README.md)

## Beginner: Assignment — `<-` vs `=`

R has two assignment operators. `<-` is idiomatic R; `=` also works at the top level but is conventionally reserved for naming function arguments.

```r
x <- 10        # idiomatic
y = 20         # also legal, but not the R convention
print(x)
```

The important, genuinely surprising difference shows up **inside a function call**:

```r
mean(x = c(1, 2, 3))   # x is a named ARGUMENT to mean(), local to the call
print(x)                # still 10 - the call-local `x =` never touched the outer x
```

`<-` always creates/updates a variable in the current environment; `=` inside a function call argument list only names that argument and does not leak out. This is verified live in `example.R`.

## Beginner: No Semicolons Required

Statements are separated by newlines, not semicolons. Semicolons are legal (to put multiple statements on one line) but are almost never used in idiomatic R:

```r
a <- 1
b <- 2         # each on its own line - the normal style
a <- 1; b <- 2  # legal but not idiomatic
```

## Beginner: Comments

Only `#` — there is no multi-line comment syntax in base R.

```r
# this is a comment - the ONLY comment style R has
x <- 5  # comments can trail code too
```

## Intermediate: The Right-Assign Arrow

R also has `->`, which assigns left-to-right (rare, but you'll see it in pipelines):

```r
5 -> z
print(z)   # 5
```

## Intermediate: `<<-` (Preview)

`<<-` is the **superassignment** operator — it assigns in an enclosing (parent) scope rather than the current function's local scope, primarily used to modify variables from inside closures. Covered in depth in Lesson 12 (Functional Concepts); mentioned here only so the syntax isn't a total surprise later.

## Real-World Usage

- Idiomatic R style guides (Google's, tidyverse's) both mandate `<-` for assignment and `=` only for named arguments — following this convention makes your code instantly readable to any other R programmer.
- Because `=` and `<-` differ inside call argument lists, mixing them carelessly (`f(x <- 1)` instead of `f(x = 1)`) is a real, if uncommon, source of confusion — `x <- 1` inside a call still assigns `x` in the enclosing scope **and** passes its value positionally, which is rarely what's intended.

## Summary

- `<-` is the idiomatic assignment operator; `=` is reserved for naming function arguments by convention.
- Inside a function call, `name = value` names an argument local to that call; it does not assign in the outer scope. `<-` always assigns in the current environment.
- No semicolons needed; newlines separate statements.
- Only `#` for comments — no block-comment syntax.
- `->` assigns left-to-right; `<<-` is superassignment (Lesson 12).

## Key Terms

- **`<-`** — the idiomatic left-assignment operator.
- **`=`** — top-level assignment (works but unconventional) or named-argument syntax inside a call.
- **`->`** — right-assignment (rare).
- **`<<-`** — superassignment, writes to an enclosing scope.

## Common Mistakes

- Using `=` everywhere out of habit from other languages, instead of `<-` for assignment.
- Not realizing `f(x = 1)` does not create a variable `x` in the calling scope.
- Forgetting R has no block comments — commenting out a multi-line chunk requires prefixing every line with `#`.

## Best Practices

- Use `<-` for assignment; use `=` only for named function arguments.
- Keep one statement per line; don't rely on semicolons for readability.

## Interview Questions

1. **What's the practical difference between `<-` and `=` in R?**
   Both assign at the top level, but `<-` is idiomatic and always performs assignment; `=` inside a function call names an argument for that call only and does not assign a variable in the calling environment.

2. **Does R require semicolons at the end of statements?**
   No — newlines separate statements. Semicolons are legal for putting multiple statements on one line but are not idiomatic.

3. **How do you write a multi-line comment in R?**
   You can't, directly — base R only has single-line `#` comments; every line of a "multi-line comment" needs its own `#`.

## Suggested Next Lesson

[03 — Variables and Data Types](../03-Variables-and-Data-Types/README.md)
