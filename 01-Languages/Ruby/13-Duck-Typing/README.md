# 13 — Duck Typing

[Back to course overview](../README.md) | [Previous: Functional Concepts](../12-Functional-Concepts/README.md)

## Learning Objectives

- Understand that Ruby has **no generics at all** — no `<T>` type-parameter syntax anywhere in the language, like Python and PHP elsewhere in this repository.
- Use duck typing (caring only whether an object responds to a method, not its declared type) as the idiomatic alternative.
- Use `respond_to?` as the real, runtime-checkable substitute for a compile-time generic constraint.

## Prerequisites

[12-Functional-Concepts](../12-Functional-Concepts/README.md)

## Concept

Ruby has no generic type parameters whatsoever — no `Stack<T>`, no `where T : Comparable`, nothing. A method or class simply calls whatever methods it needs on its arguments, and Ruby dispatches to whichever method actually exists at runtime — this is **duck typing**: "if it walks like a duck and quacks like a duck, treat it as a duck," regardless of its class or any declared interface. This is philosophically the same gap PHP (Lesson 13 there) and Python have, contrasted honestly here against every statically-typed language in this repository (Java/C#/Rust/Go/TypeScript/Swift/Kotlin), all of which enforce generic type constraints at compile time.

**`respond_to?`** is the idiomatic, runtime alternative to a compile-time generic constraint: instead of a type system rejecting an incompatible argument before the program ever runs, Ruby code checks `object.respond_to?(:method_name)` *at the moment it's about to call it*, and can degrade gracefully (or raise a deliberate, clear error) if the check fails — the tradeoff being that the check must actually be written and run, and a forgotten check simply raises `NoMethodError` at the exact call site during execution, not earlier.

## Detailed Example

See [example.rb](example.rb) — three unrelated classes (`Duck`, `Person`, `RubberDuck`, sharing no common ancestor or interface) all accepted by the same untyped `make_it_speak` method purely because each responds to `.speak`; a `safe_speak` helper using `respond_to?` to degrade gracefully for objects that don't; and a generic-parameter-free `Stack` class proven to accept genuinely mismatched types (`Integer`, `String`, `Array`, `Symbol`) all pushed onto the *same* stack with zero compile-time or runtime complaint — explicitly contrasted in a comment with the equivalent Java `Stack<Integer>` code, which would refuse to compile if a `String` were pushed.

## Run It

```bash
cd 01-Languages/Ruby/13-Duck-Typing
ruby example.rb
```

## Expected Output (real, captured)

```
Quack!
I'm quacking like a duck!
Squeak! (I'm not a real duck, but I respond to .speak too)
Quack!
Integer doesn't know how to speak
String doesn't know how to speak
mixed types pushed with zero complaint: [Integer, String, Array, Symbol]
:a_symbol
[1, 2, 3]
"a string"
42
Ruby has no generic type parameters -- duck typing + respond_to? is the idiomatic substitute.
```

## Common Mistakes

- Calling a method on an argument without checking `respond_to?` first when the caller genuinely can't guarantee the argument's shape — the failure (`NoMethodError`) only surfaces at run time, potentially deep inside a call stack far from where the bad argument was actually passed in.
- Assuming a "generic-like" container class (this lesson's `Stack`) offers any type safety at all — it offers none; every element type is accepted silently, verified directly by pushing four completely unrelated types onto the same instance.
- Treating duck typing as "no safety at all" rather than "runtime, opt-in safety via `respond_to?`" — real Ruby codebases do check this, they just check it at the moment of use rather than relying on a compiler.

## Best Practices

- Use `respond_to?` at any boundary where an argument's shape genuinely isn't guaranteed (e.g., a public library API accepting many object types).
- Document a method's expected duck-type "interface" (which methods it calls on its argument) clearly in a comment or YARD doc, since there's no type signature to convey it.
- For genuine interface-like contracts within a codebase, consider a `Comparable`/`Enumerable`-style mixin module (Lessons 04, 07) that participating classes explicitly `include`, rather than relying purely on implicit duck typing.

## Real-World Usage

Rails' `respond_to?(:each)`/`respond_to?(:to_str)` checks and its acceptance of "anything Enumerable" or "anything that acts like a String" throughout its own source are canonical, real examples of duck typing as a deliberate design choice, not merely an accident of a missing type system.

## Summary

- Ruby has zero generic type parameter syntax — a genuine, direct gap shared with Python and PHP, contrasted here against every statically-typed language in this repository.
- Duck typing means only what methods an object responds to matters, never its declared class.
- `respond_to?` is the idiomatic runtime substitute for a compile-time generic constraint, checked at the call site rather than enforced by a compiler.

## Key Terms

- **Duck typing** — treating an object as compatible based purely on which methods it responds to, not its class or any declared interface.
- **`respond_to?`** — checks at runtime whether an object has a given method, the idiomatic Ruby alternative to a compile-time type/generic constraint.

## Interview Questions

1. **Does Ruby have generics, and what's used instead?**
   No — there is no `<T>` type-parameter syntax anywhere in the language. Ruby relies on duck typing: any object responding to the required methods is accepted, regardless of class. `respond_to?` is the idiomatic runtime check used where an argument's shape genuinely isn't guaranteed, verified in this lesson by a `safe_speak` helper that checks `respond_to?(:speak)` before calling it.

2. **What happens if you push a `String` onto a Ruby "generic-like" container meant for integers?**
   Nothing — there's no type parameter to violate, so it's accepted silently at runtime, verified directly in this lesson by pushing an `Integer`, a `String`, an `Array`, and a `Symbol` onto the identical `Stack` instance with zero errors. This directly contrasts with a statically-typed generic container (e.g., Java's `Stack<Integer>`), which would refuse to even compile code attempting the equivalent `String` push.

## Recommended Next Lesson

[14 — Threads and Fibers](../14-Threads-and-Fibers/README.md)
