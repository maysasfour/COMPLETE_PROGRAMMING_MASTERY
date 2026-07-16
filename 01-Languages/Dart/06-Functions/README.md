# 06 — Functions

[Back to course overview](../README.md) | [Previous: Control Flow](../05-Control-Flow/README.md)

## Learning Objectives

- Use named parameters (`{required, default}`) and optional positional parameters (`[...]`).
- Use closures and anonymous functions, verifying live that Dart closures capture by reference and can mutate captured variables — like Kotlin/Swift, both covered earlier in this repository.

## Prerequisites

[05-Control-Flow](../05-Control-Flow/README.md)

## Concept

Dart functions support two distinct optional-parameter styles: named parameters (`{...}`, called by name at the call site, order-independent) and optional positional parameters (`[...]`, called positionally, with a default if omitted) — a function can use one style or the other, but not typically mix optional positional and named parameters in the same signature (required positional parameters can be combined with either).

## Named Parameters

```dart
String greet({required String name, String greeting = 'Hello'}) {
  return '$greeting, $name!';
}
greet(name: 'Ada');                       // uses default greeting
greet(greeting: 'Hi', name: 'Grace');      // order-independent
```

`required` makes a named parameter mandatory (a compile error if omitted at the call site); without it, a named parameter is optional and should have a default value or be nullable.

## Optional Positional Parameters

```dart
String multiply(int a, [int b = 2]) {
  return '${a * b}';
}
multiply(5);      // uses default b=2 -- 10
multiply(5, 3);      // explicit b=3 -- 15
```

## Closures Capture by Reference, Can Mutate

```dart
Function() makeCounter() {
  var count = 0;
  return () {
    count += 1;
    return count;
  };
}
var counter = makeCounter();
counter(); // 1
counter(); // 2
counter(); // 3 -- state persists across calls
```

Verified live: calling the returned closure repeatedly produces `1`, `2`, `3` — matching the exact same mutable-closure-capture behavior demonstrated in this repository's Kotlin and Swift courses, and genuinely different from Java's effectively-final lambda capture restriction.

## Detailed Example

See [example.dart](example.dart) — named parameters, optional positional parameters, a signature combining required positional with named parameters, anonymous functions/arrow syntax, and the live-verified mutable closure capture.

## Practice

- [Exercises/exercise.dart](Exercises/exercise.dart) — implement a named-parameter `average()` function and an `isPrime` helper used with `.where()`.
- [Solutions/solution.dart](Solutions/solution.dart) — a worked solution, run and verified to correctly list primes up to 30 and compute an average of `2.5`.

## Run It

```bash
cd 01-Languages/Dart/06-Functions
dart run example.dart
dart run Solutions/solution.dart
```

## Expected Output

`example.dart` prints two greetings, `10` and `15` (the optional positional parameter demonstrations), both `describe()` results, `15` and `8` (the closure/anonymous-function demonstrations), and `1`, `2`, `3` (confirming the mutable closure capture, verified live). `Solutions/solution.dart` prints the correct list of primes up to 30 and `average: 2.5`.

## Common Mistakes

- Forgetting `required` on a named parameter that has no sensible default — without it, the parameter is optional and, if not given a default value, must be nullable, or Dart's static analysis will flag it.
- Mixing optional positional parameters (`[...]`) and named parameters (`{...}`) in the same function signature — Dart requires choosing one style or the other for a given function's optional parameters (required positional parameters can be freely combined with either).
- Assuming Dart closures have Java-like restrictions on capturing mutable local variables — verified live that they don't; Dart closures capture by reference and can freely mutate captured variables, matching Kotlin/Swift's behavior.

## Best Practices

- Use named parameters for functions with several optional/boolean parameters, to make call sites self-documenting — a widely-followed Dart/Flutter convention (Flutter widget constructors use named parameters pervasively).
- Use `required` explicitly for any named parameter that must always be provided.
- Use arrow syntax (`=>`) for single-expression functions/closures, reserving full block bodies (`{ }`) for multi-statement logic.

## Real-World Usage

Named parameters are a defining, heavily-used Dart/Flutter idiom — virtually every Flutter widget constructor uses named parameters (often all of them optional except a `required` few) specifically so widget configuration reads clearly regardless of how many properties are set, a design convention distinctive to Dart/Flutter among the languages covered in this repository.

## Summary

- Named parameters (`{required, default}`) and optional positional parameters (`[...]`) are Dart's two distinct optional-parameter mechanisms.
- Closures capture by reference and can mutate captured variables — verified live, matching Kotlin's and Swift's behavior, both covered earlier in this repository.

## Key Terms

- **Named parameter** — a function parameter called by name (`param: value`) at the call site, optionally marked `required`.
- **Optional positional parameter** — a function parameter in `[...]` brackets, called positionally with a default value if omitted.

## Interview Questions

1. **What's the difference between Dart's named parameters and optional positional parameters, and why might a Flutter API prefer named parameters?**
   Named parameters (`{required String name, String greeting = 'Hello'}`) are called by explicit name at the call site (`greet(name: 'Ada')`), making argument order irrelevant and each argument's purpose immediately clear from reading the call. Optional positional parameters (`[int b = 2]`) are called purely by position, with a default value substituted if the argument is omitted — but omitting one but supplying a later one isn't possible, unlike with named parameters. Flutter widget constructors overwhelmingly use named parameters specifically because widgets often have many optional configuration properties, and named parameters let a call site clearly show which specific properties are being set, in any order, rather than requiring memorization of a long positional parameter list's exact order.

2. **How does Dart's closure variable capture compare to Java's, given this was also demonstrated in this repository's Kotlin and Swift courses?**
   Dart closures capture variables by reference and can freely mutate a captured local variable across multiple invocations — verified directly in this lesson with a counter closure that genuinely incremented shared state across three separate calls (`1`, `2`, `3`). This matches the exact behavior demonstrated in this repository's Kotlin and Swift courses, and contrasts with Java's lambdas, which can only capture local variables that are "effectively final" (assigned exactly once) — attempting to mutate a captured local variable inside a Java lambda is a compile error, requiring a workaround (like a wrapping mutable object) to achieve the same stateful-closure effect Dart, Kotlin, and Swift all provide natively.

## Recommended Next Lesson

[07 — Collections](../07-Collections/README.md)
