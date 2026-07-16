# 01 — Setup

[Back to course overview](../README.md)

## Learning Objectives

- Understand Dart as a statically-typed language developed by Google, primarily known as Flutter's language for cross-platform mobile/desktop/web app development.
- Run a Dart file directly with `dart run`.

## Prerequisites

None — this is the first Dart lesson.

## Concept

Dart is a statically-typed, class-based language developed by Google, first released in 2011 but reaching its current, widely-adopted form largely through Flutter (Google's UI toolkit for building natively-compiled mobile, web, and desktop applications from a single codebase). Dart supports multiple compilation targets: the Dart VM (`dart run`, used for quick scripting and development, with JIT compilation), ahead-of-time (AOT) compilation to native machine code (`dart compile exe`, and what Flutter uses for release mobile/desktop builds), and compilation to JavaScript (`dart compile js`, for web deployment).

## Installing Dart

```bash
# Standalone Dart SDK: https://dart.dev/get-dart
# Or via the Flutter SDK (which bundles Dart): https://flutter.dev
dart --version
```

This course was written and verified against **Dart SDK 3.10.8 (stable)**, installed as part of a Flutter SDK installation already present in this environment.

## Running a Dart File

```bash
dart run example.dart
```

`dart run` uses the Dart VM directly (JIT-compiled), ideal for development and quick scripts — no separate build step required, similar to this repository's Python/JavaScript/PHP courses' development loop. For a standalone, distributable native binary, `dart compile exe example.dart -o example` produces one via AOT compilation.

## Detailed Example

See [example.dart](example.dart) — prints a greeting and two informational lines about Dart's execution model.

## Expected Output

Running `dart run example.dart` prints a greeting and two informational lines, confirmed by actually running it in this environment.

## Common Mistakes

- Assuming Dart is only usable through Flutter — it's a general-purpose language with its own standalone CLI tooling (`dart run`, `dart compile`), even though Flutter is by far its most common real-world application.
- Forgetting `void main()` is required as the entry point — unlike Kotlin/Swift (covered earlier in this repository), which allow top-level executable statements directly, Dart requires an explicit `main()` function.

## Best Practices

- Use `dart run` for development and quick scripts; use `dart compile exe`/`dart compile js` for distributable, production artifacts.
- Keep the Dart SDK reasonably current, especially since Flutter releases are tightly coupled to specific Dart SDK versions.

## Real-World Usage

Dart's primary real-world use is as Flutter's language — a huge and growing share of cross-platform mobile apps (and an increasing number of desktop and web apps) are built with Flutter/Dart, specifically because Dart's AOT compilation produces genuinely native-performance apps from a single codebase targeting iOS, Android, web, Windows, macOS, and Linux simultaneously.

## Summary

- Dart is Google's statically-typed language, most commonly known as Flutter's language for cross-platform app development.
- `dart run file.dart` runs a script via the Dart VM (JIT); `dart compile exe`/`dart compile js` produce standalone native/web artifacts (AOT).
- `void main()` is Dart's required entry point, unlike Kotlin/Swift's top-level-statement flexibility.

## Key Terms

- **Dart VM** — the runtime executing Dart code via JIT compilation, used by `dart run` for development.
- **AOT (ahead-of-time) compilation** — compiling Dart directly to native machine code, used for Flutter release builds and `dart compile exe`.

## Interview Questions

1. **What is Dart's relationship to Flutter, and is Dart only usable through Flutter?**
   Dart is a general-purpose, statically-typed programming language developed by Google, with its own standalone SDK, CLI tooling (`dart run`, `dart compile`), and package ecosystem (pub.dev) independent of Flutter. Flutter is a separate UI toolkit, also from Google, that happens to use Dart as its programming language — Flutter's cross-platform, natively-compiled rendering engine and widget system are what Flutter itself provides, while Dart provides the language Flutter apps are written in. Dart can be (and is) used entirely outside Flutter for command-line tools, backend services, and scripting, though Flutter is by far Dart's most common and widely recognized real-world application.

2. **What's the difference between running a Dart file with `dart run` versus compiling it with `dart compile exe`?**
   `dart run` executes a Dart file directly via the Dart VM, using just-in-time (JIT) compilation — ideal for fast development iteration, since there's no separate build step, similar to how `python script.py` or `node script.js` work. `dart compile exe` instead performs ahead-of-time (AOT) compilation, producing a standalone native machine-code binary that runs without the Dart VM/SDK needing to be installed on the target machine — this is the same compilation strategy Flutter uses for release mobile and desktop app builds, prioritizing startup performance and distributability over the fastest possible development iteration loop.

## Recommended Next Lesson

[02 — Syntax](../02-Syntax/README.md)
