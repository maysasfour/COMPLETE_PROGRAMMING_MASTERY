# Dart

[Back to Languages overview](../README.md) | [Back to repo root](../../README.md)

## What Dart Is

Dart is a statically-typed, class-based language developed by Google, most widely known as the language behind Flutter (Google's cross-platform UI toolkit for building natively-compiled mobile, web, and desktop applications from a single codebase). Dart supports multiple compilation targets: the Dart VM (JIT, for development), ahead-of-time (AOT) native compilation (for release builds), and JavaScript compilation (for web).

## Why / Where It's Used

- **Flutter app development** — Dart's dominant, defining use case: cross-platform mobile, web, and desktop apps from one codebase.
- **Standalone CLI tools and scripts** — Dart's own SDK provides `dart run`/`dart compile` for general-purpose scripting and tooling, independent of Flutter.
- **Server-side Dart** — less common than Flutter, but viable via `dart:io` and frameworks like Shelf.

## Advantages

- Sound null safety (`String` vs. `String?`), directly comparable to Kotlin's and Swift's null-safety systems, both covered earlier in this repository — verified live via real compile errors.
- `Future`/`async`/`await` and `Stream` built directly into the language, no external library needed (matching Swift, contrasting with Kotlin's `kotlinx.coroutines`) — plus `Isolate`s for a genuinely unique, no-shared-memory parallelism model, verified live with a real, ticking timer proving the event-loop-blocking distinction.
- Reified generics (verified live: `is List<int>`/`is List<String>` genuinely distinguish at runtime) — a real, checked improvement over Java's erasure-based generics, covered earlier in this repository.
- Genuinely built-in JSON support via `dart:convert`, matching PHP/JavaScript/Python/Swift, contrasting with Java/Kotlin/C++/Rust.
- Cascade notation (`..`) — a genuinely distinctive language feature for fluently configuring an object, verified live.

## Disadvantages

- Historically tightly coupled to Flutter in public perception, even though Dart is a genuine general-purpose language with its own standalone tooling.
- `List`/`Map`/`Set` use identity equality by default, not content equality — verified live to be a real, surprising gotcha (`[1,2,3] == [1,2,3]` is `false`), requiring `package:collection`'s equality helpers or a manual comparison for content-based equality.
- No built-in database access, matching Swift/C++'s gap, requiring an external package (`sqlite3`, verified live to work with zero system-level setup in this environment).

## How to Install

```bash
# Standalone Dart SDK: https://dart.dev/get-dart
# Or via the Flutter SDK (bundles Dart): https://flutter.dev
dart --version
```

This course was written and verified against **Dart SDK 3.10.8 (stable)**, installed as part of an existing Flutter SDK installation in this environment. Every example in this course was actually compiled/run and its real output verified — no exceptions, unlike this repository's Swift course (see that course's honesty notice).

## How to Run the Examples

Every lesson folder has a `README.md` and a runnable `example.dart` (Lessons 05, 06, and 07 additionally have `Exercises`/`Solutions` pairs; Lessons 16 and 18 use a full `pubspec.yaml`-based project layout for their external package dependencies). From the repository root:

```bash
cd 01-Languages/Dart/03-Variables-and-Data-Types
dart run example.dart
```

Lessons 16 (`sqlite3` package) and 18 (`test` package) require `dart pub get` first to resolve their dependencies (documented in each lesson's own README). Lessons 20-22 extend the same pattern: [20-Exercises](20-Exercises/README.md) is course-spanning practice problems (no dependencies), [21-Solutions](21-Solutions/README.md) their standalone `dart run`-able solutions, and [22-Mini-Projects](22-Mini-Projects/README.md) a full CLI Task Tracker combining `sqlite3` persistence with a `test`-package suite, requiring `dart pub get` from inside `22-Mini-Projects/task_tracker/`.

## Common Beginner Mistakes

- **Assuming `List`/`Map`/`Set` compare by content with `==`** — verified live in Lesson 19 that Dart's default collection equality is identity-based, a genuine, common surprise.
- **Force-unwrapping (`!`) without certainty** — verified live to throw a genuine, if less severe than Swift's, runtime exception ("Null check operator used on a null value") if wrong (Lessons 03, 09, 19).
- **Assuming `switch` falls through** out of C/Java/JavaScript habit — verified live that Dart's `switch` does not fall through by default, matching Go/Swift (Lesson 05).
- **Running heavy synchronous computation on the main isolate** — verified live with a real, ticking timer to completely block the event loop; `Isolate.spawn` (or Flutter's `compute()`) is the fix (Lessons 14, 19).

## Best Practices

- Prefer non-nullable types by default; use `guard`-style early `null` checks and clear, specific errors over `!`.
- Use `package:collection`'s equality helpers (or a manual comparison) whenever genuine content-based collection equality is needed.
- Offload genuinely CPU-intensive work to a separate `Isolate` rather than running it on the main isolate's event loop.
- Use `Codable`-style `fromJson`/`toJson` factory constructors paired with `dart:convert` for JSON serialization.

## Interview Questions

1. **How does Dart achieve parallelism, and why is this genuinely different from Kotlin/Java/Rust's concurrency models, all covered elsewhere in this repository?**
   Dart uses `Isolate`s — independent execution contexts with their own memory heap and event loop, communicating exclusively via message passing, with **no shared memory at all**. This was verified live in Lesson 14/19: a spawned isolate computing a value and sending it back via a port, and a real, ticking timer proving the main isolate's event loop stays responsive while heavy work runs in a separate isolate (versus being completely blocked when that same work runs synchronously on the main isolate). This eliminates data races as a category of bug entirely, a genuinely different trade-off from Kotlin/Java's shared-memory threads or Rust's `Arc<Mutex<T>>`.

2. **Why did `[1, 2, 3] == [1, 2, 3]` evaluate to `false` in this course's testing, and what should be used instead for content equality?**
   Dart's `List` does not override `==` for content-based comparison by default — its inherited `==` compares object identity, so two separately-constructed lists with identical elements are considered unequal, verified directly in Lesson 19. `package:collection`'s `ListEquality` (or a manual element-by-element comparison) provides genuine content equality — a real, common gotcha in practical Dart code, especially when comparing data structures in tests or application state.

3. **Are Dart's generics reified or erased at runtime, and how does this compare to Java, covered elsewhere in this repository?**
   Reified — verified live in Lesson 13: `<int>[1, 2, 3] is List<int>` returns `true` and `is List<String>` returns `false`, with `.runtimeType` printing the actual type argument (`List<int>`). This is a genuine, checked difference from Java's type-erasure-based generics (covered in this repository's Java course), where the equivalent `instanceof` check against a parameterized type is a compile error, since the type argument simply doesn't exist at runtime there at all.

## Table of Contents

| # | Lesson | Covers |
|---|--------|--------|
| 01 | [Setup](01-Setup/README.md) | Dart VM (JIT) vs. AOT compilation, `dart run` |
| 02 | [Syntax](02-Syntax/README.md) | Required `void main()`, `var`/`final`/`const`, mandatory semicolons |
| 03 | [Variables and Data Types](03-Variables-and-Data-Types/README.md) | Sound null safety, `?.`/`??`/`??=`/`!`, `late` |
| 04 | [Operators](04-Operators/README.md) | `~/` integer division, the cascade operator (`..`) |
| 05 | [Control Flow](05-Control-Flow/README.md) | `switch` (no fall-through), Dart 3 switch expressions/patterns |
| 06 | [Functions](06-Functions/README.md) | Named/optional-positional parameters, mutable closures |
| 07 | [Collections](07-Collections/README.md) | Collection-if/collection-for, `List.unmodifiable()` |
| 08 | [Strings](08-Strings/README.md) | UTF-16-code-unit `.length` (matching Java/JS, not Swift) |
| 09 | [Error Handling](09-Error-Handling/README.md) | `try`/`catch`/`on`/`rethrow`; any object can be thrown |
| 10 | [File Handling](10-File-Handling/README.md) | `dart:io` File; `dart:convert` — built-in JSON |
| 11 | [OOP](11-OOP/README.md) | Mixins (`with`); named/factory constructors; `fromJson`/`toJson` |
| 12 | [Functional Concepts](12-Functional-Concepts/README.md) | Extension methods; `typedef`; function composition |
| 13 | [Generics](13-Generics/README.md) | Reified generics (verified live), bounded type parameters |
| 14 | [Async and Concurrency](14-Async-and-Concurrency/README.md) | Native `Future`/`async`/`await`; `Stream`; `Isolate`s |
| 15 | [Modules and Packages](15-Modules-and-Packages/README.md) | File-level (not class-level) privacy; `pubspec.yaml` |
| 16 | [Database Access](16-Database-Access/README.md) | No built-in DB access (like Swift/C++); `sqlite3` package |
| 17 | [API Integration](17-API-Integration/README.md) | Built-in `dart:io HttpClient`; no exception on 404 |
| 18 | [Testing](18-Testing/README.md) | The official `test` package |
| 19 | [Best Practices](19-Best-Practices/README.md) | Identity-vs-content equality, force-unwrap, event-loop blocking — reproduced live |
| 20 | [Exercises](20-Exercises/README.md) | 8 standalone problems: null safety, cascades, mixins, extension methods, reified generics, `Future`/`Stream` |
| 21 | [Solutions](21-Solutions/README.md) | Runnable solutions to all 8 exercises, each with real `dart run` output |
| 22 | [Mini Projects](22-Mini-Projects/README.md) | CLI Task Tracker — full CRUD over `sqlite3`, `pubspec.yaml`-based package layout, 10-case `test` suite |

Also see: [CHEAT-SHEET.md](CHEAT-SHEET.md).

## Suggested Path

Work through 01 → 19 in order, then 20 → 22 as a capstone. Lessons 05, 06, and 07 have `Exercises`/`Solutions` pairs; 20-22 provide a second, course-spanning round of practice problems, solutions, and a full mini-project. Given this repository's existing Kotlin and Swift courses, Dart is best read with both open alongside it — several lessons draw direct, three-way comparisons (null safety, closures, async/concurrency) most useful when those baselines are fresh in mind.

**Previous language:** [Swift](../Swift/README.md) | **This is the last language in the specified build order.**
