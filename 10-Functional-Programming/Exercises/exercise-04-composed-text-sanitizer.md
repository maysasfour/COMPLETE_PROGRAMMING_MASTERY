# Exercise 04 — Composed Text Sanitizer

[Back to Exercises](README.md) | Covers: [Lesson 04 — Function Composition](../04-Function-Composition/README.md)

**Difficulty: Intermediate**

## Task

Build a text-sanitizing pipeline out of small, independently-testable functions, combined with `pipe()`/`compose()` from Lesson 04.

1. Write `collapse_whitespace(s)` — replaces any run of whitespace characters with a single space, and strips leading/trailing whitespace.
2. Write `remove_html_tags(s)` — removes anything matching `<...>` (a simple regex is fine; this doesn't need to handle malformed HTML robustly).
3. Write `truncate(max_length)` — returns a function that truncates a string to `max_length` characters, appending `"..."` if it was truncated.
4. Using `pipe()` (from Lesson 04, copy or re-import it), build a `sanitize` pipeline combining all three, in a sensible order.
5. Test `sanitize` against a string containing extra whitespace, HTML tags, and enough length to trigger truncation, and print the result.
6. Write at least one standalone test (a simple `assert`) for each of the three individual functions, demonstrating they work correctly in isolation before being combined.

## Reflection Questions

1. Why does the *order* of composition matter here — what would go wrong if `truncate` ran before `remove_html_tags`?
2. If `remove_html_tags` had a bug, would you rather debug it via the standalone assertion from step 6, or by tracing through the full `sanitize` pipeline's output? Why?

## Deliverable

A runnable `.py` file with all three functions, the composed `sanitize` pipeline, its demonstrated output, the standalone per-function assertions, and written answers to both reflection questions.
