# 09 — Error Handling

[Back to course overview](../README.md) | [Previous: Strings](../08-Strings/README.md)

## Learning Objectives

- Use `try`/`catch`/`finally`, `on SpecificType catch`, and custom exceptions via `implements Exception`.
- Use `rethrow` to propagate a caught exception further up while preserving its stack trace.
- Understand Dart's `Error`/`Exception` split — similar in spirit to PHP's `Error`/`Exception` hierarchy, covered earlier in this repository, though Dart has no single shared `Throwable` root type at all: literally any object can be thrown.

## Prerequisites

[08-Strings](../08-Strings/README.md)

## Concept

Dart's error handling is exception-based, but with a genuinely permissive twist: **any object can be thrown**, not just instances of a specific `Throwable`/`Exception` hierarchy (unlike Kotlin, Java, C#, and PHP, all covered earlier in this repository, all of which require thrown objects to implement a specific base type). By convention, though, thrown objects implement either `Exception` (expected, recoverable failures) or extend `Error` (programming mistakes, like `RangeError`/`ArgumentError`) — mirroring PHP's `Error`/`Exception` split, covered in this repository's PHP course.

## `try`/`catch`/`finally` and `on SpecificType`

```dart
try {
  print(divide(5, 0));
} on ArgumentError catch (e) {
  print('caught: ${e.message}');
} finally {
  print('finally always runs');
}
```

`on SpecificType catch (e)` catches only that specific type (and its subtypes); `on SpecificType` alone (no `catch (e)`) catches the type without binding a variable, useful when the exception's specific details aren't needed.

## Custom Exceptions via `implements Exception`

```dart
class InsufficientFundsException implements Exception {
  final double shortfall;
  InsufficientFundsException(this.shortfall);
  @override
  String toString() => 'InsufficientFundsException: short by $shortfall';
}
```

`Exception` is a marker interface with no required methods — any class can `implement` it to signal "this represents an expected, recoverable failure," carrying whatever custom data/behavior it needs.

## `Error` vs. `Exception`

```dart
var list = [1, 2, 3];
print(list[10]); // throws RangeError -- a subtype of Error, not Exception
```

Verified live: indexing past a list's bounds throws `RangeError`, a built-in `Error` subtype — by Dart's convention, `Error` subtypes represent programming mistakes (an out-of-bounds index, an invalid argument), while `Exception` subtypes represent expected, application-level recoverable failures (like the custom `InsufficientFundsException` above). Unlike Kotlin/Java/PHP (all covered elsewhere in this repository), which enforce this split through actual distinct type hierarchies under a common root, Dart's split is purely conventional — since literally any object (not just `Error`/`Exception` instances) can be thrown in Dart at all.

## `rethrow`

```dart
try {
  throw StateError('something went wrong internally');
} catch (e) {
  print('logging the error before rethrowing: $e');
  rethrow; // propagates the SAME exception (preserving its original stack trace)
}
```

`rethrow` (rather than `throw e;`) preserves the exception's original stack trace, pointing to where it was first thrown rather than where it was rethrown — important for accurate debugging when an exception is caught, logged, and then intentionally propagated further.

## Detailed Example

See [example.dart](example.dart) — `try`/`catch`/`finally`, a custom exception with a data-carrying property, `on SpecificType` without a bound variable, the live-verified `Error`-vs-`Exception` distinction via `RangeError`, and `rethrow`.

## Run It

```bash
cd 01-Languages/Dart/09-Error-Handling
dart run example.dart
```

## Expected Output

Running `dart run example.dart` prints `5.0`, `caught: cannot divide 5.0 by zero` then `finally always runs`, the custom exception's message plus its `shortfall` property, a caught `FormatException` message, `caught RangeError: Invalid value` (confirming the `RangeError`/`Error`-subtype behavior), and both the logged and rethrown-and-recaught `StateError` messages — all confirmed by actual execution.

## Common Mistakes

- Assuming Dart requires thrown objects to implement a specific base `Throwable`/`Exception` type — it doesn't; literally any object can be thrown, though following the `Exception`/`Error` convention (as this lesson does) is strongly recommended for consistency and clarity.
- Using `throw e;` instead of `rethrow;` when propagating a caught exception — `throw e;` resets the stack trace to the rethrow point, losing the original throw location, which `rethrow` preserves.
- Catching `Error` subtypes (like `RangeError`) broadly in normal application logic — by convention, these represent programming bugs that should be fixed, not routinely handled at runtime, mirroring the same guidance given for PHP's `Error` hierarchy in this repository's PHP course.

## Best Practices

- Implement `Exception` for custom, application-defined failure conditions meant to be caught and handled as part of normal control flow.
- Use `rethrow` (not `throw e;`) whenever a caught exception needs to be logged/inspected and then propagated further.
- Reserve broad `catch (e)` (with no `on SpecificType`) for top-level error boundaries; prefer `on SpecificType catch (e)` for routine, specific error handling.

## Real-World Usage

The convention of implementing `Exception` for recoverable, application-level failures (while treating `Error` subtypes as bugs to fix, not handle) is standard practice in real Dart/Flutter codebases — Flutter itself throws various `FlutterError`/`Error` subtypes for framework-detected programming mistakes, distinct from application-level `Exception`s that represent expected failure conditions like network errors or validation failures.

## Summary

- Dart's error handling is exception-based, but genuinely permissive: any object can be thrown, not just instances of a required base type.
- By convention (not enforcement), `Exception` represents expected, recoverable failures, while `Error` subtypes (like the live-verified `RangeError`) represent programming mistakes — mirroring PHP's `Error`/`Exception` split, covered elsewhere in this repository.
- `rethrow` preserves an exception's original stack trace when propagating it further, unlike `throw e;`.

## Key Terms

- **`Exception`** — a marker interface (no required methods) by convention implemented by custom, recoverable failure types.
- **`rethrow`** — propagates a caught exception further up the call stack while preserving its original stack trace.

## Interview Questions

1. **Does Dart require a thrown object to implement a specific base type, unlike Kotlin, Java, or PHP, all covered elsewhere in this repository?**
   No — Dart is genuinely permissive here: literally any object can be thrown with `throw`, with no required base `Throwable`/`Exception` type at all. By strong convention (not compiler enforcement), custom recoverable failure types implement the `Exception` marker interface, while programming-mistake-representing failures (like the built-in `RangeError`, verified live in this lesson to result from an out-of-bounds list index) extend `Error`. This is looser than Kotlin/Java (which require a `Throwable` subtype) or PHP (which requires either `Error` or `Exception`, both under a shared `Throwable` interface), though following the `Exception`/`Error` convention is universally recommended in real Dart code for consistency and clarity.

2. **Why does `rethrow` matter, and how does it differ from `throw e;` inside a catch block?**
   `rethrow` propagates the currently-caught exception further up the call stack while preserving its *original* stack trace — pointing to exactly where the exception was first thrown. `throw e;`, by contrast, throws the same exception object, but generates a *new* stack trace starting from the `throw e;` statement itself, losing the information about where the exception actually originated. This matters for debugging: verified live in this lesson, a caught `StateError` was logged and then propagated with `rethrow`, and code catching it further up saw the exception's original message intact — using `rethrow` (rather than `throw e;`) is the correct, idiomatic way to log-and-propagate without corrupting the exception's diagnostic trail.

## Recommended Next Lesson

[10 — File Handling](../10-File-Handling/README.md)
