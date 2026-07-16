# 04 — Operators

[Back to course overview](../README.md) | [Previous: Variables and Data Types](../03-Variables-and-Data-Types/README.md)

## Learning Objectives

- Use `~/` (integer division) alongside `/` (always-double division).
- Use the **cascade operator** (`..`) — a genuinely distinctive Dart feature not present in any other language covered in this repository.
- Use the spread operator (`...`/`...?`) in collection literals, and `is`/`as` for runtime type checks/casts.

## Prerequisites

[03-Variables-and-Data-Types](../03-Variables-and-Data-Types/README.md)

## Concept

Most of Dart's operators are unsurprising, but the **cascade operator** (`..`) is genuinely distinctive — not present in any other language covered in this repository — letting multiple method calls or property assignments target the same object without repeating its name.

## `/` vs. `~/`

```dart
10 / 3;    // 3.3333333333333335 -- / ALWAYS returns a double
10 ~/ 3;    // 3 -- ~/ is dedicated INTEGER (truncating) division
```

## The Cascade Operator (`..`)

```dart
var paint = Paint()
  ..color = 'red'   // sets a property on the SAME object
  ..width = 5         // sets ANOTHER property on the SAME object
  ..describe();          // calls a METHOD on the SAME object

// equivalent, without cascades:
// var paint = Paint();
// paint.color = 'red';
// paint.width = 5;
// paint.describe();
```

Verified live: each `..`-prefixed line operates on the object created by `Paint()`, without needing to repeat `paint.` before each call — and the entire cascade expression evaluates to the *original object* (`paint`), not the return value of the last call. This is a real, dedicated Dart syntax feature with no direct equivalent in Kotlin, Swift, or any other language covered in this repository — those languages would require either a builder pattern, a scope function (Kotlin's `apply`, covered in this repository's Kotlin course, is the closest conceptual analogue), or repeating the variable name for each call.

## Spread Operator (`...`/`...?`)

```dart
var list2 = [0, ...list1, 4]; // spreads list1's elements directly into list2

List<int>? maybeNullList;
var list3 = [0, ...?maybeNullList, 1]; // ...? skips spreading entirely if the list is null, no error
```

## `is`/`as`: Runtime Type Checks and Casts

```dart
Object value = 'a string';
if (value is String) {
  print(value.length); // smart-cast: value treated as String within this block
}
var casted = value as String; // explicit cast -- throws if invalid
```

## Detailed Example

See [example.dart](example.dart) — `/` vs. `~/`, the cascade operator building a `Paint` object, both spread operator forms, ternary expressions, and `is`/`as`.

## Run It

```bash
cd 01-Languages/Dart/04-Operators
dart run example.dart
```

## Expected Output

Running `dart run example.dart` prints the arithmetic results (`3.3333333333333335`, `3`, `1`, `3.5`), `Paint(color: red, width: 5)` and `paint.color after cascade: red` (confirming the cascade set both properties on one object), `[0, 1, 2, 3, 4]` (the spread), `[0, 1]` (the null-aware spread skipping a null list), `adult` (the ternary), and the `is`/`as` type-check results — all confirmed by actual execution.

## Common Mistakes

- Using `/` when integer division was intended — `/` always returns a `double` in Dart; `~/` is the dedicated truncating integer division operator.
- Repeating a variable name for each of several consecutive method calls/property assignments on the same object, missing the more idiomatic cascade (`..`) syntax.
- Using `...` (plain spread) on a possibly-null collection — this throws; `...?` is specifically needed to safely skip spreading when the collection is `null`.

## Best Practices

- Use cascades (`..`) when configuring multiple properties or calling several methods on the same freshly-created object — a genuinely idiomatic Dart pattern, especially common in Flutter widget configuration code.
- Use `~/` explicitly whenever integer division is intended, rather than `/` followed by a manual truncation.
- Use `...?` instead of `...` whenever the spread source might legitimately be `null`.

## Real-World Usage

Cascade notation is extremely common in real Flutter/Dart code for configuring controllers, animations, and other stateful objects with several properties set in sequence — it's considered a core, idiomatic Dart pattern specifically because it reads cleanly without repeating the target variable's name for every line.

## Summary

- `/` always returns a `double`; `~/` is dedicated integer (truncating) division.
- The cascade operator (`..`) lets multiple calls/assignments target the same object without repeating its name — a genuinely distinctive Dart feature, verified live.
- Spread (`...`) and null-aware spread (`...?`) work in collection literals; `is`/`as` provide runtime type checks and casts, with smart-casting inside an `is`-checked block.

## Key Terms

- **Cascade operator (`..`)** — chains multiple member accesses/calls onto the same object, itself evaluating to that original object.
- **`~/`** — Dart's dedicated integer (truncating) division operator, distinct from `/` (which always returns a double).

## Interview Questions

1. **What does the cascade operator (`..`) do, and why is it considered a genuinely distinctive Dart feature?**
   The cascade operator lets a sequence of member accesses, property assignments, or method calls all target the same object without repeating a reference to that object on each line — `Paint()..color = 'red'..width = 5..describe()` configures and calls a method on the same freshly-created `Paint` instance in one fluent expression, which itself evaluates to the original object (not the return value of the last cascaded call, verified live in this lesson). No other language covered in this repository has an equivalent dedicated operator for this — Kotlin's `apply` scope function achieves a similar practical effect but is a library function using a lambda, not a first-class language operator the way Dart's `..` is.

2. **Why does Dart have two division operators (`/` and `~/`), and what's the difference?**
   `/` always performs floating-point division and returns a `double`, even when dividing two integers (`10 / 3` yields `3.3333333333333335`, verified live). `~/` performs integer (truncating) division and returns an `int` (`10 ~/ 3` yields `3`). Having two distinct operators makes the intended operation explicit at the call site — code reading `a ~/ b` unambiguously signals integer division was intended, rather than relying on an implicit type-based distinction (as some languages do, where `/` behaves differently depending on whether both operands happen to be integers) or requiring a separate function call.

## Recommended Next Lesson

[05 — Control Flow](../05-Control-Flow/README.md)
