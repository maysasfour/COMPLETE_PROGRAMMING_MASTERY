# 12 — Functional Concepts

[Back to course overview](../README.md) | [Previous: OOP](../11-OOP/README.md)

## Learning Objectives

- Chain `Enumerable` methods fluently as a functional-style data pipeline.
- Use `Symbol#to_proc` (`&:method_name`) as shorthand for a single-method block.
- Compose lambdas with `>>`/`<<`, and write higher-order functions that both accept and return callables.

## Prerequisites

[11-OOP](../11-OOP/README.md)

## Concept

Ruby is not a purely functional language, but its block/Proc/lambda system (Lesson 06) combined with `Enumerable` (Lesson 07) supports a genuinely functional style: chains of `select`/`map`/`sort` reading as one declarative pipeline, `&:symbol` shorthand for trivial one-method blocks, and real lambda composition via `>>` (then) and `<<` (compose-backwards), both proven with actual, different results below since the two orders apply the two lambdas in opposite sequence.

`Enumerable::lazy` builds an evaluation pipeline that only computes as many elements as are ultimately consumed — essential for filtering over a conceptually infinite sequence (`(1..Float::INFINITY)`) without ever attempting to materialize it fully.

## Detailed Example

See [example.rb](example.rb) — a `select` → `map` → `sort` → `first` pipeline; `&:length` vs. the spelled-out block form proven to give identical results; `double >> increment` vs. `double << increment` proven to genuinely differ (11 vs. 12 for the same inputs, since composition order changes which function runs first); a `multiplier` higher-order function returning a lambda; `.lazy` pulling exactly 5 even numbers out of an infinite range; `each_slice`/`each_cons` windowing; and `map` proven to leave its original array untouched.

## Run It

```bash
cd 01-Languages/Ruby/12-Functional-Concepts
ruby example.rb
```

## Expected Output (real, captured)

```
["DYNAMIC", "FUN", "GENUINELY"]
[4, 2, 1, 9, 3, 7, 8]
[4, 2, 1, 9, 3, 7, 8]
11
12
21
[2, 4, 6, 8, 10]
[[1, 2, 3], [4, 5, 6], [7, 8, 9], [10]]
[[1, 2], [2, 3], [3, 4], [4, 5]]
110
original unchanged: [1, 2, 3]
doubled: [2, 4, 6]
```

## Common Mistakes

- Confusing `a >> b` with `a << b` for lambda composition — they apply in opposite order (`>>` runs `a` then `b`; `<<` runs `b` then `a`), verified directly above to produce different results (11 vs. 12) from the same two lambdas and the same input.
- Using `(1..Float::INFINITY).select { ... }` (no `.lazy`) — this genuinely hangs forever trying to materialize an infinite Array before `select` can even run; `.lazy` must come first so the pipeline only pulls as many elements as `.first(n)` actually needs.
- Assuming `map` mutates its receiver — it doesn't (only `map!` does); the original array is left untouched, verified directly.

## Best Practices

- Reach for `&:method_name` for single-method blocks; keep the spelled-out `{ |x| ... }` form for anything needing more than one method call or any branching logic.
- Insert `.lazy` before filtering/mapping over a `Range` that could be very large or literally infinite.
- Prefer composing small, named lambdas (`double >> increment`) over one large monolithic block when a pipeline's individual steps are independently meaningful.

## Real-World Usage

Data-processing scripts and Rails query scopes both lean on exactly this style of `Enumerable`/lambda chaining; `.lazy` is the standard idiom for streaming large CSV/log files line-by-line through a filter-then-transform pipeline without loading everything into memory first.

## Summary

- `Enumerable` chains (`select.map.sort`) express a functional-style data pipeline declaratively.
- `&:symbol` is shorthand for a single-method block; lambdas compose via `>>`/`<<`, verified to genuinely apply in different orders.
- `.lazy` defers computation, letting a pipeline run correctly over conceptually infinite sequences.

## Key Terms

- **`Symbol#to_proc`** — the mechanism behind `&:method_name`, converting a symbol into a one-argument block calling that method on its argument.
- **Lazy enumerator** — an `Enumerable` pipeline (`.lazy`) that defers computation until a terminal call (`.first`, `.force`) actually pulls results.

## Interview Questions

1. **What's the difference between `f >> g` and `f << g` for two lambdas?**
   `f >> g` returns a new lambda applying `f` first, then passing its result to `g` (`g(f(x))`); `f << g` applies `g` first, then `f` (`f(g(x))`) — the two orders genuinely differ, verified directly in this lesson by composing `double` and `increment` both ways and getting 11 vs. 12 from the identical input.

2. **Why is `.lazy` needed before filtering an infinite range?**
   Without `.lazy`, `(1..Float::INFINITY).select { ... }` attempts to eagerly build the full filtered Array before returning anything, which never completes over a genuinely infinite range. `.lazy` converts the pipeline into a lazy enumerator that only computes as many elements as a terminal call like `.first(5)` actually needs, verified in this lesson by pulling exactly 5 even numbers out of an infinite sequence.

## Recommended Next Lesson

[13 — Duck Typing](../13-Duck-Typing/README.md)
