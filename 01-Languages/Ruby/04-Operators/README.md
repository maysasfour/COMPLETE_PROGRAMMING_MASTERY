# 04 — Operators

[Back to course overview](../README.md) | [Previous: Variables and Data Types](../03-Variables-and-Data-Types/README.md)

## Learning Objectives

- Understand that Ruby operators are ordinary method calls (`a + b` is `a.+(b)`), and override one on a custom class.
- Implement the spaceship operator `<=>` and gain `<`/`<=`/`==`/`>`/`>=`/`between?` for free via `Comparable`.
- Use the safe-navigation operator `&.` to avoid `NoMethodError` on a possibly-`nil` value.

## Prerequisites

[03-Variables-and-Data-Types](../03-Variables-and-Data-Types/README.md)

## Concept

In Ruby, arithmetic and comparison operators are not special-cased syntax — they are ordinary method calls with a symbolic name. `a + b` genuinely means "call the method named `+` on `a`, passing `b`", which is directly provable by writing `a.+(b)` instead. This means any class can **overload an operator** simply by defining a method with that operator's name (`def +`, `def ==`, `def <=>`), a genuinely distinctive feature this lesson demonstrates live rather than only describing.

The **spaceship operator** `<=>` is Ruby's three-way comparison: it returns `-1`, `0`, or `1` (or `nil` if the two objects aren't comparable). Defining `<=>` once and mixing in the `Comparable` module gives a class `<`, `<=`, `==`, `>`, `>=`, and `between?` automatically — one method implemented, six behaviors gained.

## Detailed Example

See [example.rb](example.rb) — a `Money` class overloading `+` and `<=>` (with `include Comparable`), proven with both `a + b` and the equivalent explicit `a.+(b)` call, `sort` using the custom `<=>`, spaceship results on plain integers, and the `&.` safe-navigation operator short-circuiting to `nil` on a `nil` receiver instead of raising.

## Run It

```bash
cd 01-Languages/Ruby/04-Operators
ruby example.rb
```

## Expected Output (real, captured)

```
a + b = $7.50
a.+(b) explicit call = $7.50
a > b?  true
a == Money.new(500)? true
["$2.50", "$5.00"]
-1
0
1
6
3
3.5
nil
```

## Common Mistakes

- Overloading `==` without also overriding `hash` (and `eql?`) when the object is meant to be used as a Hash key or in a Set — inconsistent `==`/`hash` pairs cause silent lookup bugs (not demonstrated with a bug here, but a real gotcha worth knowing for Lesson 11's OOP work).
- Forgetting `include Comparable` after defining `<=>` and then manually reimplementing `<`/`>` — redundant; `Comparable` already derives them from `<=>` alone.
- Expecting `++`/`--` — Ruby has neither; use `+= 1` explicitly.

## Best Practices

- Define `<=>` plus `include Comparable` for any custom class with a natural ordering, rather than hand-writing every comparison operator.
- Use `&.` when a method receiver might legitimately be `nil` (e.g., an optional association), instead of a defensive `if x != nil` guard before every call.
- Keep overloaded operators behaviorally intuitive (`+` should feel like addition) — Ruby's flexibility here is a real footgun if abused to mean something unrelated to the operator's normal meaning.

## Real-World Usage

ActiveRecord's `Money`-like gems (e.g., the `money` gem) and Ruby's own `Time`/`Date` classes all overload arithmetic and comparison operators exactly this way, and `Comparable` is mixed into dozens of Ruby standard-library classes (`String`, `Numeric`, `Time`) to provide their ordering operators from a single `<=>`.

## Summary

- Operators are method calls; `def +`/`def <=>` on a custom class genuinely overloads them.
- `<=>` plus `include Comparable` yields all six comparison operators from one method.
- `&.` short-circuits to `nil` instead of raising `NoMethodError` on a `nil` receiver.

## Key Terms

- **Spaceship operator (`<=>`)** — three-way comparison returning -1/0/1/nil.
- **`Comparable`** — a mixin module deriving `<`,`<=`,`==`,`>`,`>=`,`between?` from a single `<=>` method.

## Interview Questions

1. **How does Ruby let a custom class support `+` or `==`?**
   Because operators are ordinary method calls under the hood (`a + b` desugars to `a.+(b)`), any class can define a method literally named `+` (or `==`, `<=>`, `[]`, etc.) and the operator syntax will dispatch to it — verified directly in this lesson by calling both `a + b` and `a.+(b)` on a custom `Money` class and getting identical results.

2. **What do you get by implementing `<=>` and including `Comparable`?**
   `Comparable` derives `<`, `<=`, `==`, `>`, `>=`, and `between?` entirely from one `<=>` method that returns -1/0/1 — implement the single three-way comparison once, and `sort`, direct comparisons, and range checks all work correctly without writing five more methods by hand.

## Recommended Next Lesson

[05 — Control Flow](../05-Control-Flow/README.md)
