# 05 — Control Flow

[Back to course overview](../README.md) | [Previous: Operators](../04-Operators/README.md)

## Learning Objectives

- Use `if`/`elsif`/`else` and `unless`, plus their postfix forms.
- Use `case`/`when`, understanding it dispatches via `===` (so ranges, classes, and regexes all work as `when` conditions, not just literal equality).
- Use `while`/`until` (including postfix forms) and `loop`/`break` with a returned value.

## Prerequisites

[04-Operators](../04-Operators/README.md)

## Concept

`if`/`elsif`/`else`/`unless` work as expected; `unless` is simply inverted `if` (`unless x` means `if !x`). The genuinely useful feature is `case`/`when`: each `when` clause is tested with the triple-equals operator `===` against the case subject, not plain `==`. Since `Range#===` checks membership, `Class#===` checks `is_a?`, and `Regexp#===` checks a match, a single `case` can dispatch on numeric ranges, object types, or string patterns — all shown live below, not just the common literal-value case.

## Detailed Example

See [example.rb](example.rb) — `if`/`elsif`/`unless` with postfix forms, `case`/`when` bucketing scores by range, `case`/`when` dispatching on `Integer`/`String`/`Array` classes (proving `===` does real class-membership work), `while`/`until` with postfix forms, and `loop`/`break` returning a value out of the loop.

## Run It

```bash
cd 01-Languages/Ruby/05-Control-Flow
ruby example.rb
```

## Expected Output (real, captured)

```
5: positive
-3: negative
0: zero
not empty
has items
95 -> A
82 -> B
71 -> C
40 -> F
42 -> integer
"hi" -> string
[1, 2] -> array
i ended at 3
j ended at 0
done!
```

## Common Mistakes

- Assuming `case`/`when` only matches literal values — it actually calls `===` on each `when` operand, which is why ranges/classes/regexes work as conditions and a `case` can look deceptively like a plain switch while doing real polymorphic dispatch.
- Confusing `unless...else`— it's legal but reads awkwardly (`unless x ... else ...` means "if not x, else if x"); prefer plain `if`/`else` once an `else` branch exists.
- Forgetting `loop`'s `break value` idiom and instead accumulating into an external mutable variable — `break` returning a value directly from `loop` is idiomatic and avoids that extra variable.

## Best Practices

- Reach for `case`/`when` once there are three or more mutually exclusive branches, especially range- or type-based ones — it reads far more clearly than a long `if`/`elsif` chain.
- Use postfix `if`/`unless` only for genuinely single, short statements; a multi-line body belongs in block form for readability.
- Prefer `until`/postfix `until` over `while !condition`, and vice versa for `unless` vs. `if !` — pick whichever reads as an actual English sentence.

## Real-World Usage

Rails controllers commonly `case` on a `params[:status]` symbol or an object's class to dispatch behavior; postfix conditionals (`raise ArgumentError unless valid?`) are idiomatic guard-clause style throughout the Ruby ecosystem's own source code.

## Summary

- `if`/`unless` support full and postfix forms.
- `case`/`when` dispatches via `===`, enabling range/class/regex conditions, not just literal equality.
- `loop` + `break value` returns a value directly out of an otherwise-infinite loop.

## Key Terms

- **`===` ("case equality")** — the operator `case`/`when` actually calls on each `when` clause; different classes define it differently (membership, `is_a?`, regex match).

## Interview Questions

1. **How does `case`/`when` decide whether a `when` clause matches?**
   It calls `===` on the `when` operand with the case subject as the argument — not plain `==`. This is why `when (90..100)` works as a range-membership check, `when String` works as a type check (`is_a?`), and `when /pattern/` works as a regex match, all inside the same `case` expression, verified directly in this lesson.

2. **What does `break "value"` do inside a `loop do ... end`?**
   It immediately exits the loop and makes the entire `loop` expression itself evaluate to `"value"` — since `loop` (like everything in Ruby) is an expression, its result can be assigned directly (`result = loop do ... break "done!" end`) instead of setting an external variable inside the loop body and reading it afterward.

## Recommended Next Lesson

[06 — Functions](../06-Functions/README.md)
