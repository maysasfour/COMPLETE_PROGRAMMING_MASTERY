# 07 — Collections

[Back to course overview](../README.md) | [Previous: Functions](../06-Functions/README.md)

## Learning Objectives

- Use `Array`, `Hash`, and `Range` as Ruby's three core collection types.
- Use the `Enumerable` module's methods (`map`, `select`, `reject`, `reduce`, `group_by`, `each_with_object`) fluently, including chaining several together.
- Understand `Range`'s inclusive (`..`) vs. exclusive (`...`) end, and that ranges work over any `Comparable` type, not just numbers.

## Prerequisites

[06-Functions](../06-Functions/README.md)

## Concept

`Array` and `Hash` are Ruby's workhorse collections (a `Hash` with symbol keys, per Lesson 03, is by far the most common configuration/data-shape idiom in real Ruby code). `Range` (`1..5` inclusive, `1...5` exclusive of the end) represents a sequence and, notably, works over any type implementing `<=>`/`Comparable` — not just integers, shown below with a range of letters.

The real depth here is `Enumerable` — a single module, mixed into `Array`, `Hash`, `Range`, and many other classes, providing dozens of methods (`map`, `select`, `reject`, `reduce`, `sum`, `group_by`, `each_with_object`, `sort_by`, `min_by`/`max_by`) all built from just one primitive: `each`. These methods **chain freely**, letting a pipeline like "filter, transform, then total" read as one fluent expression instead of several intermediate loops with mutable accumulator variables.

## Detailed Example

See [example.rb](example.rb) — Array `sort`/`map`/`select`/`reject`/`reduce`/`sum`; Hash iteration, `select`, and `transform_values`; inclusive vs. exclusive `Range`, plus a `Range` over letters; a three-method `Enumerable` chain (`select` → `map` → `reduce`) computing the sum of squares of even numbers; `group_by` bucketing words by length; `each_with_object` accumulating totals into a `Hash.new(0)`; and block-parameter destructuring while iterating a Hash.

## Run It

```bash
cd 01-Languages/Ruby/07-Collections
ruby example.rb
```

## Expected Output (real, captured)

```
[1, 3, 5, 8, 9]
[10, 6, 16, 2, 18]
[8]
[5, 3, 1, 9]
26
26
26
1
9
[5, 3]
[1, 9]
Ada
name => Ada
age => 36
langs => ["Ruby", "Python"]
[:name, :age, :langs]
{age: 36}
{name: "ADA", age: 36, langs: ["Ruby", "Python"]}
[1, 2, 3, 4, 5]
[1, 2, 3, 4]
true
false
["a", "b", "c", "d", "e"]
sum of squares of even numbers 1..20 = 1540
{5 => ["apple"], 6 => ["banana", "cherry"], 4 => ["date"], 10 => ["elderberry"], 3 => ["fig"]}
{"a" => 4, "b" => 2}
x: 1
y: 2
```

## Common Mistakes

- Confusing `..` (inclusive of the end value) with `...` (exclusive) — verified directly above: `(1...5).include?(5)` is `false`, `(1..5).include?(5)` is `true`.
- Using `Hash.new` (default `nil`) when accumulating counts, then getting a `NoMethodError`/`nil`-arithmetic error on the first increment — `Hash.new(0)` (a default value) sidesteps this entirely, shown in this lesson's `each_with_object` example.
- Chaining `Enumerable` methods that each individually make sense but produce an unintended type — e.g., forgetting `select` on a `Hash` returns a `Hash`, not an `Array` of pairs, which can surprise code expecting the latter.

## Best Practices

- Prefer chaining `Enumerable` methods (`select.map.reduce`) over hand-written `each` loops with mutable accumulators — it's more declarative and each stage is independently testable.
- Use `Hash.new(0)` (or `Hash.new { |h, k| h[k] = [] }` for arrays) whenever accumulating into a Hash keyed by something not known in advance.
- Reach for `group_by` instead of manually building a Hash of Arrays with a loop — it's a single, well-tested standard-library method doing exactly that.

## Real-World Usage

Rails' ActiveRecord query results are Enumerable, so `.select`/`.map`/`.group_by` chain directly onto database results exactly as shown here; Ruby's own standard library (`CSV`, `JSON`) returns Arrays/Hashes that flow straight into these same Enumerable pipelines.

## Summary

- `Array`, `Hash`, `Range` are the three core collection types; `Range` works over anything `Comparable`, not just numbers.
- `Enumerable` (mixed into all three) provides `map`/`select`/`reject`/`reduce`/`group_by`/`each_with_object`, all built from `each`, and all freely chainable.
- `..` is inclusive of its end value, `...` is exclusive — verified directly, not just asserted.

## Key Terms

- **`Enumerable`** — the mixin module providing iteration-based methods to any class implementing `each`.
- **`Hash.new(default)`** — a Hash constructor form supplying a default value for missing keys, avoiding manual nil-checks during accumulation.

## Interview Questions

1. **What is `Enumerable`, and why do `Array`, `Hash`, and `Range` all get `map`/`select`/`reduce` for free?**
   `Enumerable` is a module that implements dozens of iteration-based methods purely in terms of a single primitive method, `each`, which the including class must define. `Array`, `Hash`, and `Range` all include `Enumerable` and each provide their own `each`, so they automatically gain `map`, `select`, `reject`, `reduce`, `group_by`, and dozens more without reimplementing any of them individually — the same mixin mechanism covered further in Lesson 11.

2. **What's the difference between `1..5` and `1...5`?**
   `1..5` is an inclusive range containing `1, 2, 3, 4, 5`; `1...5` is exclusive of the end value, containing `1, 2, 3, 4`. This was verified directly: `(1..5).include?(5)` returns `true` while `(1...5).include?(5)` returns `false` — a common off-by-one source if the wrong operator is used for an array-slicing or loop-bound range.

## Recommended Next Lesson

[08 — Strings](../08-Strings/README.md)
