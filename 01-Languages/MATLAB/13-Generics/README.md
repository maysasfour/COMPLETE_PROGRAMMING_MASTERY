# 13 — Generics (MATLAB Has No Generics)

[Back to course overview](../README.md) | [Previous: Functional Concepts](../12-Functional-Concepts/README.md)

## Honest Note: This Language Feature Does Not Exist in MATLAB

Per this repository's [CONTRIBUTING.md](../../../CONTRIBUTING.md) rule ("a language without generics should say so explicitly rather than leaving the folder empty"), this lesson exists specifically to document that MATLAB has **no generics** — no type-parameterized classes, functions, or containers comparable to Java's `List<T>`, C#'s `List<T>`, Rust's `Vec<T>`, Swift's `Array<Element>`, or TypeScript's `Array<T>`.

## Why MATLAB Doesn't Need Them the Way Statically-Typed Languages Do

MATLAB is dynamically typed and matrix-first:

- Every core container (`double` matrix, `cell` array, `struct` array) is **already heterogeneous or untyped by construction**. A `cell` array can hold any mix of types in any element with zero ceremony — `{1, 'two', [3 4 5], struct('a',1)}` is valid MATLAB with no type declaration of any kind.
- Numeric matrices are homogeneous by necessity (linear algebra requires it), but that's a runtime/mathematical constraint, not a type-system feature — there's no `Matrix<T>` you parameterize; a `double` matrix just holds `double`s, full stop, and Octave/MATLAB will silently convert other numeric types (`int32`, `single`) into `double` on mixed arithmetic rather than erroring.
- Function inputs are untyped by default — the same function can be called with a scalar, a matrix, a string, or a struct, and it's up to the function body (via `isa`/`class`/`validateattributes`) to check what it actually received. This is closer to duck typing than to generic programming.

## What MATLAB Uses Instead

- **`validateattributes(x, classes, attributes)`** and **argument validation blocks** (`arguments ... end`, MATLAB R2019b+) constrain a function's accepted input *types and shapes* at the boundary, which is the closest MATLAB gets to compile-time-generics-style safety — except it's a runtime check, not a compile-time guarantee.
- **`cell` arrays** and **`containers.Map`** (a MATLAB associative-array class, key/value, keys can be char or numeric) serve the role a generic `List<T>`/`Dictionary<K,V>` would in a statically typed language, just without any static type parameter — you find out at runtime if you put something unexpected in.
- **Object-oriented `classdef` methods** (Lesson 11) can accept `obj` of any class and rely on polymorphism/duck typing rather than generic type parameters to write code that works across related types.

## Real-World Implication

Code that in Java/C#/TypeScript would be one generic `Stack<T>` class is, in MATLAB, typically just **one `classdef` whose properties are untyped `cell` or plain matrix**, working for whatever you put in — with correctness enforced by tests and `validateattributes` calls rather than the compiler. This trades compile-time type safety for flexibility and less boilerplate, which fits MATLAB's primary use case (interactive numerical/scientific computing) but is a real, documented gap compared to languages built around static generics.

## Suggested Next Lesson

[14 — Concurrency](../14-Concurrency/README.md)
