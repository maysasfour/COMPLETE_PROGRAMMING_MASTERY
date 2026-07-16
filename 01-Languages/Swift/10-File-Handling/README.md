# 10 — File Handling

[Back to course overview](../README.md) | [Previous: Error Handling](../09-Error-Handling/README.md)

> **Not compiled/run** — see [Lesson 01](../01-Setup/README.md) and the [course README](../README.md) for the disclosed reason.

## Learning Objectives

- Use `FileManager` and `String(contentsOf:encoding:)` for basic file I/O.
- Understand Swift's file I/O is exception-based (`throws`), matching Kotlin/Java, unlike PHP's `false`-returning convention.
- Use `Codable`/`JSONEncoder`/`JSONDecoder` — **built-in** JSON support, a genuine, positive contrast with Java, Kotlin, C++, PHP, and Rust, all of which required an external library for JSON in their own courses.

## Prerequisites

[09-Error-Handling](../09-Error-Handling/README.md)

## Concept

Swift's file I/O (via Foundation's `FileManager` and `String`/`Data` initializers) is `throws`-based (Lesson 09), matching Kotlin and Java's exception-based convention rather than PHP's `false`-returning approach. But the standout feature of this lesson is Swift's **built-in JSON support**: the `Codable` protocol, combined with `JSONEncoder`/`JSONDecoder`, lets any simple struct be encoded to and decoded from JSON automatically, with zero external dependencies — a genuine, positive contrast, since this repository's Java, Kotlin, C++, PHP, and Rust courses **all** needed an external library (Jackson/Gson, Gson, nlohmann/json, none built-in, and `serde`/`serde_json`, respectively) for the exact same task.

## File I/O via `FileManager` and `String`

```swift
let fileManager = FileManager.default
let fileURL = tempDir.appendingPathComponent("notes.txt")

try! "line one\nline two\n".write(to: fileURL, atomically: true, encoding: .utf8)
let contents = try! String(contentsOf: fileURL, encoding: .utf8)
```

Foundation has no dedicated "append" file API — appending means reading the current contents, concatenating the new text, and rewriting the whole file (`contents + "line three\n"`, then writing it back), a genuinely more manual process than several other languages' dedicated `appendText`/`FILE_APPEND` conveniences covered elsewhere in this repository.

## Missing Files: Exceptions, Matching Kotlin/Java

```swift
do {
    _ = try String(contentsOf: missingURL, encoding: .utf8)
} catch {
    print("caught: \(error.localizedDescription)")
}
```

## Built-In JSON: `Codable`, `JSONEncoder`, `JSONDecoder`

```swift
struct Person: Codable { // Codable = Encodable + Decodable, both synthesized automatically
    let name: String
    let age: Int
    let active: Bool
}

let jsonData = try! JSONEncoder().encode(Person(name: "Ada", age: 30, active: true))
let decoded = try! JSONDecoder().decode(Person.self, from: jsonData)
```

Declaring a struct's conformance to `Codable` (a combination of `Encodable` and `Decodable`) is enough for the Swift compiler to **automatically synthesize** JSON encoding/decoding logic for it — no manual mapping code, no external library, and no build-time code generation step required. This is a genuinely stronger, more convenient built-in JSON story than any other language covered in this repository provides out of the box.

## Detailed Example

See [Example.swift](Example.swift) — file writing/reading, the "manual append" pattern, a caught missing-file error, and full `Codable`-based JSON encode/decode round-tripping a `Person` struct.

## Run It

```bash
swiftc Example.swift -o example
./example
```

**Not verified by execution in this course** — see the honesty note above.

## Expected Output

Running the compiled binary should print the written/appended file contents, a caught error message for the missing file, pretty-printed JSON for the `Person` struct, and the decoded `name` field read back correctly.

## Common Mistakes

- Looking for a dedicated Foundation "append" API the way other languages' file I/O provides — Swift/Foundation has none; appending requires reading, concatenating, and rewriting the whole file.
- Forgetting `Codable` requires every stored property's type to *also* be `Codable` (all Swift's basic types are) — a struct containing a non-`Codable` property needs custom `encode(to:)`/`init(from:)` implementations instead of automatic synthesis.
- Assuming JSON support needs a third-party library, out of habit from Java/Kotlin/C++/PHP/Rust (all covered earlier in this repository, all requiring one) — Swift's `Codable` is part of the standard library.

## Best Practices

- Use `Codable` for any struct/class that needs JSON (or Property List) serialization — it's almost always sufficient without any manual encoding/decoding code.
- Prefer `try`/`do`-`catch` (or `try?`) over `try!` for file operations in real code, since missing files/permission errors are common, expected failure modes, not provable-impossible edge cases.
- Use `JSONEncoder.outputFormatting = .prettyPrinted` during development/debugging for human-readable JSON output.

## Real-World Usage

`Codable` is one of Swift's most widely used standard library features in real iOS/macOS apps — decoding API responses (from `URLSession`, covered in Lesson 17) directly into typed Swift structs via `JSONDecoder` is the standard, idiomatic pattern, requiring no external dependency at all, in contrast to the JSON-library requirement in most other languages covered in this repository.

## Summary

- Swift's file I/O is exception-based (`throws`), matching Kotlin/Java rather than PHP's `false`-returning convention.
- Foundation has no dedicated append API — appending means read, concatenate, rewrite.
- `Codable`/`JSONEncoder`/`JSONDecoder` provide genuinely built-in, automatically-synthesized JSON support — a positive contrast with Java, Kotlin, C++, PHP, and Rust, all of which needed an external library for the same task in their own courses.

## Key Terms

- **`Codable`** — a Swift standard library protocol (combining `Encodable`/`Decodable`) enabling automatic JSON (or other format) serialization for compatible types.
- **`FileManager`** — Foundation's class for file-system operations (creating directories, checking existence, removing files).

## Interview Questions

1. **Why is Swift's JSON support considered a genuine advantage compared to several other languages covered in this repository?**
   Because `Codable` (Swift's standard library protocol combining `Encodable` and `Decodable`) lets the compiler automatically synthesize JSON encoding/decoding logic for any struct whose properties are themselves `Codable` — no manual mapping code, no external dependency, and no separate build step or compiler plugin required. This repository's Java course needed Jackson or Gson, the Kotlin course used Gson via a downloaded JAR, the C++ course needed nlohmann/json, the PHP course actually did have built-in JSON (a similar positive case), and the Rust course needed the `serde`/`serde_json` crates — Swift's `Codable` matches PHP's built-in convenience while additionally providing full static type safety through the encoding/decoding process, a combination none of the other JSON-library-requiring languages in this repository offer.

2. **Why doesn't Foundation provide a dedicated "append to file" function, and what's the idiomatic alternative?**
   Foundation's `String`/`Data` file-writing APIs are designed around writing a complete file's contents atomically (`write(to:atomically:encoding:)`), rather than incremental append operations. To append, the idiomatic Swift pattern is to read the file's current contents, concatenate the new text in memory, and write the combined result back to the same location — as demonstrated in this lesson. This is a more manual process than some other languages' dedicated append conveniences (PHP's `FILE_APPEND` flag, or a dedicated `appendText`-style function), reflecting Foundation's general design emphasis on atomic, whole-file operations over incremental streaming writes for simple string-based file I/O.

## Recommended Next Lesson

[11 — OOP](../11-OOP/README.md)
