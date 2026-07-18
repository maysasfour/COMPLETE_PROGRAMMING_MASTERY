# Swift

[Back to Languages overview](../README.md) | [Back to repo root](../../README.md)

> ## ⚠️ Honesty Notice: This Course Was Not Verified by Execution
>
> Every other language course in this repository (Python through Kotlin) had every single example actually compiled/run and its real output verified. **This Swift course is a deliberate, disclosed exception.** Swift's official Windows toolchain ships only as a large (~570MB), system-wide InstallShield installer — unlike the self-contained zip/archive toolchains used for Go, Rust, PHP, and Kotlin, all of which install cleanly into an isolated, scratchpad-local directory with no lasting footprint on the host machine. Installing Swift would have meant a persistent, hard-to-reverse, machine-wide change (Program Files, registry entries, likely requiring admin elevation) with no way to first confirm silent/unattended install support in this non-interactive environment. When faced with this trade-off, the user explicitly chose to have this course written from documented Swift language knowledge rather than skip Swift or install it system-wide.
>
> **What this means practically:** every code example in this course is believed correct based on careful reasoning about documented Swift semantics, but **none of it has been compiled or run**. Every other course in this repository caught and fixed real bugs, real compiler errors, and real behavioral surprises specifically *because* the examples were executed — this course has not had that benefit. If you have access to a working Swift toolchain (macOS with Xcode, a Linux machine, or a working Windows install), please compile and run these examples yourself, and treat any discrepancy between documented and actual output as this course's error, not the language's.
>
> **Update — lessons 20–22 are the one exception.** In a later session, a working Swift 6.1.2 toolchain (`x86_64-unknown-windows-msvc`) turned out to already be installed in this environment — it just needed Visual Studio's `vcvarsall.bat x64` run first so `swiftc` could find the Windows SDK's C headers and `link.exe`. [20-Exercises](20-Exercises/README.md)/[21-Solutions](21-Solutions/README.md)/[22-Mini-Projects](22-Mini-Projects/README.md) were built against that real toolchain — every solution file and the mini-project's CLI and test suite were **genuinely compiled and run**, with real captured output (see those folders' own notices for the full story). Lessons 01–19 above remain exactly as originally written and still carry the full unverified disclosure — re-verifying them against this same now-available toolchain remains valuable, not-yet-done follow-up work.

## What Swift Is

Swift is a statically-typed, compiled language developed by Apple, first released in 2014, and is the primary language for iOS/macOS/watchOS/tvOS development. It compiles to native machine code via LLVM (like Rust and C++, both covered earlier in this repository), rather than to a VM bytecode format (like Kotlin/Java). Swift has been open-source since 2015 with an official toolchain supporting Linux and Windows in addition to Apple's own platforms.

## Why / Where It's Used

- **iOS/macOS/watchOS/tvOS app development** — Swift's primary and dominant use case, via Xcode and Apple's SDKs (UIKit, SwiftUI).
- **Server-side Swift** — Vapor is a popular Swift web framework, enabled by Swift's official Linux support.
- **Systems and command-line tooling** — Swift's LLVM-based native compilation makes it viable for performance-sensitive command-line tools, similar in spirit to Rust/C++'s use cases covered earlier in this repository.

## Advantages

- Optionals (`T?`) bake null safety into the type system, directly comparable to Kotlin's nullable types (covered in this repository's Kotlin course) — verified as a real, compiler-enforced feature based on documented Swift semantics.
- `struct` (value type) as the idiomatic default, contrasted with Kotlin/Java where every user-defined type is a reference-type class — a genuine design choice eliminating an entire class of aliasing bugs.
- Native `async`/`await` and `actor` — built directly into the language and standard library since Swift 5.5, unlike Kotlin's `kotlinx.coroutines` (a separate library) or Rust's `tokio` (a separate crate), both covered earlier in this repository.
- Genuinely built-in JSON support via `Codable`, unlike Java, Kotlin, C++, and Rust (all of which needed an external library in their own courses).

## Disadvantages

