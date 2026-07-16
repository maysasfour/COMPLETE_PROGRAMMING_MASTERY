# 10 — File Handling

[Back to course overview](../README.md) | [Previous: Error Handling](../09-Error-Handling/README.md)

## Learning Objectives

- Use `dart:io`'s `File` class for synchronous file I/O (`writeAsStringSync`/`readAsStringSync`/`readAsLinesSync`).
- Confirm Dart's file I/O is exception-based, matching Kotlin/Java, unlike PHP's `false`-returning convention.
- Use `dart:convert`'s `jsonEncode`/`jsonDecode` — genuinely built-in JSON support, matching PHP/JavaScript/Python/Swift (all covered elsewhere in this repository), contrasting with Java/Kotlin/C++/Rust, all of which needed an external library.

## Prerequisites

[09-Error-Handling](../09-Error-Handling/README.md)

## Concept

Dart's `dart:io` library (part of the standard SDK, no external package needed) provides both synchronous (`*Sync`) and asynchronous (`Future`-returning) file I/O APIs. This lesson uses the synchronous variants for simplicity; real Dart/Flutter applications commonly prefer the asynchronous versions to avoid blocking the event loop. Dart's file errors are exception-based, matching Kotlin/Java's convention rather than PHP's `false`-returning approach — verified live below.

## File I/O with `dart:io`

```dart
import 'dart:io';

var file = File('notes.txt');
file.writeAsStringSync('line one\nline two\n');
print(file.readAsStringSync());

file.writeAsStringSync('line three\n', mode: FileMode.append); // built-in append mode
var lines = file.readAsLinesSync(); // reads directly into a List<String>, one per line
```

## Missing Files: Exceptions, Matching Kotlin/Java

```dart
try {
  File('does-not-exist.txt').readAsStringSync();
} catch (e) {
  print(e.runtimeType); // PathNotFoundException
}
```

Verified live: reading a nonexistent file throws `PathNotFoundException`, confirmed by catching and inspecting its runtime type — Dart's file I/O is exception-based, the same convention as Kotlin and Java (both covered earlier in this repository), genuinely different from PHP's `false`-returning approach.

## Built-In JSON: `dart:convert`

```dart
import 'dart:convert';

var jsonString = jsonEncode({'name': 'Ada', 'age': 30, 'active': true});
var decoded = jsonDecode(jsonString) as Map<String, dynamic>;
```

Verified live: `jsonEncode`/`jsonDecode` from `dart:convert` (part of the Dart SDK, no `pub` package needed) correctly encode/decode JSON with zero external dependencies — matching this repository's PHP, JavaScript, Python, and Swift courses (all with genuinely built-in JSON support), and contrasting with the Java, Kotlin, C++, and Rust courses, all of which needed an external library for the same task. `jsonDecode` returns `dynamic`-typed data (typically `Map<String, dynamic>` or `List<dynamic>`), requiring explicit casting or a `fromJson` factory constructor (covered further in Lesson 11) for strongly-typed access.

## Detailed Example

See [example.dart](example.dart) — file writing/reading/appending, line-by-line reading, the live-verified missing-file exception, and full JSON encode/decode round-tripping via `dart:convert`.

## Run It

```bash
cd 01-Languages/Dart/10-File-Handling
dart run example.dart
```

## Expected Output

Running `dart run example.dart` prints the written/appended file contents, each line read individually with a 1-indexed line number, a caught `PathNotFoundException` for the missing file, the JSON-encoded `Map`, and the decoded `name` field read back correctly — all confirmed by actual execution, with no leftover scratch files after the script finishes.

## Common Mistakes

- Using the synchronous (`*Sync`) file I/O methods in a real Flutter app's UI-facing code — this can block the UI thread; the asynchronous (`Future`-returning) variants should be preferred there.
- Assuming `jsonDecode`'s result is strongly typed — it returns `dynamic`-typed data (commonly `Map<String, dynamic>`), requiring an explicit cast or a `fromJson` factory constructor for type-safe access (covered further in Lesson 11).
- Forgetting `FileMode.append` when appending — `writeAsStringSync` without it overwrites the file's existing contents entirely.

## Best Practices

- Prefer the asynchronous file I/O APIs (`writeAsString`/`readAsString`, returning `Future`s) in real applications, especially Flutter apps, to avoid blocking the UI thread; reserve synchronous variants for CLI scripts and simple, one-off tooling.
- Use `jsonEncode`/`jsonDecode` directly for simple cases; use `fromJson`/`toJson` factory constructors (Lesson 11) for strongly-typed, validated JSON handling in larger applications.

## Real-World Usage

`dart:convert`'s built-in JSON support is used pervasively in real Dart/Flutter apps for API communication (parsing HTTP response bodies, covered in Lesson 17) — combined with `fromJson`/`toJson` factory constructor conventions (Lesson 11), this forms the standard, idiomatic pattern for typed JSON handling in Flutter apps, requiring no third-party JSON library for the core encode/decode mechanics.

## Summary

- `dart:io`'s `File` class provides both synchronous and asynchronous file I/O, part of the standard SDK.
- Dart's file I/O is exception-based (verified live via `PathNotFoundException`), matching Kotlin/Java rather than PHP's `false`-returning convention.
- `dart:convert`'s `jsonEncode`/`jsonDecode` provide genuinely built-in JSON support, matching PHP/JavaScript/Python/Swift and contrasting with Java/Kotlin/C++/Rust, all covered elsewhere in this repository.

## Key Terms

- **`dart:io`** — Dart's standard library for file, socket, and process I/O (not available in web/browser contexts, only standalone/server/mobile/desktop Dart).
- **`dart:convert`** — Dart's standard library providing built-in JSON (and other format) encoding/decoding.

## Interview Questions

1. **Does Dart have built-in JSON support, and how does this compare to the other languages covered in this repository?**
   Yes — verified directly in this lesson: `dart:convert`'s `jsonEncode`/`jsonDecode` functions are part of the Dart SDK itself, requiring no external `pub` package for basic JSON encoding/decoding. This matches PHP, JavaScript, Python, and Swift (all covered elsewhere in this repository, all with genuinely built-in JSON support) and contrasts with Java, Kotlin, C++, and Rust, all of which required an external library (Jackson/Gson, Gson, nlohmann/json, and `serde`/`serde_json` respectively) for the same capability in their own courses.

2. **Why might a real Flutter app prefer the asynchronous file I/O methods over the synchronous ones used in this lesson's example?**
   Flutter apps run on a single UI thread by default (much like a JavaScript/browser event loop) — a synchronous (`*Sync`) file operation blocks that thread entirely until it completes, potentially causing the UI to freeze or stutter if the operation takes any meaningful time (a slow disk, a large file). The asynchronous variants (`writeAsString`/`readAsString`, returning `Future`s, used with `async`/`await`) instead let the I/O operation run without blocking the UI thread, keeping the app responsive. This lesson used the synchronous variants purely for simplicity in a standalone CLI script — real Flutter application code handling file I/O on the UI-facing path should prefer the asynchronous APIs.

## Recommended Next Lesson

[11 — OOP](../11-OOP/README.md)
