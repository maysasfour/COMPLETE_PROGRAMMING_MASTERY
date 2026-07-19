# 06 — Functions

[Back to course overview](../README.md) | [Previous: Control Flow](../05-Control-Flow/README.md)

## Beginner: Defining a Function

```r
greet <- function(name) {
  paste("Hello,", name)
}

greet("Ada")   # "Hello, Ada"
```

Functions are values in R, assigned like anything else with `<-`. The last evaluated expression in the body is returned automatically — `return()` is optional (though explicit `return()` is common for early exits or clarity).

## Beginner: Default Arguments

```r
greet <- function(name, greeting = "Hello") {
  paste0(greeting, ", ", name, "!")
}

greet("Ada")              # "Hello, Ada!"
greet("Ada", "Hi")         # "Hi, Ada!"
greet("Ada", greeting = "Hey")  # "Hey, Ada!" - named argument, order doesn't matter
```

## Intermediate: `...` (Variadic Arguments)

`...` collects any number of extra, unnamed-in-the-signature arguments — R's equivalent of Python's combined `*args`/`**kwargs`:

```r
sum_all <- function(...) {
  sum(...)
}
sum_all(1, 2, 3, 4)   # 10

log_message <- function(prefix, ...) {
  cat(prefix, ..., "\n")
}
log_message("INFO:", "server started on port", 8080)
```

`...` is commonly forwarded into another function that itself accepts variable arguments (as with `sum(...)` above), which is how R lets wrapper functions transparently pass through whatever extra arguments the caller provided.

## Intermediate: Vectorized Functions vs. Explicit Loops

A function written for "one value" in R usually already works for a whole vector, because the operators/functions it calls are themselves vectorized:

```r
square <- function(x) x^2
square(5)             # 25
square(c(1, 2, 3, 4))  # 1 4 9 16 - works on the whole vector, no changes needed
```

When a function genuinely can't be vectorized directly (e.g. it calls another function that only accepts one value at a time), `sapply`/`lapply` apply it element-by-element and collect the results — previewed here, covered in depth in Lesson 12:

```r
# sapply simplifies the result to a vector when possible
sapply(c(1, 2, 3), function(x) x^2)   # 1 4 9

# lapply always returns a list, useful when results aren't uniform
lapply(c(1, 2, 3), function(x) x^2)   # list(1, 4, 9)
```

Prefer writing genuinely vectorized code (`square` above) over `sapply` whenever possible — `sapply` is still a loop under the hood, just a more convenient one (Lesson 14 measures the real performance difference).

## Real-World Usage

- Default arguments are the standard way R packages expose configurable behavior without forcing every caller to specify every option (e.g. `read.csv(file, header = TRUE, sep = ",")`, Lesson 10).
- `...` forwarding is everywhere in real R code, especially in wrapper functions that add a little behavior around an existing function while still accepting all of its original arguments.

## Summary

- Functions are defined with `function(args) { body }` and assigned like any value; the last expression's value is returned automatically.
- Default arguments use `name = default` in the signature; named arguments can be passed in any order at the call site.
- `...` collects variable extra arguments and can be forwarded into another variadic function.
- Functions written for a single value are often already vectorized for free, because the built-in operators/functions they use are vectorized; `sapply`/`lapply` handle the remaining cases where explicit per-element iteration is needed.

## Key Terms

- **Default argument** — a parameter with a `name = value` in the function signature, used when the caller doesn't supply that argument.
- **`...` (dots)** — collects an arbitrary number of extra arguments, forwardable into another function.
- **`sapply`** — applies a function to each element of a vector/list and simplifies the result to a vector/matrix when possible.
- **`lapply`** — applies a function to each element and always returns a list.

## Common Mistakes

- Forgetting that the *last* expression, not necessarily an explicit `return()`, is what a function returns — an unintended earlier expression at the end silently becomes the return value.
- Writing an explicit loop to apply an operation element-by-element when the operation was already vectorized and `f(vector)` would have worked directly.
- Not forwarding `...` in a wrapper function, silently dropping extra arguments the caller expected to pass through.

## Best Practices

- Prefer genuinely vectorized code over `sapply`/`lapply` over an explicit `for` loop, in that order of preference, for pure computation (Lesson 14 quantifies why).
- Use default arguments to make the common case simple while still allowing full configurability.
- Document what `...` is forwarded to, since its contents aren't visible in the function signature itself.

## Interview Questions

1. **How does R decide what a function returns if there's no explicit `return()`?**
   The value of the last evaluated expression in the function body is returned automatically.

2. **What is `...` used for?**
   It collects an arbitrary number of additional arguments not explicitly named in the function signature, commonly forwarded into another function that itself accepts variable arguments.

3. **Why might a function written for "one value" already work on an entire vector?**
   Because the operators and base functions it uses internally (like `^`, `+`, etc.) are themselves vectorized — the function inherits that vectorization for free, with no extra code.

4. **When would you reach for `sapply`/`lapply` instead of writing a vectorized expression directly?**
   When the operation genuinely can't be vectorized directly — for example, when it calls another function (often from a package) that's only defined to accept one value at a time.

## Suggested Next Lesson

[07 — Vectors, Lists, and Data Frames](../07-Vectors-Lists-and-Data-Frames/README.md)
