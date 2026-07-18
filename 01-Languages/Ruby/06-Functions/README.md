# 06 — Functions

[Back to course overview](../README.md) | [Previous: Control Flow](../05-Control-Flow/README.md)

## Learning Objectives

- Define methods with default and keyword arguments, plus splat (`*args`) and double-splat (`**kwargs`) for variable arity.
- Understand Ruby's genuinely distinctive **three-way split** between blocks, Procs, and lambdas — not just one "function value" type like most other languages.
- Use `yield` to invoke a method's implicit block, and prove live the sharp behavioral difference between a Proc's and a lambda's `return`.

## Prerequisites

[05-Control-Flow](../05-Control-Flow/README.md)

## Concept

Ruby methods (`def`) support default values, keyword arguments, splat/double-splat variadic parameters — all fairly standard compared to other languages in this repository. What's genuinely distinctive to Ruby is the **three different ways to represent "a chunk of code as a value"**:

1. **A block** — the `{ ... }` or `do...end` attached directly to a method call. It is *not an object at all*; a method receives it implicitly and invokes it with `yield`, or captures it explicitly as a `Proc` via an `&block` parameter.
2. **A `Proc`** — a block turned into a real, storable, passable object (`Proc.new { ... }` or `proc { ... }`). Calling `.call`/`.()`/`[]` invokes it. Argument-count mismatches are tolerated silently (missing args become `nil`, extras are dropped).
3. **A lambda** (`lambda { ... }` or the "stabby" `->(x) { ... }`) — a stricter `Proc` subtype: it raises `ArgumentError` on argument-count mismatch, and — the single sharpest, most commonly-quizzed difference — **`return` inside a lambda returns from the lambda itself**, while **`return` inside a plain `Proc` returns from the *enclosing method*** the Proc was created in. This is verified live below, including showing a line that never executes because a Proc's `return` fired first.

## Detailed Example

See [example.rb](example.rb) — default/keyword args, splat/double-splat, `yield` and an explicit `&block` parameter, a `Proc` called three equivalent ways (`.call`, `.()`, `[]`), a lambda checked with `.lambda?`, and the Proc-vs-lambda `return` and arity-strictness differences both proven with real, executed code (not just described).

## Run It

```bash
cd 01-Languages/Ruby/06-Functions
ruby example.rb
```

## Expected Output (real, captured)

```
Hello, Ada!
Hi, Grace!
total: 6
sum: 9
block call #1
block call #2
explicit block param #10
explicit block param #20
6
6
6
16
16
square.lambda? = true
add_one.lambda? = false
returned from Proc, exits the METHOD
lambda returned "returned from lambda, exits the LAMBDA only", but THIS is the method's real return value
a=1 b=nil
caught: ArgumentError: wrong number of arguments (given 1, expected 2)
```

## Common Mistakes

- Using a Proc where a lambda's strict arity-checking is actually wanted (or vice versa) — a Proc silently tolerating a wrong argument count can hide a real bug that a lambda would surface immediately as `ArgumentError`.
- Putting a bare `return` inside a `Proc` stored and called from a different method than where it was defined — this raises `LocalJumpError` at the call site (the enclosing method it meant to return from has already finished), a genuinely confusing failure mode for anyone coming from a language where closures don't distinguish `return` scope this way.
- Forgetting that `yield` raises `LocalJumpError: no block given` if the method is called without a block at all — guard with `block_given?` when a block is optional.

## Best Practices

- Default to lambdas (`->(x) { ... }`) for anything stored in a variable and called later — the strict arity checking catches mistakes earlier.
- Use plain blocks (`yield`) for the common "pass a block to customize behavior" pattern (`each`, `map`, custom iterators) — it's idiomatic and avoids the ceremony of an explicit Proc/lambda parameter when the block is always required.
- Use `block_given?` to branch on whether an optional block was actually supplied before calling `yield`.

## Real-World Usage

Every Enumerable method (`each`, `map`, `select`, used constantly in Lesson 07) is implemented internally via `yield`; Rails' `respond_to do |format| ... end` and RSpec's `describe`/`it` blocks are both just ordinary Ruby blocks passed to ordinary methods — no special language feature beyond what this lesson covers.

## Summary

- Methods support defaults, keyword args, and splat/double-splat variadic parameters.
- Ruby has three distinct callable-code representations: blocks (not objects, via `yield`), Procs (lenient arity, method-scoped `return`), and lambdas (strict arity, lambda-scoped `return`).
- The Proc-vs-lambda `return` difference is a real, sharp behavioral trap, verified live in this lesson.

## Key Terms

- **`yield`** — invokes the block implicitly attached to the current method call.
- **Arity** — the number of arguments a callable expects; lambdas enforce it strictly, Procs don't.

## Interview Questions

1. **What's the single sharpest difference between a Proc and a lambda?**
   `return` inside a lambda exits only the lambda itself, behaving like a normal function return; `return` inside a plain Proc exits the *enclosing method* the Proc was defined in — verified live in this lesson by showing a line immediately after a Proc's `.call` that never executes, because the Proc's `return` already unwound the whole method. Lambdas also check argument count strictly (`ArgumentError` on mismatch); Procs silently tolerate it.

2. **What is a block, and how is it different from a Proc?**
   A block is the `{ ... }`/`do...end` syntax attached directly to a method call — it is not an object and can't be stored in a variable or passed around on its own; a method receives it implicitly and invokes it via `yield`. A `Proc` is what you get when a block is explicitly captured as a real object (via `Proc.new { ... }` or an `&block` parameter), which *can* be stored, passed to other methods, and invoked later with `.call`.

## Recommended Next Lesson

[07 — Collections](../07-Collections/README.md)
