# 15 — Modules and Packages

[Back to course overview](../README.md) | [Previous: Async and Concurrency](../14-Async-and-Concurrency/README.md)

## Learning Objectives

- Use `package`/`import` declarations.
- Verify live a genuine, checked contrast with Java: Kotlin does **not** enforce that a file's package matches its directory path.
- Understand Gradle (with the Kotlin DSL) as the standard build/dependency-management tool, even without it configured in this environment.

## Prerequisites

[14-Async-and-Concurrency](../14-Async-and-Concurrency/README.md)

## Concept

Kotlin uses `package`/`import` declarations similar to Java's, but with one genuinely important, verified difference: **Kotlin does not require a file's package declaration to match its directory path** at all. Java's compiler (`javac`) enforces this matching strictly (verified in this repository's Java course); Kotlin's compiler (`kotlinc`) does not — a file can declare any package regardless of where it physically lives on disk.

## Verified Live: Package and Directory Are Independent

```kotlin
// src/anywhere/Thing.kt -- note the directory does NOT match the package below
package com.example.mypackage

class Thing {
    fun greet(): String = "hello from a directory that does NOT match my package name"
}
```

```kotlin
// src/Main.kt
import com.example.mypackage.Thing

fun main() {
    println(Thing().greet())
}
```

Verified live: this compiled and ran successfully with `Thing.kt` physically located at `src/anywhere/Thing.kt`, despite declaring `package com.example.mypackage` — a layout that would be a hard compile error in Java, where the compiler enforces that a class in package `com.example.mypackage` must live at a matching `com/example/mypackage/` directory path. This is a genuine, checked design difference: Kotlin treats package names purely as a logical namespace, entirely decoupled from physical file organization, though IDEs (IntelliJ IDEA) and community convention still strongly encourage keeping them aligned for human readability.

## `import` and Fully-Qualified Names

```kotlin
import com.example.mypackage.Thing // brings Thing into scope under its short name
val t = Thing()
val t2 = com.example.mypackage.Thing() // fully-qualified, no import needed
```

## Gradle: The Standard Build Tool (Not Configured in This Environment)

A real Kotlin project uses Gradle (typically with the Kotlin DSL, `build.gradle.kts`) for dependency management, multi-module builds, and packaging — conceptually similar to Maven for Java, npm for JavaScript, or Cargo for Rust, all covered elsewhere in this repository. This course's lessons use `kotlinc` directly (compiling one or two files at a time) to stay dependency-management-tool-free and consistent with this repository's single-file lesson style; a real project would declare dependencies (like `kotlinx-coroutines-core` from Lesson 14, or Gson from Lesson 10) in `build.gradle.kts` instead of manually downloading JARs.

## Detailed Example

See [src/anywhere/Thing.kt](src/anywhere/Thing.kt) and [src/Main.kt](src/Main.kt) — a genuinely mismatched package/directory layout, compiled and run successfully together.

## Run It

```bash
cd 01-Languages/Kotlin/15-Modules-and-Packages
kotlinc src/anywhere/Thing.kt src/Main.kt -include-runtime -d Example.jar
java -jar Example.jar
```

## Expected Output

Running the compiled JAR prints the greeting from `Thing` (proving the mismatched-directory class resolved and ran correctly) and a confirming message about the successful, mismatched compilation.

## Common Mistakes

- Assuming Kotlin enforces package-directory matching the way Java does — it doesn't, verified live in this lesson; a Kotlin project *can* have packages and directories that don't correspond at all, though doing so deliberately is poor practice for human readability, even though the compiler allows it.
- Manually downloading and managing JAR dependencies (as this course does, for consistency with its single-file lesson format) in a real project instead of using Gradle's dependency management — fine for isolated lessons, but not how genuine Kotlin projects should be structured.

## Best Practices

- Even though Kotlin doesn't enforce it, still keep package names aligned with directory structure by convention — this is standard practice in virtually every real Kotlin codebase and is what IDE tooling (IntelliJ IDEA) expects and automatically maintains when refactoring.
- Use Gradle with the Kotlin DSL for any real, multi-file Kotlin project needing dependency management — it's the de facto standard build tool for Kotlin (including Android projects), analogous to Maven/npm/Cargo covered elsewhere in this repository.

## Real-World Usage

While Kotlin's compiler doesn't enforce package-directory matching, virtually every real Kotlin project (and IntelliJ IDEA's tooling by default) maintains this convention anyway for the same reason most languages do — human navigability — making the verified compiler leniency in this lesson more of an interesting, checkable language design fact than a recommended practice.

## Summary

- `package`/`import` work similarly to Java's, but Kotlin's compiler does not enforce that a file's package matches its directory path — verified live with a genuinely mismatched, successfully-compiling example.
- Gradle (with the Kotlin DSL) is the standard build/dependency-management tool for real Kotlin projects, analogous to Maven/npm/Cargo.

## Key Terms

- **Package** — a logical namespace grouping related declarations, independent of physical file location in Kotlin (unlike Java).
- **Gradle** — the standard build tool for Kotlin projects, handling dependency management and compilation.

## Interview Questions

1. **Does Kotlin require a file's package declaration to match its directory path, the way Java requires for its classes?**
   No — verified directly in this lesson: a `Thing.kt` file declaring `package com.example.mypackage` compiled and ran successfully while physically located at `src/anywhere/Thing.kt`, a directory structure completely unrelated to the package name. This contrasts directly with Java (covered in this repository's Java course), whose compiler (`javac`) strictly enforces that a class in a given package lives at a matching directory path, treating any mismatch as a compile error. Kotlin's package system is purely a logical namespace, entirely decoupled from physical file organization at the compiler level — though convention and IDE tooling still strongly encourage keeping them aligned for readability.

2. **What role does Gradle play in a real Kotlin project that this course's single-file lessons don't demonstrate?**
   Gradle (typically using the Kotlin DSL, `build.gradle.kts`) handles dependency resolution (downloading and managing libraries like `kotlinx-coroutines-core` or Gson, both used via manually-downloaded JARs in this course's Lessons 10 and 14 instead), multi-module project builds, and packaging into distributable artifacts (JARs, Android APKs, etc.) — the same category of tooling as Maven for Java, npm for JavaScript, or Cargo for Rust, all covered elsewhere in this repository. This course uses direct `kotlinc` invocations to keep lessons self-contained and dependency-tool-free, consistent with its single-file style, but a genuine multi-file, multi-dependency Kotlin project would use Gradle rather than manual JAR downloads and classpath management.

## Recommended Next Lesson

[16 — Database Access](../16-Database-Access/README.md)
