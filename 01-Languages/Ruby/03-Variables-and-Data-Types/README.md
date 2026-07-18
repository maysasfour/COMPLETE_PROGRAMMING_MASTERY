# 03 — Variables and Data Types

[Back to course overview](../README.md) | [Previous: Syntax](../02-Syntax/README.md)

## Learning Objectives

- Understand dynamic typing: a variable's type is whatever it currently references, and can change.
- Use `nil` correctly, including `.nil?` and its interaction with common methods.
- Understand symbols (`:name`) — Ruby's lightweight, interned, immutable identifier type — and why they differ from strings.
- Confirm live that even integers and `nil` are real objects with real methods.

## Prerequisites

[02-Syntax](../02-Syntax/README.md)

## Concept

Ruby is dynamically typed: a variable name is just a reference that can be reassigned to a value of any type at any time; there is no declared type anywhere. `nil` is Ruby's single "nothing" value (there's no separate `null`/`undefined`/`None`-vs-`nil` distinction).

The genuinely distinctive feature here is **symbols**. A symbol literal like `:status` is an immutable, interned identifier — every occurrence of `:status` anywhere in a running program refers to the *exact same object*, verified below with `.equal?` and `.object_id`. Strings, by contrast, are separate objects every time a new string literal is evaluated, even if their contents are identical. This makes symbols cheap, stable hash keys and method names — Ruby's own core APIs (`Hash` options, `attr_accessor`, method names passed to `send`) use symbols pervasively for exactly this reason.

Also genuinely distinctive (shared with Python/Smalltalk, unlike Java/C#/Go): **everything in Ruby is an object**, including integers, `nil`, `true`, and `false` — they all respond to real methods (`5.even?`, `nil.to_a`), with no separate "primitive" category the way Java's `int` or C#'s `int` are not objects by default.

## Detailed Example

See [example.rb](example.rb) — dynamic retyping of one variable across three types, `nil`/`.nil?`, symbol interning proven via `.equal?`/`.object_id` against two equal-but-distinct strings, symbols as hash keys, integer/nil methods, parallel assignment/swap, and a real `FrozenError` caught live from mutating a frozen string.

## Run It

```bash
cd 01-Languages/Ruby/03-Variables-and-Data-Types
ruby example.rb
```

## Expected Output (real, captured)

```
42 is a Integer
now a string is a String
[1, 2, 3] is a Array
true
nil
symbols same object?  true
strings same object?  false
symbol object_id stable: true
localhost
false
3
""
[]
p=2 q=1
caught: FrozenError
```

## Common Mistakes

- Assuming two string literals with identical content are the same object — they are not (`.equal?` returns `false`); only symbols are interned this way.
- Calling a method on something that might be `nil` without checking — raises `NoMethodError: undefined method for nil` at run time; Ruby has no compile-time null-safety, which is exactly why `&.` (Lesson 04) and `.nil?` checks matter.
- Using a symbol where a mutable string is actually needed (e.g., building up text) — symbols are immutable and not meant for that; use a `String` instead.

## Best Practices

- Use symbols for fixed, code-level identifiers (hash keys, method names, enum-like states); use strings for actual textual data.
- Check `.nil?` (or use `&.`, or the `||`/`&&` idioms) before calling methods on anything that might legitimately be absent.
- Prefer `frozen_string_literal: true` (a magic comment, see Lesson 08) in real projects to make accidental string mutation fail loudly and early.

## Real-World Usage

Rails' `params` hash, ActiveRecord query options (`where(status: :active)`), and virtually every gem's configuration API use symbols as keys — this is the single most common idiomatic Ruby pattern a newcomer from another language will encounter immediately.

## Summary

- Dynamic typing: no declared types; a variable can be reassigned to any type.
- `nil` is Ruby's one "nothing" value; `.nil?` checks for it.
- Symbols (`:name`) are immutable and interned — the same literal is always the same object, unlike strings.
- Everything, including integers and `nil`, is a real object with real methods.

## Key Terms

- **Symbol** — an immutable, interned identifier literal (`:name`), commonly used as a hash key or method name.
- **Interning** — the runtime guaranteeing that equal symbol literals are the literal same object in memory.

## Interview Questions

1. **What's the practical difference between a Ruby symbol and a Ruby string?**
   A symbol (`:name`) is immutable and interned — every occurrence of the same symbol literal is the identical object in memory (verified directly via `.equal?` and matching `.object_id`s), making it cheap to compare and ideal as a hash key or method identifier. A string (`"name"`) is a separate, mutable object every time it's created, even with identical content — two `"status"` literals are `==` but not `.equal?`.

2. **Is `5` a primitive in Ruby the way it is in Java?**
   No — every value in Ruby, including integers, `true`, `false`, and `nil`, is a full object responding to real methods (`5.even?`, `nil.to_a`, `true.class`). There is no separate "primitive" category exempt from the object model, unlike Java's `int`/`boolean` or C#'s value-type primitives (which only gain object-like behavior via boxing).

## Recommended Next Lesson

[04 — Operators](../04-Operators/README.md)
