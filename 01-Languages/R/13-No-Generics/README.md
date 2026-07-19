# 13 — No Generics

[Back to course overview](../README.md) | [Previous: Functional Concepts](../12-Functional-Concepts/README.md)

## Honest Coverage: R Has No Static Type System, and No Generics in the Conventional Sense

Languages like Java, C#, TypeScript, or Rust have **generics**: a way to write a function or class parameterized over a type (`List<T>`, `Vec<T>`), checked at compile time so `List<String>` and `List<Int>` are distinct, type-safe instantiations. **R has nothing like this**, and it isn't a gap to work around — it follows directly from R being dynamically typed with no compile-time type checker at all (Lesson 03). There is no `T`, no type parameter syntax, and no compiler to enforce one even if there were.

## Why R Doesn't Need Generics the Way Typed Languages Do

In a statically-typed language, generics exist specifically to let you write one function that works correctly and *type-safely* across many types, without writing it once per type and without giving up compile-time checking. R sidesteps the entire problem: since **every vector and list is already inherently "generic"** via dynamic typing (Lesson 03), a single function just works across whatever type of data is passed in, checked (or not) only at runtime:

```r
first_element <- function(x) x[1]

first_element(c(1, 2, 3))          # 1  - works on a numeric vector
first_element(c("a", "b", "c"))    # "a" - same function, a character vector, no changes needed
first_element(list(TRUE, "x", 5))  # TRUE - same function, a heterogeneous list
```

No type parameter was ever declared. The function is inherently "generic" for free — the tradeoff is that nothing stops you from calling `first_element(42)$nonexistent_field` and getting a confusing runtime error instead of a compile-time one.

## What R Has Instead

- **S3/S4 dispatch** (Lesson 11) provides a different, related mechanism: the *same generic function name* can behave differently depending on an object's class, which covers some of what generics + polymorphism give you in typed languages — but it's runtime dispatch on a class attribute, not compile-time type parameterization.
- **Dynamic typing itself** (Lesson 03) is what makes most "generic" code unnecessary — you just write the function once and pass whatever type you want.
- There is no analogue to a type-parameterized container (`List<T>`) with compile-time guarantees; a list can already hold anything (Lesson 07), with zero type safety enforced.

## Real-World Usage

- Package authors who want some of what generics/type safety provide often rely on runtime argument-type checks (`stopifnot(is.numeric(x))`) at the top of a function, or the `checkmate`/`assertthat` packages, as a manual substitute for what a compiler would otherwise guarantee.
- The absence of generics is rarely felt as a limitation in typical data-analysis R code, since the vectorized, dynamically-typed style (Lessons 03/04/06) already achieves "write once, works on any compatible data" in practice.

## Summary

- R has no static type system and, correspondingly, no generics in the Java/C#/Rust/TypeScript sense — there is no type-parameter syntax and no compiler to enforce one.
- Dynamic typing makes most of what generics solve in typed languages unnecessary: a function written for "a vector" or "a list" already works across whatever type of data is inside it, with no type parameter ever declared.
- R's nearest analogues are S3/S4 dispatch (runtime polymorphism on class, not compile-time type parameterization) and manual runtime type checks (`stopifnot`, `checkmate`) where some safety is desired.

## Key Terms

- **Generics** — a static-typing feature (absent from R) letting a function/class be parameterized over a type, checked at compile time.
- **Dynamic typing** — R's actual mechanism (Lesson 03): types are resolved and checked at runtime, making most generic-style code write-once by default.
- **Runtime type check** — manual validation (`stopifnot`, `is.numeric()`, etc.) as R's substitute for compiler-enforced type safety.

## Common Mistakes

- Looking for generic/type-parameter syntax in R documentation and assuming you're missing something — there genuinely is none.
- Assuming dynamic typing means "no type safety is possible" — you can still validate types manually at runtime with `stopifnot()`/`is.*()` checks, you just don't get it for free from a compiler.
- Writing a separate, near-duplicate function per input type out of habit from a typed language, when a single R function already handles all of them via dynamic typing.

## Best Practices

- Don't try to simulate generics with complex class hierarchies; lean into dynamic typing and write one function that handles the range of inputs you actually expect.
- Add `stopifnot()`/explicit type checks at a function's entry point when you want to fail loudly on the wrong input type, since nothing else will catch it before runtime.
- Reach for S3/S4 dispatch (Lesson 11) when you specifically need different *behavior* per type, rather than trying to force generic-style type parameterization onto R.

## Interview Questions

1. **Does R support generics like Java or TypeScript?**
   No — R has no static type system and no type-parameter syntax at all; this isn't a workaround-able gap, it follows directly from R being dynamically typed with no compile-time checker.

2. **Why doesn't R need generics the way a statically-typed language does?**
   Because dynamic typing already lets a single function operate on any type of vector/list without modification — the problem generics solve (write once, work across types, with compile-time safety) is solved differently: write once, work across types, with runtime (not compile-time) type resolution.

3. **What's R's closest analogue to type-based polymorphism?**
   S3/S4 method dispatch (Lesson 11) — the same generic function name behaves differently depending on an object's class — but this is a runtime dispatch mechanism on a class attribute, not compile-time generic type parameterization.

## Suggested Next Lesson

[14 — Vectorization and Performance](../14-Vectorization-and-Performance/README.md)