- Historically Apple-platform-centric tooling and community, even though the language itself is cross-platform — Linux/Windows support, while official, has less mature tooling and a smaller community than macOS/Xcode development.
- ARC (Automatic Reference Counting) requires explicit attention to avoid retain cycles (`[weak self]`) — a genuinely different, more manual memory-safety concern than a tracing garbage collector (Kotlin/Java) or Rust's compile-time-checked ownership system, both covered earlier in this repository.
- **This specific course's examples were not verified by execution** (see the notice above) — a real, disclosed limitation of this particular build, not a property of the language itself.

## How to Install

```bash
# macOS: bundled with Xcode, or `xcode-select --install` for command-line tools
# Linux/Windows: download from https://www.swift.org/install/
swift --version
```

This course was written against **documented Swift 6.x semantics** but was not compiled/tested against any specific installed version — see the honesty notice above.

## How to Run the Examples

Every lesson folder has a `README.md` and an `Example.swift` (or, for Lessons 06/07 with practice exercises, an `Exercises/`/`Solutions/` pair; Lesson 18 uses a full Swift Package Manager layout). From the repository root:

```bash
cd 01-Languages/Swift/03-Variables-and-Data-Types
swiftc Example.swift -o example
./example
```

**These commands have not been run in this environment** — see the honesty notice above.

## Common Beginner Mistakes

- **Force-unwrapping (`!`) without certainty** — crashes the entire program with an unrecoverable fatal error if the value is actually `nil`/an error is actually thrown, a harder failure mode than Kotlin's catchable `!!` (Lessons 03, 09, 19).
- **Defaulting to `class` out of Kotlin/Java habit** — Swift's idiomatic default is `struct`, specifically to avoid the aliasing bugs reference types can introduce (Lessons 07, 11, 19).
- **Forgetting `[weak self]` in a closure stored on `self`** — creates a retain cycle under ARC, a genuinely Swift-specific memory-leak risk with no equivalent in garbage-collected languages (Lessons 12, 19).
- **Assuming `String.count` is O(1)** — Swift's Unicode-correct, grapheme-cluster-based counting is O(n), a deliberate correctness/performance trade-off (Lesson 08).

## Best Practices

- Prefer `guard let`/`if let`/`try` over force-unwrap (`!`)/force-try (`try!`) for any value that could plausibly be `nil` or fail.
- Default to `struct`; reach for `class` deliberately only when reference semantics or inheritance are genuinely needed.
- Use `[weak self]` in any closure stored on `self` (or reachable from it) that also captures `self`.
- Use `Codable` for JSON serialization rather than manual dictionary-based parsing.

## Interview Questions

1. **How does Swift's `Optional` (`T?`) compare to Kotlin's nullable types, both covered in this repository?**
   Both bake null safety directly into the type system — a non-optional/non-nullable type can never hold the absence-of-value case, enforced at compile time. Swift's specific idioms (`guard let`'s mandatory early-exit `else` branch, in particular) are distinctly its own, and Swift's force-unwrap (`!`) crashes the program with an unrecoverable fatal error on a wrong assumption, versus Kotlin's `!!`, which throws a catchable `NullPointerException` instead — a real difference in failure severity between the two languages' otherwise conceptually similar null-safety mechanisms.

2. **Why does Swift recommend `struct` as the default over `class`, unlike Kotlin/Java where every user-defined type is a class?**
   `struct` is a value type — copied on assignment or when passed to a function — while `class` is a reference type, shared across every variable/parameter referring to the same instance. Defaulting to `struct` avoids an entire class of accidental-aliasing bugs where mutating one variable unexpectedly affects another that was assumed to be independent. Kotlin and Java offer no equivalent choice: every user-defined type there is a reference-type class, so this specific design decision (and the safety trade-off it represents) doesn't exist in those languages at all.

