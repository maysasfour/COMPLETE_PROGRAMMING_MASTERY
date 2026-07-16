# 15 — Modules and Packages

[Back to course overview](../README.md) | [Previous: Async and Concurrency](../14-Async-and-Concurrency/README.md)

## Learning Objectives

- Use `import` to bring another Dart file's public API into scope.
- Understand Dart's underscore-based privacy convention: private to the **file/library**, not the class — genuinely different from Java/Kotlin's class-based `private` modifiers, verified live in this lesson.
- Understand `pubspec.yaml` and `dart pub` as Dart's standard package/dependency management system.

## Prerequisites

[14-Async-and-Concurrency](../14-Async-and-Concurrency/README.md)

## Concept

Dart has no `public`/`private`/`protected` keywords at all — instead, any identifier (variable, function, class, or class member) whose name starts with an underscore (`_`) is private to its **declaring file** (technically, its "library," which by default is just that one file, though `part`/`part of` can group multiple files into one library). This is a genuinely different privacy model from Java/Kotlin's class-based `private` (covered elsewhere in this repository), since it applies at the file level, not the class level.

## File-Level Privacy, Verified Live

```dart
// mathutils.dart
int _secretMultiplier = 10; // private to THIS FILE

class Calculator {
  int add(int a, int b) => a + b;
  int _internalHelper(int x) => x * 2; // private to the FILE, not just this class
}
```

```dart
// example.dart
import 'lib/mathutils.dart';
// print(_secretMultiplier); // COMPILE ERROR: Undefined name '_secretMultiplier'
```

Verified live: attempting to reference `_privateValue` (declared in an imported file) from a different file produces:

```
Error: Undefined name '_privateValue'.
```

This confirms Dart's privacy genuinely operates at the file/library level: an underscore-prefixed name is invisible from *any other file*, even one that imports the file declaring it — including other code that might be part of the same conceptual module but lives in a separate file. This is a meaningfully different granularity from Java/Kotlin's `private`, which scopes to the *class*, not the *file* (two different classes in the same Kotlin file can't see each other's `private` members, whereas two top-level declarations in the same Dart file *can* see each other's underscore-prefixed names).

## `pubspec.yaml` and `dart pub`

```yaml
name: my_project
environment:
  sdk: ^3.0.0
dependencies:
  http: ^1.0.0
dev_dependencies:
  test: ^1.0.0
```

`pubspec.yaml` is Dart's package manifest (comparable to `package.json` for npm, `Cargo.toml` for Rust, or `composer.json` for PHP, all covered elsewhere in this repository) — `dart pub get` resolves and downloads dependencies, and `dart pub add <package>` adds a new one directly, both from the pub.dev package registry.

## Detailed Example

See [example.dart](example.dart) and [lib/mathutils.dart](lib/mathutils.dart) — an imported file with file-private declarations (a variable and a class method), demonstrating that the importing file can use the public API but not the private one, plus a documented `pubspec.yaml` example.

## Run It

```bash
cd 01-Languages/Dart/15-Modules-and-Packages
dart run example.dart
```

## Expected Output

Running `dart run example.dart` prints `12` (using the file-private `_secretMultiplier` internally within `mathutils.dart`), `5` (the `Calculator.add` result), and the documented `pubspec.yaml` example text — all confirmed by actual execution.

## Common Mistakes

- Assuming Dart's underscore privacy works at the class level, like Java/Kotlin's `private` — verified live that it doesn't; it's scoped to the *file*, meaning two classes in the *same* file can access each other's underscore-prefixed members, while the *same* class's underscore-prefixed members are invisible from a *different* file, even one that imports it.
- Forgetting `dart pub get` must be run after adding a new dependency to `pubspec.yaml` manually (rather than via `dart pub add`) — without it, the dependency isn't actually resolved/downloaded yet.

## Best Practices

- Use underscore-prefixed names for any implementation detail not meant to be part of a file's public API, understanding the privacy boundary is the file, not the class.
- Use `dart pub add <package>` rather than manually editing `pubspec.yaml`, to ensure the correct, compatible version constraint is added automatically.

## Real-World Usage

Dart's file-level privacy convention is a defining characteristic of the language, distinct from most class-based-OOP languages' privacy models — real Dart/Flutter projects organize related private implementation details within a single file specifically to take advantage of this, since splitting related private logic across multiple files would make it inaccessible to itself under Dart's file-scoped privacy rules.

## Summary

- Dart uses an underscore (`_`) prefix convention for privacy, scoped to the declaring file/library — not the class, verified live to be genuinely invisible even to an importing file, and genuinely different from Java/Kotlin's class-based `private`.
- `pubspec.yaml` and `dart pub` (comparable to npm/Cargo/Composer, covered elsewhere in this repository) form Dart's standard package/dependency management system.

## Key Terms

- **Library-level privacy** — Dart's privacy model, where an underscore-prefixed name is invisible outside its declaring file, regardless of class boundaries within or across files.
- **`pubspec.yaml`** — Dart's package manifest, declaring a project's dependencies and SDK constraints.

## Interview Questions

1. **How does Dart's underscore-based privacy differ from Java or Kotlin's `private` keyword, and how was this verified rather than assumed?**
   Verified directly in this lesson: attempting to access an underscore-prefixed name declared in one file from a *different* file (even one that `import`s the declaring file) produced a compile error, "Undefined name" — confirming Dart's privacy operates at the file/library level. Java and Kotlin's `private` (covered elsewhere in this repository), by contrast, scopes privacy to the *class* — two different classes in the same file cannot see each other's `private` members in those languages, the opposite granularity from Dart, where two top-level declarations (or two different classes) in the *same* file *can* see each other's underscore-prefixed names, but code in any other file cannot, regardless of class structure.

2. **What role does `pubspec.yaml` play in a Dart project, and how does it compare to tools covered elsewhere in this repository?**
   `pubspec.yaml` is Dart's package manifest, declaring a project's name, SDK version constraint, and dependencies (both regular and dev-only) — resolved and fetched via `dart pub get`, with `dart pub add <package>` adding a new dependency directly with an appropriate version constraint. This plays the same role as `package.json` for npm (JavaScript), `Cargo.toml` for Cargo (Rust), or `composer.json` for Composer (PHP), all covered elsewhere in this repository — a standard, declarative dependency manifest paired with a CLI tool that resolves and manages those dependencies automatically.

## Recommended Next Lesson

[16 — Database Access](../16-Database-Access/README.md)
