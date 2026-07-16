# 01 — Setup

[Back to course overview](../README.md)

> **Honesty note (applies to this entire Swift course):** the examples in this course were **not compiled or run** in the environment that built it. Every other language course in this repository (Python through Kotlin) had every example actually executed and its real output verified. Swift's official Windows toolchain ships only as a large (~570MB), system-wide InstallShield installer — unlike the self-contained zip/archive toolchains used for Go, Rust, PHP, and Kotlin, which install cleanly into an isolated, scratchpad-local directory with no lasting footprint. Installing Swift would have meant a persistent, hard-to-reverse, machine-wide change (Program Files, registry entries, likely requiring admin elevation) with no interactive way to confirm silent-install support first. Given that trade-off, this course was written carefully from documented Swift language semantics, but **no code in it has been compiled or run** — treat it as a solid reference to learn from and adapt, not as verified-correct the way every other course in this repository is. If you have a working Swift toolchain (macOS/Xcode, Linux, or a working Windows install), please compile and run these examples yourself and treat any discrepancy as this course's error, not the language's.

## Learning Objectives

- Understand Swift as a compiled, statically-typed language developed by Apple, primarily for iOS/macOS/watchOS/tvOS development but also officially supported on Linux and Windows.
- Compile and run a single Swift file with `swiftc`.

## Prerequisites

None — this is the first Swift lesson.

## Concept

Swift is a statically-typed, compiled language developed by Apple, first released in 2014 as a modern replacement for Objective-C. It compiles to native machine code via LLVM (the same compiler infrastructure Rust uses, covered earlier in this repository) — genuinely different from Kotlin/Java's JVM-bytecode model just covered. While Swift's primary home is Apple's own platforms (iOS, macOS, watchOS, tvOS) via Xcode, an official open-source toolchain (swift.org) also supports Linux and Windows.

## Installing Swift

```bash
# macOS: bundled with Xcode, or via `xcode-select --install` for command-line tools
# Linux/Windows: download from https://www.swift.org/install/
swift --version
```

This course targets **Swift 6.x** (the current major version at time of writing), but the language fundamentals covered in lessons 01–13 have been stable since Swift 5, so most examples apply broadly across recent Swift versions.

## Compiling and Running a Swift File

```bash
swiftc Example.swift -o example
./example
```

`swiftc` is Swift's standalone compiler, analogous to `rustc` (Rust) or `kotlinc` (Kotlin) covered earlier in this repository. `swift Example.swift` (without a separate `swiftc` step) also works for quick, single-file scripting, interpreting the file directly without producing a standalone binary.

## Detailed Example

See [Example.swift](Example.swift) — prints a greeting and a note about compiling this course's examples locally.

## Expected Output

Running the compiled binary (or `swift Example.swift` directly) should print a greeting and two informational lines. **This has not been verified by actual execution in this course** — see the honesty note at the top of this lesson.

## Common Mistakes

- Assuming Swift is Apple-platform-only — it isn't; an official, open-source toolchain supports Linux and Windows too, though tooling maturity and community usage skew heavily toward Apple platforms in practice.
- Assuming `swift file.swift` and `swiftc file.swift -o binary && ./binary` behave identically in every respect — the former interprets/JIT-compiles for quick scripting, the latter produces an optimized, standalone native binary; behavior should be equivalent for correct code, but compile-time diagnostics and performance characteristics can differ.

## Best Practices

- Use Xcode's integrated tooling on macOS for real iOS/macOS app development; use `swiftc`/`swift` directly (as this course does) for command-line scripting, learning, and cross-platform (Linux/Windows) Swift work.
- Keep the Swift toolchain reasonably current, especially for Linux/Windows targets, since cross-platform tooling maturity improves with each release.

## Real-World Usage

Swift is the dominant language for iOS and macOS app development, has been open-source since 2015, and is increasingly used server-side (Vapor is a popular Swift web framework) — its Linux/Windows support specifically enables server-side Swift deployment outside Apple's own ecosystem.

## Summary

- Swift is a compiled, statically-typed language from Apple, using LLVM (like Rust) rather than a VM (like Kotlin/Java).
- `swiftc file.swift -o binary` compiles; `swift file.swift` interprets directly for quick scripts.
- This course's examples are documented but **not verified by execution** — a disclosed, deliberate exception to this repository's normal practice, due to Swift's Windows toolchain requiring a system-wide installer this session declined to run.

## Key Terms

- **LLVM** — the compiler infrastructure Swift (and Rust, covered earlier in this repository) compiles through to produce native machine code.
- **`swiftc`** — Swift's standalone command-line compiler.

## Interview Questions

1. **Is Swift limited to Apple platforms?**
   No — while Swift's primary use case and most mature tooling (Xcode, SwiftUI, UIKit) are Apple-platform-specific, Swift itself has been open-source since 2015 and has an official toolchain supporting Linux and Windows, enabling server-side Swift (via frameworks like Vapor) and cross-platform command-line tools.

2. **How does Swift's compilation model differ from Kotlin's, given both are statically-typed languages covered in this repository?**
   Swift compiles to native machine code via LLVM, producing a standalone binary with no runtime/VM dependency (similar to Rust and C++, both covered earlier in this repository). Kotlin compiles to JVM bytecode, requiring a JVM to execute (`java -jar`) — a fundamentally different deployment and execution model, even though both languages are statically typed and share several modern language design ideas (null safety, data-like classes, extension functions).

## Recommended Next Lesson

[02 — Syntax](../02-Syntax/README.md)
