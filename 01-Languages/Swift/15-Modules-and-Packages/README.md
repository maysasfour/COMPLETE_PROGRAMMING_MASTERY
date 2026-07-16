# 15 — Modules and Packages

[Back to course overview](../README.md) | [Previous: Async and Concurrency](../14-Async-and-Concurrency/README.md)

> **Not compiled/run** — see [Lesson 01](../01-Setup/README.md) and the [course README](../README.md) for the disclosed reason.

## Learning Objectives

- Use Swift's five access control levels (`private`, `fileprivate`, `internal`, `public`, `open`) — a richer system than Kotlin/Java's public/private/protected/internal, covered in this repository's other courses.
- Understand the genuinely distinctive `public`-vs-`open` distinction: `public` allows cross-module visibility but not cross-module subclassing/overriding; `open` allows both.
- Understand Swift Package Manager (SPM) as the standard build/dependency tool, via `Package.swift`.

## Prerequisites

[14-Async-and-Concurrency](../14-Async-and-Concurrency/README.md)

## Concept

Swift's access control system has five distinct levels, more granular than most languages covered in this repository. The most genuinely distinctive part is the split between `public` and `open`: both make a declaration visible outside its defining module, but only `open` additionally permits that declaration to be *subclassed or overridden* from outside its module — `public` alone does not. This gives a module author explicit, fine-grained control over what's merely usable versus what's extensible by consumers of their code.

## The Five Access Levels

```swift
private class ...      // visible only within the enclosing declaration (+ extensions in the same file)
fileprivate class ...  // visible anywhere within the SAME source file
internal class ...      // visible anywhere within the same module -- the DEFAULT if unspecified
public class ...          // visible from OTHER modules, but NOT subclassable/overridable there
open class ...              // visible from OTHER modules, AND subclassable/overridable there
```

```swift
public class PublicWidget {
    public func describe() -> String { return "a public widget" }
    // another module can SEE and USE PublicWidget, but CANNOT subclass it
}

open class OpenWidget {
    open func describe() -> String { return "an open widget" }
    // another module CAN subclass OpenWidget and override describe()
}
```

This `public`/`open` split has no direct equivalent in Kotlin (where `open` controls subclassing *within* a module, covered in this repository's Kotlin course, but doesn't separately gate *cross-module* subclassing the way Swift's does) or Java (where `public` always permits subclassing from anywhere, with no intermediate level). Swift's design lets a library author deliberately choose "consumers can use this, but not extend it" (`public`) versus "consumers can use *and* extend this" (`open`) — a genuinely more precise API design tool.

## Swift Package Manager (SPM)

```swift
// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "MyProject",
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
    ],
    targets: [
        .executableTarget(name: "MyProject", dependencies: ["ArgumentParser"]),
    ]
)
```

SPM is Swift's standard, built-in build tool and package manager (comparable to Cargo for Rust, Gradle for Kotlin, or Composer for PHP, all covered elsewhere in this repository) — `swift build` compiles a package (resolving and fetching dependencies automatically), `swift run` builds and executes, and `swift test` runs a package's test target.

## Detailed Example

See [Example.swift](Example.swift) — all five access levels demonstrated on distinct declarations, plus a `Package.swift` manifest example in comments (SPM manifests are separate files, not embedded in a single-file lesson script).

## Run It

```bash
swiftc Example.swift -o example
./example
```

**Not verified by execution in this course** — see the honesty note above.

## Expected Output

Running the compiled binary (all declarations here are used from within the same file/module, so every access level compiles and runs successfully) should print all four `describe()`/helper results.

## Common Mistakes

- Assuming `public` is Swift's most permissive access level — it isn't; `open` is, since `public` alone still forbids cross-module subclassing/overriding, a distinction with no direct Kotlin/Java equivalent.
- Forgetting `internal` is the *default* access level when none is specified — a declaration with no explicit access modifier is visible throughout its own module, but not from other modules importing it.
- Assuming Swift's access control is simpler than it actually is, out of habit from a 3-4-level system (Java's public/protected/package-private/private, or Kotlin's public/internal/protected/private) — Swift's `open`/`public` split adds a fifth, genuinely distinct level specifically for cross-module extensibility control.

## Best Practices

- Default to `internal` (Swift's own default) for most declarations; use `public`/`open` deliberately, only for a library's genuinely intended external API surface.
- Reserve `open` specifically for classes/methods a library author genuinely wants external consumers to be able to subclass/override — `public` is the safer, more conservative default for cross-module-visible-but-not-extensible API.
- Use SPM (`Package.swift`) for any real, multi-file Swift project needing dependency management, rather than manually managing source files the way this course's single-file lessons do for consistency with the rest of this repository's lesson style.

## Real-World Usage

The `public`/`open` distinction is heavily used in real Swift library design — Apple's own frameworks and popular third-party Swift packages carefully choose between the two to communicate exactly which parts of their API are meant to be extended by consumers versus merely used as-is, a level of API design precision genuinely unique to Swift among the languages covered in this repository.

## Summary

- Swift has five access control levels: `private`, `fileprivate`, `internal` (default), `public`, and `open`.
- `public` allows cross-module visibility but not cross-module subclassing/overriding; only `open` allows both — a genuinely distinctive Swift design feature.
- Swift Package Manager (SPM), configured via `Package.swift`, is the standard build/dependency tool, comparable to Cargo/Gradle/Composer covered elsewhere in this repository.

## Key Terms

- **`open`** — Swift's most permissive access level: visible and subclassable/overridable from other modules.
- **Swift Package Manager (SPM)** — Swift's built-in build tool and package manager, configured via `Package.swift`.

## Interview Questions

1. **What's the difference between `public` and `open` in Swift, and why does this distinction not exist in Kotlin or Java?**
   Both `public` and `open` make a declaration visible to code in other modules, but only `open` additionally permits that declaration to be subclassed (for classes) or overridden (for methods) from *outside* its defining module — `public` alone allows external code to use the declaration, but not extend it. Kotlin's `open` (covered in this repository's Kotlin course) controls whether a class/method can be subclassed/overridden *at all*, but doesn't separately distinguish "usable across modules" from "extensible across modules" the way Swift's `public`/`open` split does — a Kotlin `open` class can be subclassed by any code that can see it, regardless of which module that code lives in. Java's `public` similarly permits subclassing from anywhere with no intermediate level. Swift's more granular system lets a library author deliberately decide whether a type is merely usable or fully extensible by external consumers — a level of API design control unique among these languages.

2. **What role does Swift Package Manager (SPM) play in a Swift project, and how does it compare to tools covered elsewhere in this repository?**
   SPM is Swift's built-in build system and dependency manager, configured through a `Package.swift` manifest file describing a package's name, dependencies (fetched from Git repositories, typically GitHub), and build targets (executables, libraries, test suites). Running `swift build` resolves and builds all dependencies and targets automatically; `swift run` builds and executes; `swift test` runs a package's tests. This plays the same role as Cargo for Rust, Gradle for Kotlin, or Composer for PHP (all covered elsewhere in this repository) — a standard, integrated tool handling dependency resolution and build orchestration, rather than requiring manual classpath/library management the way this course's install-free, single-file lessons demonstrate individual concepts.

## Recommended Next Lesson

[16 — Database Access](../16-Database-Access/README.md)
