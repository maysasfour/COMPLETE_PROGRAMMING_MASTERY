# Solution 05 — Specialized Loggers

[Back to Solutions](README.md) | [Exercise](../Exercises/exercise-05-specialized-loggers.md)

## Approach

`partial(log, "ERROR")` fixes the `level` argument, returning a function still needing `module` and `message` — and critically, that returned function can be called with *both* remaining arguments at once (`log_error("auth", "message")`), since `partial` only fixes what you explicitly give it and leaves the rest as an ordinary, multi-argument function. `log_auth_error = partial(log_error, "auth")` further fixes `module`, leaving only `message`.

`curry2` mirrors Lesson 05's `curry3` pattern for exactly two arguments: `curry2(multiply)(3)(4)` returned `12`, matching `multiply(3, 4)` directly — confirming the curried chain produces the identical result, just via one-argument-at-a-time calls instead of one call with both arguments.

The final demonstration directly contrasts the two: `partial(log, "ERROR")("auth", "message")` (two arguments in one call) works fine, but the equivalent step through a fully curried `curry3(log)("ERROR")("auth", "message")` raised a real `TypeError`, verified live: `with_b() takes 1 positional argument but 2 were given`. This is the concrete, structural difference between the two techniques — `partial` never restricts you to one-argument-at-a-time; a curried function's whole *point* is that each call accepts exactly one.

## Reflection Answers

1. **Why is `partial()` more convenient for fixing a variable number of leading arguments?** `partial()` lets you fix however many arguments you want in a single call — one, two, or more — and the resulting function still accepts the rest normally, in one or more arguments per call, exactly like the original. A fully curried function forces every single call to supply exactly one argument, which is more rigid: if you want to fix two arguments at once and call the result with the remaining two at once as well, currying doesn't allow that final flexibility (verified live via the `TypeError` in this solution) — you'd need to call it twice more, once per remaining argument.

2. **A real-world example of derived, partially-applied functions being useful?** A web framework's request-handling pipeline: a generic `send_response(status_code, headers, body)` function could be partially applied per-route to create `send_404 = partial(send_response, 404, {"Content-Type": "text/plain"})`, so route handlers throughout the codebase can call `send_404(body="Not Found")` without repeating the status code and headers every time — the same specialization idea as `log_error`/`log_auth_error` in this exercise, applied to HTTP response construction instead of logging.
