# 09 — Error Handling

[Back to course overview](../README.md) | [Previous: Strings](../08-Strings/README.md)

## Learning Objectives

- Use `begin`/`rescue`/`ensure`/`raise`, including method-level implicit `rescue` (no `begin` needed at the method-body level).
- Write a custom exception class subclassing `StandardError` (not `Exception` directly).
- Use `retry` to re-run a `begin` block from the top — a genuinely distinctive keyword most languages in this repository lack a direct equivalent for.

## Prerequisites

[08-Strings](../08-Strings/README.md)

## Concept

`begin`/`rescue`/`ensure` is Ruby's try/catch/finally. A method body can `rescue` directly without an explicit `begin` wrapper — the method's own `def`/`end` acts as the implicit block, shown in this lesson's first example. `raise CustomError, "message"` raises an exception; custom exceptions should subclass `StandardError`, not `Exception` directly — `Exception` has other direct descendants (`SystemExit`, `NoMemoryError`, `SignalException`) that a broad `rescue` clause is deliberately designed *not* to catch by default (a bare `rescue` with no class named catches `StandardError` and its descendants only, not `Exception` itself).

**`retry`** is genuinely distinctive: inside a `rescue` clause, `retry` jumps back to the very start of the corresponding `begin` block and re-executes it — a real, built-in "try this again" primitive most other languages require a manual loop to express.

## Detailed Example

See [example.rb](example.rb) — method-level implicit rescue, a `begin`/`rescue`/`ensure` block confirming `ensure` runs on both success and failure paths, a custom `InsufficientFundsError < StandardError` carrying structured data (`shortfall`) via `attr_reader`, multiple `rescue` clauses ordered most-specific-first, and a `retry` loop that succeeds only on its third attempt.

## Run It

```bash
cd 01-Languages/Ruby/09-Error-Handling
ruby example.rb
```

## Expected Output (real, captured)

```
5
caught inline (method-level rescue): divided by 0
nil
ensure always runs
3
caught in begin/rescue block: ZeroDivisionError
ensure always runs
nil
caught: insufficient funds, short by 25 (shortfall=25)
TypeError: bad type
ArgumentError: bad argument
StandardError: generic error
succeeded after 3 attempts
```

## Common Mistakes

- Subclassing `Exception` instead of `StandardError` for custom errors — a bare `rescue` (with no explicit class) only catches `StandardError` descendants, so an `Exception`-rooted custom error would silently bypass ordinary `rescue` clauses.
- Using `retry` without a bounded condition (e.g., an attempt counter) — an unconditional `retry` inside a `rescue` that always fires creates a genuine infinite loop, since there's no built-in retry limit.
- Ordering `rescue` clauses least-specific-first — `rescue StandardError` before `rescue ArgumentError` would swallow the more specific case first, since Ruby checks `rescue` clauses top to bottom and uses the first match.

## Best Practices

- Always subclass `StandardError` (directly or via another `StandardError` descendant) for application-defined exceptions.
- Order multiple `rescue` clauses from most specific to least specific, mirroring the class hierarchy.
- Bound any `retry` loop with an explicit attempt counter to avoid an unconditional retry becoming an infinite loop.

## Real-World Usage

HTTP client gems commonly use `retry` (bounded by an attempt counter) to re-attempt a request after a transient network failure, exactly the shape shown in this lesson's final example; Rails' `ActiveRecord::RecordNotFound` and similar framework exceptions are all `StandardError` descendants for exactly the reason described above.

## Summary

- `begin`/`rescue`/`ensure`/`raise` mirror try/catch/finally/throw; methods can `rescue` directly without an explicit `begin`.
- Custom exceptions should subclass `StandardError`, not `Exception`, so bare `rescue` clauses actually catch them.
- `retry` re-executes the enclosing `begin` block from the top — a genuinely distinctive, built-in retry primitive.

## Key Terms

- **`StandardError`** — the base class ordinary application exceptions should subclass; caught by a bare `rescue` with no explicit class named.
- **`retry`** — re-runs the current `begin`/method body from its start, used inside `rescue`.

## Interview Questions

1. **Why should custom exceptions subclass `StandardError` instead of `Exception`?**
   A bare `rescue` clause with no explicit exception class only catches `StandardError` and its descendants, deliberately excluding `Exception`'s other direct children like `SystemExit` and `NoMemoryError` (which represent conditions that generally shouldn't be silently swallowed by ordinary application error handling). Subclassing `Exception` directly for a custom error would make it invisible to every plain `rescue` clause in the codebase, verified conceptually by this lesson's `InsufficientFundsError < StandardError`.

2. **What does `retry` do, and what's the risk of using it carelessly?**
   Inside a `rescue` clause, `retry` jumps back to the start of the enclosing `begin` block (or method body) and re-executes it from scratch. Verified live in this lesson with a bounded attempt counter that succeeds on the third try. Used without a bound, an always-failing condition inside a loop-free `retry` becomes a genuine infinite loop, since Ruby imposes no built-in retry limit.

## Recommended Next Lesson

[10 — File Handling](../10-File-Handling/README.md)