3. **What's the practical difference between Swift's `async`/`await` and Kotlin's coroutines, both covered in this repository?**
   Both provide structured, cooperative concurrency with similar surface syntax (`async`, `await`), but Swift's implementation — including `actor` for compiler-enforced, data-race-free mutable state — is built directly into the language and standard library since Swift 5.5, requiring no external dependency. Kotlin's coroutines, by contrast, need the separate `kotlinx.coroutines` library to provide the actual dispatcher/scheduler that runs and resumes `suspend` functions — the `suspend` keyword itself is a language feature, but nothing executes without that library, mirroring how Rust's `async`/`await` similarly needs an external runtime crate (`tokio`).

## Table of Contents

| # | Lesson | Covers |
|---|--------|--------|
| 01 | [Setup](01-Setup/README.md) | LLVM compilation, `swiftc`, the honesty notice |
| 02 | [Syntax](02-Syntax/README.md) | Top-level code, `let`/`var`, string interpolation |
| 03 | [Variables and Data Types](03-Variables-and-Data-Types/README.md) | Optionals (`T?`), `?.`/`??`/`!`, `guard let` |
| 04 | [Operators](04-Operators/README.md) | No implicit numeric conversion, `Equatable`, operator overloading |
| 05 | [Control Flow](05-Control-Flow/README.md) | `switch` (no fall-through), ranges/tuples/`where` pattern matching |
| 06 | [Functions](06-Functions/README.md) | Argument labels vs. parameter names, `inout`, closures |
| 07 | [Collections](07-Collections/README.md) | Value-type `Array`/`Dictionary`/`Set` — no aliasing, unlike Kotlin |
| 08 | [Strings](08-Strings/README.md) | Unicode-correct `String.count` (O(n)), `String.Index` |
| 09 | [Error Handling](09-Error-Handling/README.md) | `Error` protocol, `throws`/`try`/`try?`/`try!` |
| 10 | [File Handling](10-File-Handling/README.md) | `FileManager`; `Codable` — genuinely built-in JSON |
| 11 | [OOP](11-OOP/README.md) | `struct` (value) vs `class` (reference); protocol-oriented programming |
| 12 | [Functional Concepts](12-Functional-Concepts/README.md) | Mutable closure capture; `[weak self]` and retain cycles |
| 13 | [Generics](13-Generics/README.md) | Generic constraints; protocols with associated types |
| 14 | [Async and Concurrency](14-Async-and-Concurrency/README.md) | Native `async`/`await`; `actor` for data-race safety |
| 15 | [Modules and Packages](15-Modules-and-Packages/README.md) | 5 access levels (`public` vs `open`); Swift Package Manager |
| 16 | [Database Access](16-Database-Access/README.md) | No built-in DB access (like C++); raw SQLite3 C API |
| 17 | [API Integration](17-API-Integration/README.md) | `URLSession` with native `async`/`await`; `Codable` |
| 18 | [Testing](18-Testing/README.md) | `XCTest` (built into the toolchain) |
| 19 | [Best Practices](19-Best-Practices/README.md) | Force-unwrap, class-vs-struct aliasing, retain cycles |
| 20 | [Exercises](20-Exercises/README.md) | 7 standalone problems: optionals, struct/class aliasing, protocol extensions, enums, generics, async/actor, Codable |
| 21 | [Solutions](21-Solutions/README.md) | All 7 solved — **genuinely compiled and run**, real captured output |
| 22 | [Mini-Projects](22-Mini-Projects/README.md) | CLI Task Tracker (SQLite via raw C API, XCTest) — **genuinely compiled, run, and tested** |

Also see: [CHEAT-SHEET.md](CHEAT-SHEET.md).

## Suggested Path

Work through 01 → 19 in order. Lessons 05, 06, and 07 have `Exercises`/`Solutions` pairs. Given this repository's existing Kotlin course, Swift is best read with Kotlin open alongside it — several lessons draw a direct comparison (optionals, closures, async/concurrency) that's most useful when the Kotlin baseline is fresh in mind. **Remember: this course was not verified by execution — treat every example as a careful best-effort, not a confirmed-correct reference, until independently checked against a real Swift toolchain.**

**Previous language:** [Kotlin](../Kotlin/README.md) | **Next:** [Dart](../Dart/README.md)
