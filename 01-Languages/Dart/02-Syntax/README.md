# 02 — Syntax

[Back to course overview](../README.md) | [Previous: Setup](../01-Setup/README.md)

## Learning Objectives

- Use Dart's required `void main()` entry point.
- Distinguish `var` (type-inferred, reassignable), `final` (single-assignment, runtime-determined), and `const` (compile-time constant).
- Use string interpolation and mandatory semicolons.

## Prerequisites

[01-Setup](../01-Setup/README.md)

## Concept

Unlike Kotlin and Swift (both covered earlier in this repository), which allow top-level executable statements with no entry-point function required, Dart requires an explicit `void main()` function as its entry point — closer to C#/Java/Go's convention. Dart also requires semicolons at the end of every statement, unlike Kotlin/Swift's optional-semicolon style.

## `var`, `final`, and `const`

```dart
var name = 'World';        // type inferred (String), but still reassignable
final greeting = 'Hello';    // single-assignment, VALUE determined at runtime
const pi = 3.14159;            // single-assignment, VALUE must be known at COMPILE time
```

`final` and `const` are both single-assignment, but differ in when their value must be known: `final` can be assigned any expression computed at runtime (e.g., the result of a function call), while `const` requires a genuinely compile-time-constant value. Verified live: attempting to reassign a `final` variable produces a real compile error:

```
Error: Can't assign to the final variable 'greeting'.
```

## String Interpolation

```dart
print('$greeting, $name!');       // $var for simple variable interpolation
print('pi + 1 = ${pi + 1}');       // ${expression} for arbitrary expressions
```

Dart's `$var`/`${expression}` interpolation is functionally equivalent to Kotlin's `$var`/`${expr}` (covered in this repository's Kotlin course) or Swift's `\(expr)` (covered in the Swift course) — all serve the identical purpose with different syntax.

## Detailed Example

See [example.dart](example.dart) — `var`/`final`/`const`, string interpolation, and mandatory semicolons, all run and verified.

## Run It

```bash
cd 01-Languages/Dart/02-Syntax
dart run example.dart
```

## Expected Output

Running `dart run example.dart` prints `Hello, World!`, `pi + 1 = 4.14159`, `count is now 1`, and `semicolons are mandatory in Dart` — all verified by actual execution.

## Common Mistakes

- Attempting to reassign a `final` variable — verified live to produce a compile error, not a runtime exception, since Dart's compiler enforces single-assignment statically.
- Using `const` for a value that isn't actually knowable at compile time (e.g., the result of a network call or even certain runtime computations) — this is a compile error; `final` should be used instead for runtime-determined single-assignment values.
- Forgetting semicolons out of habit from Kotlin/Swift, both of which allow omitting them — Dart requires them at the end of every statement.

## Best Practices

- Prefer `final` over `var` wherever a variable's value doesn't need to change after initialization, and `const` over `final` wherever the value is genuinely known at compile time — following the same "immutable by default" philosophy as Kotlin (`val`) and Swift (`let`), both covered earlier in this repository.
- Use string interpolation (`$var`/`${expr}`) instead of manual string concatenation.

## Real-World Usage

Dart/Flutter code makes heavy, idiomatic use of `const` specifically for performance: a `const` widget constructor in Flutter tells the framework the resulting widget instance is immutable and can be reused/cached across rebuilds without re-allocating it, making `const`-correctness a genuinely performance-relevant habit in real Flutter development, beyond just a style preference.

## Summary

- Dart requires an explicit `void main()` entry point, unlike Kotlin/Swift's top-level-statement flexibility.
- `var` (reassignable), `final` (single-assignment, runtime value), and `const` (single-assignment, compile-time value) are distinct, each enforced by the compiler — verified live for `final`.
- String interpolation and mandatory semicolons round out Dart's core syntax.

## Key Terms

- **`final`** — a single-assignment variable whose value can be any runtime expression.
- **`const`** — a single-assignment variable whose value must be a compile-time constant.

## Interview Questions

1. **What's the difference between `final` and `const` in Dart, given both are single-assignment?**
   Both prevent reassignment after their initial value is set, but they differ in *when* that value must be determined: `final`'s value can be the result of any expression evaluated at runtime (a function call, a value read from user input, etc.), while `const`'s value must be a genuine compile-time constant — knowable and fixed before the program even runs (literal values, or expressions built entirely from other `const` values). Verified directly in this lesson: attempting to reassign a `final` variable produces the compile error "Can't assign to the final variable" — the same restriction applies to `const`, but `const` additionally requires its initial value to satisfy the stricter compile-time-known requirement.

2. **Why does Dart require an explicit `void main()` function, unlike Kotlin or Swift, both covered earlier in this repository?**
   Dart's language design follows a more traditional entry-point convention (similar to C#, Java, and Go, also covered in this repository) requiring a specific, named `main()` function as the program's starting point, rather than allowing arbitrary top-level executable statements the way Kotlin and Swift do. This is largely a language design choice with no deep technical necessity — it does mean every Dart program has an unambiguous, explicitly-named entry point, which can aid readability and tooling (IDEs, debuggers) in immediately identifying where execution begins, at the minor cost of the small amount of boilerplate the `void main() { }` wrapper requires compared to Kotlin/Swift's more minimal top-level-script style.

## Recommended Next Lesson

[03 — Variables and Data Types](../03-Variables-and-Data-Types/README.md)
