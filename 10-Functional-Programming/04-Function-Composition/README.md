# 04 — Function Composition

[Back to module overview](../README.md) | [Previous: Map, Filter, Reduce](../03-Map-Filter-Reduce/README.md)

## Beginner: Combining Two Functions

**Function composition** means building a new function by chaining the output of one function into the input of another — `f(g(x))`. Rather than writing one large function that does everything, you write small, focused functions and combine them.

```python
def add_one(x):
    return x + 1

def double(x):
    return x * 2

def compose_two(f, g):
    return lambda x: f(g(x))

add_then_double = compose_two(double, add_one)   # double(add_one(x))
add_then_double(3)   # add_one(3)=4, then double(4)=8
```

Verified live: `add_then_double(3)` returned `8`, confirming the composed function applied `add_one` first, then `double` to its result — exactly as `compose_two`'s definition (`f(g(x))`) specifies.

## Intermediate: Composing Any Number of Functions

```python
from functools import reduce

def compose(*functions):
    return reduce(compose_two, functions)   # applies RIGHT TO LEFT: compose(f,g,h)(x) == f(g(h(x)))

pipeline = compose(square, double, add_one)
pipeline(3)   # add_one(3)=4, double(4)=8, square(8)=64
```

Verified live: `compose(square, double, add_one)(3)` returned `64`, matching manual step-by-step evaluation (`add_one(3)=4 → double(4)=8 → square(8)=64`).

## Intermediate: `pipe()` — The Same Idea, Left to Right

```python
def pipe(*functions):
    return reduce(compose_two, reversed(functions))

pipeline_readable = pipe(add_one, double, square)   # SAME result, but reads in application order
pipeline_readable(3)   # 64 -- identical to compose(square, double, add_one)(3)
```

`compose()` follows the traditional mathematical convention (right-to-left, matching how `f(g(x))` is written), while `pipe()` lists functions in the order they're actually *applied* (left to right) — often considered more readable, since it matches how you'd narrate the steps aloud ("first add one, then double, then square"). Both are widely used; different languages/libraries pick different defaults (Unix pipes and most functional-language pipeline operators read left-to-right).

## Advanced: A Practical Pipeline, and Why Composition Aids Testability

```python
clean_text = pipe(strip_whitespace, to_lowercase, remove_punctuation)
clean_text("  Hello, World!!  ")   # 'hello world'
```

Verified live: each of `strip_whitespace`, `to_lowercase`, and `remove_punctuation` was independently tested with a trivial input/output pair — and because the composed `clean_text` pipeline is *just* "run these, in this order," there's no new logic in the pipeline itself to get wrong. This is one of composition's biggest practical payoffs: correctness of the whole reduces to correctness of each small, independently-verifiable piece plus trusting that composition itself behaves as documented.

## Real-World Usage

- Middleware chains (Express.js, Django/Flask request middleware) are function composition: each middleware wraps the next, forming a pipeline the request flows through.
- Unix shell pipes (`cat file | grep foo | sort | uniq`) are function composition at the process level — the same left-to-right "pipe" mental model as `pipe()` in this lesson.
- Data transformation libraries (pandas method chaining, JavaScript's promise `.then()` chains) all lean on the same idea: build a complex transformation from small, composable, independently-understandable pieces.

## Summary

- Function composition builds complex behavior from small functions by feeding one's output into another's input.
- `compose()` (right-to-left) matches mathematical notation; `pipe()` (left-to-right) matches the order operations are actually applied — both verified live to produce identical results for equivalent function orderings.
- Composed pipelines are easier to test and reason about, since each piece can be verified independently, and the pipeline itself adds no new logic beyond ordering.

## Key Terms

- **Function composition** — combining two or more functions so that one's output becomes the next's input.
- **`compose()`** — combines functions right-to-left, matching mathematical convention (`f(g(x))`).
- **`pipe()`** — combines functions left-to-right, matching the order they're applied/read.
- **Pipeline** — a sequence of composed transformations applied to a value, one after another.

## Common Mistakes

- Confusing the argument order between `compose()` (right-to-left) and `pipe()` (left-to-right) — writing `compose(add_one, double, square)` produces a *different* pipeline than `pipe(add_one, double, square)`, even though the function names are in the same order.
- Composing functions with mismatched arities/types — every function in a composition chain (except possibly the first) must accept exactly the type/shape of value the previous one produces, or the composed pipeline breaks at runtime.
- Building an overly long composition chain that's hard to debug — if a pipeline fails, it's not always obvious which stage produced the bad value; keeping each stage's contract simple and well-tested (as demonstrated in this lesson) mitigates this.

## Interview Questions

1. **What's the difference between `compose(f, g, h)` and `pipe(f, g, h)`?**
   `compose()` applies functions right-to-left, matching mathematical function notation: `compose(f, g, h)(x)` evaluates as `f(g(h(x)))` — `h` runs first. `pipe()` applies functions left-to-right: `pipe(f, g, h)(x)` evaluates as `h(g(f(x)))` — `f` runs first, matching the order the function names are listed. Both were verified live in this lesson to produce identical results when the argument order is correspondingly reversed (`compose(square, double, add_one)` and `pipe(add_one, double, square)` both returned `64` for input `3`).

2. **Why does function composition make code easier to test, compared to one large function doing everything?**
   Each small function in a composition chain can be tested in complete isolation with a trivial input/output pair — as demonstrated in this lesson, `strip_whitespace`, `to_lowercase`, and `remove_punctuation` were each verified independently. The composed pipeline itself then only needs to trust that composition works as documented (applying each function in the specified order) — there's no additional, pipeline-specific logic to test beyond that ordering, since all the actual behavior lives in the small, already-tested individual functions.

## Suggested Next Lesson

[05 — Currying and Partial Application](../05-Currying-and-Partial-Application/README.md)
