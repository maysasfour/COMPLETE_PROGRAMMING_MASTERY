# 03 — Variables and Data Types

[Back to course overview](../README.md) | [Previous: Syntax](../02-Syntax/README.md)

## Learning Objectives

- Understand Dart's **sound null safety** (since Dart 2.12): `String` vs. `String?`, directly comparable to Kotlin's nullable types and Swift's Optionals, both covered earlier in this repository.
- Use null-aware operators: `?.`, `??`, `??=`, and `!` (the "bang" operator).
- Use `late` for deferred initialization, and understand `dynamic` as an explicit opt-out from static type checking.

## Prerequisites

[02-Syntax](../02-Syntax/README.md)

## Concept

Dart's sound null safety means `String` and `String?` are genuinely different types, checked at compile time — the third language in a row covered in this repository (after Kotlin and Swift) with this same core design, though Dart's specific operator set (`?.`, `??`, `??=`, `!`) has its own particular shape, closely resembling Kotlin's.

## `String` vs. `String?`, Verified Live

```dart
String nonNullable = 'always has a value';
String? nullable; // defaults to null
// nonNullable = null; // COMPILE ERROR
```

Verified live: assigning `null` to a non-nullable `String` produces a real compile error:

```
Error: A value of type 'Null' can't be assigned to a variable of type 'String'.
```

## Null-Aware Operators: `?.`, `??`, `??=`

```dart
nullable?.length             // ?.  -- null if nullable is null, no exception
nullable ?? 'no value'        // ??  -- default if nullable is null (like Kotlin's ?:/Swift's ??)
nullable ??= 'assigned only if null' // ??= -- assigns ONLY if currently null
```

## The Bang Operator (`!`), Verified Live to Crash on Actual Null

```dart
String? maybeValue;
print(maybeValue!.toUpperCase()); // asserts non-null
```

Verified live: force-unwrapping an actually-`null` value with `!` throws a genuine runtime exception:

```
Unhandled exception:
Null check operator used on a null value
```

This is directly comparable to Kotlin's `!!` (which also throws a catchable exception on a wrong assumption) rather than Swift's `!` (which crashes with an unrecoverable fatal error) — Dart's `!` failure is a normal, catchable `TypeError`-family exception, not a hard, uncatchable crash.

## `late` — Deferred Initialization

```dart
late String lateValue;
lateValue = 'assigned later, but before use'; // must be assigned before its first READ
print(lateValue);
```

`late` promises the compiler a non-nullable variable will be initialized before its first use, even though it isn't assigned at its declaration — useful for values that are genuinely non-null once set up, but can't be initialized inline (e.g., a value computed in a constructor body, or requiring a circular reference).

## `dynamic` — Explicit Opt-Out from Static Checking

```dart
var staticallyTyped = 42;         // inferred as int, and REMAINS int -- reassigning is an error
dynamic trulyDynamic = 42;
trulyDynamic = 'now a string';       // legal -- dynamic bypasses static type checking entirely
```

`var` infers a concrete static type at the point of first assignment and remains that type; `dynamic` explicitly opts a variable out of Dart's static type checking, allowing it to hold any type and be reassigned to any other type freely (with type errors deferred to runtime instead).

## Detailed Example

See [example.dart](example.dart) — basic types, the null-safety compile error (documented, not left live-breaking in the main file), null-aware operators, the bang operator (with its runtime-crash behavior also documented separately), `late`, and `var` vs. `dynamic`.

## Run It

```bash
cd 01-Languages/Dart/03-Variables-and-Data-Types
dart run example.dart
```

## Expected Output

Running `dart run example.dart` prints the basic type values, `nullable: null`, the null-aware operator results (`length: null`, `default: no value`, `after ??=: assigned only if null`), `TRUST ME` (the bang-operator-unwrapped, uppercased string), the `late`-initialized value, and both `staticallyTyped: 42` and `trulyDynamic: now a string`.

## Common Mistakes

- Assuming any variable can hold `null` "just in case," out of pre-null-safety Dart habit (or JavaScript/pre-Kotlin-2.12 assumptions) — Dart's sound null safety requires an explicit `?` for this, enforced as a compile error, verified live in this lesson.
- Using `!` without being certain the value can't be `null` — verified live to throw "Null check operator used on a null value" if wrong; while catchable (unlike Swift's `!`), an uncaught version still crashes the program.
- Reading a `late` variable before it's been assigned — this throws a `LateInitializationError` at runtime, distinct from the "used before assignment" compile errors of some other languages.

## Best Practices

- Prefer non-nullable types by default; mark a type nullable (`String?`) only when `null` is a genuinely meaningful, expected value.
- Use `??`/`??=` for sensible defaults instead of `!` wherever a reasonable fallback exists.
- Reserve `dynamic` for genuinely dynamic scenarios (e.g., interop with untyped JSON before validation) — using it as a shortcut to avoid fixing type errors defeats Dart's static type safety.

## Real-World Usage

Dart's sound null safety was a major, deliberately-marketed Dart 2.12 language change specifically to reduce null-reference runtime crashes in Flutter apps — real Flutter/Dart codebases lean heavily on non-nullable-by-default types, with `late` commonly used for widget state initialized in `initState()` rather than at field declaration.

## Summary

- Dart's sound null safety (`String` vs `String?`) is directly comparable to Kotlin's and Swift's null-safety systems, both covered earlier in this repository — verified live via a real compile error for an invalid non-nullable assignment.
- `?.`, `??`, `??=`, and `!` are Dart's null-aware operator set; `!` throws a catchable runtime exception (verified live), unlike Swift's harder-crashing force-unwrap.
- `late` defers initialization while still promising non-nullability; `dynamic` explicitly opts out of static type checking, unlike `var`, which infers and keeps a concrete static type.

## Key Terms

- **Sound null safety** — Dart's compile-time-enforced distinction between nullable (`T?`) and non-nullable (`T`) types.
- **`late`** — defers a non-nullable variable's initialization past its declaration, promising it will be set before first use.

## Interview Questions

1. **How does Dart's `!` (bang) operator differ in failure behavior from Swift's force-unwrap, given both languages were covered in this repository?**
   Both assert a nullable/optional value is definitely non-null at that point. Verified live in this lesson, Dart's `!` throws a normal, catchable runtime exception ("Null check operator used on a null value") if the assumption is wrong — calling code can `try`/`catch` it like any other exception. Swift's force-unwrap (`!`, covered in the Swift course) instead triggers an unrecoverable fatal error with no catch-based recovery path at all. This makes an incorrect `!` in Dart a normal, recoverable exception, while the equivalent mistake in Swift is a harder, uncatchable crash — a meaningful difference in failure severity between the two languages' otherwise very similar null-safety designs.

2. **What does `late` provide that a nullable type (`T?`) doesn't, and why might it be preferred?**
   `late` lets a variable be declared as genuinely non-nullable (no `?`) while deferring its actual initialization past the point of declaration — the compiler trusts the programmer's promise that it will be assigned before any read, and enforces this at runtime (throwing a `LateInitializationError` if violated). This differs from simply using `T?` and treating "not yet set" as `null`: with `late`, every *read* of the variable is guaranteed non-null by the type system (no `?.`/`??`/`!` needed at every use site), at the cost of a runtime error if the "assigned before use" promise is broken — appropriate when a value is genuinely always going to be non-null by the time it's actually read (e.g., initialized in a constructor body or an `initState()`-style setup method), just not inline at the declaration itself.

## Recommended Next Lesson

[04 — Operators](../04-Operators/README.md)
