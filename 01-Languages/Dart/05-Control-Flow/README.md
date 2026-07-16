# 05 — Control Flow

[Back to course overview](../README.md) | [Previous: Operators](../04-Operators/README.md)

## Learning Objectives

- Use `if`/`else` and `switch`, verifying live that Dart's `switch` does **not** fall through by default — matching Go/Swift, unlike C/Java/JavaScript.
- Use Dart 3's `switch` **expressions** (producing a value directly) with pattern matching, `when` guards, and "or" patterns (`||`).
- Use the explicit `continue`-with-label mechanism for intentional fall-through.

## Prerequisites

[04-Operators](../04-Operators/README.md)

## Concept

Dart's `switch` statement does not fall through by default — verified live in this lesson, matching Go and Swift's design choice (both covered earlier in this repository), the opposite of C/Java/JavaScript's fall-through-unless-`break` convention. Dart 3 additionally introduced `switch` **expressions**, pattern matching, and record destructuring, making `switch` a considerably more powerful, modern construct than a traditional C-style switch.

## `switch`: No Fall-Through by Default, Verified Live

```dart
switch (day) {
  case 1:
    print('Monday'); // does NOT fall through to case 2
  case 2:
    print('Tuesday');
  default:
    print('other');
}
```

Verified live: with `day = 1`, only `Monday` printed — execution did not continue into `case 2`'s body, confirming Dart's `switch` doesn't fall through even without an explicit `break`.

## Explicit Fall-Through: `continue` with a Label

```dart
switch (day) {
  case 1:
    print('Monday (explicit fallthrough)');
    continue tuesday; // opts INTO falling through to the "tuesday" label
  tuesday:
  case 2:
    print('Tuesday (reached via fallthrough or directly)');
  default:
    print('other');
}
```

Verified live: with this explicit `continue tuesday;` statement, both `Monday` and `Tuesday`'s messages printed — Dart provides fall-through only as a deliberate, explicit opt-in via a labeled `continue`, never implicitly.

## Dart 3 `switch` Expressions

```dart
var dayType = switch (day) {
  1 || 2 || 3 || 4 || 5 => 'Weekday', // || inside a pattern -- "or" patterns
  6 || 7 => 'Weekend',
  _ => 'Invalid day', // _ is the wildcard pattern
};
```

## Pattern Matching with Records

```dart
var point = (2, 0); // a record (a Dart 3 feature, covered further in Lesson 11)
var description = switch (point) {
  (0, 0) => 'origin',
  (_, 0) => 'on the x-axis',
  (0, _) => 'on the y-axis',
  _ => 'elsewhere',
};
```

## Detailed Example

See [example.dart](example.dart) — `if`/`else`, both `switch` fall-through demonstrations (verified live), a Dart 3 `switch` expression with "or" patterns, record-based pattern matching, and loops (including the `indexed` extension for indexed iteration).

## Practice

- [Exercises/exercise.dart](Exercises/exercise.dart) — implement FizzBuzz using a `switch` expression with `when` guards.
- [Solutions/solution.dart](Solutions/solution.dart) — a worked solution, run and verified to produce the correct 1–15 FizzBuzz sequence.

## Run It

```bash
cd 01-Languages/Dart/05-Control-Flow
dart run example.dart
dart run Solutions/solution.dart
```

## Expected Output

`example.dart` prints `grade: B`, `Monday` (confirming no fall-through), then both `Monday (explicit fallthrough)` and `Tuesday (reached via fallthrough or directly)` (confirming the explicit `continue`-label mechanism), `dayType: Weekday`, `on the x-axis`, and the loop output including indexed iteration. `Solutions/solution.dart` prints the standard FizzBuzz sequence for 1–15 — all confirmed by actual execution.

## Common Mistakes

- Assuming Dart's `switch` falls through by default out of C/Java/JavaScript habit — verified live that it doesn't; each case implicitly terminates unless explicit fall-through is requested via `continue label;`.
- Forgetting a `switch` expression (unlike a `switch` statement) must be exhaustive — a missing case (with no matching `_` wildcard) is a compile error, since every possible input must produce a value.
- Confusing the wildcard pattern `_` with a variable named `_` — in pattern-matching contexts, `_` specifically means "match anything, don't bind a name."

## Best Practices

- Prefer Dart 3's `switch` expressions over `switch` statements plus manual variable assignment, when the goal is genuinely to produce a single value from multiple cases.
- Use "or" patterns (`1 || 2 || 3`) to group several matching values in one case, rather than relying on fall-through.
- Reserve explicit `continue`-with-label fall-through for genuinely intentional shared-logic cases — it's rare in idiomatic modern Dart precisely because `switch` expressions and or-patterns usually express the same intent more directly.

## Real-World Usage

Dart 3's pattern matching and `switch` expressions are increasingly used in modern Flutter/Dart code for concise state modeling (matching over a sealed class hierarchy, covered further in Lesson 11) and destructuring records — a significant, well-received language evolution that brought Dart's pattern-matching capabilities much closer to Kotlin's/Swift's `when`/`switch` expressions, both covered earlier in this repository.

## Summary

- Dart's `switch` does not fall through by default — confirmed live, matching Go/Swift, unlike C/Java/JavaScript.
- Explicit fall-through requires a labeled `continue` statement — a deliberate opt-in, also confirmed live.
- Dart 3's `switch` expressions, "or" patterns, and record destructuring make `switch` a considerably more powerful, modern construct.

## Key Terms

- **`switch` expression** — a Dart 3 construct producing a value directly from pattern-matched cases, exhaustiveness-checked by the compiler.
- **"Or" pattern (`||`)** — combines several patterns into one case, matching if any of them match.

## Interview Questions

1. **Does Dart's `switch` fall through by default, and how was this verified rather than assumed?**
   No — verified directly by running a `switch` statement with `day = 1` and no `break` after `case 1`'s body: only `Monday` printed, confirming execution did not continue into `case 2`'s body. This matches Go and Swift's design choice (both covered earlier in this repository), the opposite of C, Java, and JavaScript's fall-through-by-default switch statements. Dart does provide an explicit fall-through mechanism via a labeled `continue` statement (also verified live, producing both cases' output when used), making fall-through a deliberate opt-in rather than something requiring active prevention.

2. **What does a Dart 3 `switch` expression provide that a traditional `switch` statement doesn't?**
   A `switch` expression evaluates directly to a value (assignable to a variable with `=`), using `=>` to associate each pattern with its resulting expression, and is exhaustiveness-checked by the compiler — every possible input must be handled by some case (typically ensured by a final `_` wildcard pattern), or it's a compile error. It also supports richer pattern matching than a traditional switch's simple value equality: "or" patterns (`1 || 2 || 3`) combine multiple values into one case, and record/object destructuring patterns (like `(0, 0) => 'origin'` in this lesson) let a single case match based on a value's internal structure — capabilities well beyond a traditional C-style switch statement's simple case-value matching.

## Recommended Next Lesson

[06 — Functions](../06-Functions/README.md)
