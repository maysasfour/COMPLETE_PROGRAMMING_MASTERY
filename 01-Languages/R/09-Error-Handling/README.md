# 09 — Error Handling

[Back to course overview](../README.md) | [Previous: Strings](../08-Strings/README.md)

## Beginner: `stop()` and `warning()`

```r
divide <- function(a, b) {
  if (b == 0) stop("cannot divide by zero")
  a / b
}

divide(10, 0)   # halts execution with: Error in divide(10, 0) : cannot divide by zero
```

`stop()` raises an error, halting execution (unless caught). `warning()` emits a warning but **does not** stop execution — the function continues running after a warning, unlike an error:

```r
risky <- function(x) {
  if (x < 0) warning("negative input, results may be meaningless")
  abs(x)
}
risky(-5)   # prints a warning, but still returns 5
```

## Beginner: `tryCatch`

`tryCatch` is R's structured error-handling construct, roughly analogous to `try`/`except` in Python:

```r
result <- tryCatch({
  stop("something broke")
}, error = function(e) {
  cat("Caught an error:", conditionMessage(e), "\n")
  "fallback value"
})
print(result)   # "fallback value"
```

`conditionMessage(e)` extracts the human-readable message from the caught condition object.

## Intermediate: `finally` and Multiple Handlers

```r
tryCatch({
  stop("boom")
}, error = function(e) {
  cat("handled:", conditionMessage(e), "\n")
}, warning = function(w) {
  cat("warning handled:", conditionMessage(w), "\n")
}, finally = {
  cat("this always runs, error or not\n")
})
```

`tryCatch` can register separate handlers for `error`, `warning`, and other condition classes; `finally` runs regardless of whether an error/warning occurred.

## Advanced: R's Condition System

R's error handling is built on a general **condition system** — errors and warnings are both specific kinds of "conditions," and you can define custom condition classes (via `structure()` with a `class` attribute, or the `rlang`/`cli` packages in practice) that carry structured data, not just a message string. `tryCatch` dispatches based on condition class, which is why you can have separate `error =` and `warning =` handlers in one call. `withCallingHandlers` (used in Lesson 04's example) is a related, lower-level tool that lets you inspect/react to a condition and then resume execution — useful for muffling a specific warning without aborting the surrounding code, as seen with `invokeRestart("muffleWarning")`.

## Real-World Usage

- Validating function arguments with `stop()` at the top of a function ("fail fast, fail loud") is standard R practice, especially in packages meant for other people to use.
- `tryCatch` around file I/O or network calls (Lesson 10/17) is the standard way to handle a missing file or a failed HTTP request gracefully instead of crashing the whole script.

## Summary

- `stop()` raises an error and halts execution; `warning()` emits a warning but lets execution continue.
- `tryCatch(expr, error = function(e) ..., warning = function(w) ..., finally = ...)` structures error handling around a specific class of condition; `finally` always runs.
- `conditionMessage()` extracts the human-readable text from a caught condition object.
- R's error handling is built on a general condition system that supports custom condition classes beyond just error/warning.

## Key Terms

- **`stop()`** — raises an error, halting execution unless caught.
- **`warning()`** — emits a warning without halting execution.
- **`tryCatch`** — structured handler-based error/condition handling.
- **Condition** — R's general term for a signal (error, warning, or custom) that can be caught and handled.

## Common Mistakes

- Assuming `warning()` halts execution like `stop()` does — it doesn't; the function keeps running after a warning.
- Forgetting `conditionMessage(e)` is needed to get the plain-text message out of the caught condition object `e` (printing `e` directly shows more than just the message).
- Wrapping too much code in one `tryCatch`, making it unclear which specific line actually failed.

## Best Practices

- Validate inputs early with `stop()` so failures happen at the point of misuse, not deep inside unrelated code later.
- Keep `tryCatch` blocks scoped tightly around the specific operation that might fail (a file read, an API call) rather than an entire script.
- Use `warning()` for "this might be a problem but execution can reasonably continue," and `stop()` for "this cannot proceed."

## Interview Questions

1. **What's the difference between `stop()` and `warning()`?**
   `stop()` raises an error and halts execution (unless caught by `tryCatch`); `warning()` prints a warning message but allows the function to keep running and return a value normally.

2. **How does `tryCatch` differ from a plain `try()`?**
   `try()` simply suppresses the error message and lets execution continue at the point after the failing expression, returning a `try-error` object. `tryCatch` lets you register distinct handler functions per condition class (`error`, `warning`, custom classes) and run cleanup code via `finally`, giving much more structured control.

3. **What does `conditionMessage()` do?**
   It extracts the plain-text message from a condition object (an error or warning caught inside a handler function), since the raw condition object itself is a richer structure than just a string.

## Suggested Next Lesson

[10 — File Handling](../10-File-Handling/README.md)
