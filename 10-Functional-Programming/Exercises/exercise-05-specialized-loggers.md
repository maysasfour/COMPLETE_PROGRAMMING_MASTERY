# Exercise 05 — Specialized Loggers

[Back to Exercises](README.md) | Covers: [Lesson 05 — Currying and Partial Application](../05-Currying-and-Partial-Application/README.md)

**Difficulty: Advanced**

## Task

1. Write a general-purpose `log(level, module, message)` function that prints a formatted line like `[ERROR] auth: invalid token`.
2. Using `functools.partial`, derive `log_error = partial(log, "ERROR")` and `log_info = partial(log, "INFO")` — each still needing `module` and `message`.
3. From `log_error`, further derive `log_auth_error = partial(log_error, "auth")` — needing only `message` now. Call it with a couple of different messages.
4. Write a generic `curry2(func)` helper (following the pattern from Lesson 05's `curry3`, but for exactly 2 arguments) and use it to curry a `multiply(a, b)` function. Confirm `curry2(multiply)(3)(4)` gives the same result as `multiply(3, 4)`.
5. Explain in a comment why `partial(log, "ERROR")` and a fully-curried `curry3(log)("ERROR")` behave *differently* if you then try to call the result with two arguments at once (`result("auth", "message")`).

## Reflection Questions

1. Why is `partial()` generally more convenient than a fully curried function when you want to fix a variable number of leading arguments?
2. Give a real-world example (not from this lesson) where derived, partially-applied functions like `log_error`/`log_auth_error` would be genuinely useful in a larger application.

## Deliverable

A runnable `.py` file demonstrating all the derived logging functions, the `curry2` helper applied to `multiply`, the explanatory comment from step 5 verified by actually attempting both calls, and written answers to both reflection questions.
