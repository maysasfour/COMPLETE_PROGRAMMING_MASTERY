# 01 — Setup

[Back to course overview](../README.md)

## Learning Objectives

- Understand Kotlin as a statically-typed language targeting the JVM (primarily), fully interoperable with Java.
- Compile and run a single Kotlin file with `kotlinc`.

## Prerequisites

None — this is the first Kotlin lesson. Familiarity with Java (covered earlier in this repository) is helpful but not required; Kotlin is deliberately designed to interoperate seamlessly with existing Java code and libraries.

## Concept

Kotlin is a statically-typed language developed by JetBrains, officially supported by Google for Android development, and increasingly used for backend services (Ktor, Spring with Kotlin support). It compiles primarily to JVM bytecode — meaning it runs on the same runtime as this repository's Java course, can call Java libraries directly, and can be called from Java code — while offering a substantially more modern, concise syntax with null safety built directly into its type system (Lesson 03).

## Installing Kotlin

```bash
# Download the standalone compiler from https://github.com/JetBrains/kotlin/releases
# (requires a JDK; this course uses JDK 25 already present for the Java course)
kotlinc -version
```

This course was written and verified against **Kotlin 2.4.10**, running on **JDK 25 (Eclipse Temurin)**. Note: Kotlin 2.1.0 (an earlier stable release) failed to even start on JDK 25 in this environment, throwing `IllegalArgumentException: 25.0.3` from its bundled JDK-version-string parser — a real, reproduced compiler/JDK compatibility issue, fixed simply by using the newer 2.4.10 release instead.

## Compiling and Running a Kotlin File

```bash
kotlinc Example.kt -include-runtime -d Example.jar
java -jar Example.jar
```

`-include-runtime` bundles the Kotlin standard library into the output JAR, making it runnable with a plain `java -jar` (without it, the Kotlin runtime JAR would need to be on the classpath separately).

## Detailed Example

See [Example.kt](Example.kt) — prints a greeting and the running Kotlin version via the built-in `KotlinVersion.CURRENT` property.

## Expected Output

Running the compiled JAR prints a greeting, `Kotlin version: 2.4.10` (or whatever version is installed), and a note about running on the JVM.

## Common Mistakes

- Assuming any Kotlin compiler version works with any JDK version — verified directly in this lesson: Kotlin 2.1.0 failed outright on JDK 25 due to a version-string-parsing bug in its bundled tooling, fixed by using a newer Kotlin release (2.4.10).
- Forgetting `-include-runtime` when compiling to a JAR meant to run standalone with `java -jar` — without it, a `NoClassDefFoundError` for Kotlin standard library classes results.

## Best Practices

- Keep the Kotlin compiler reasonably up to date, especially when using a recent JDK — older Kotlin releases may not recognize newer JDK version strings, as reproduced in this lesson.
- Use a build tool (Gradle, with the Kotlin DSL) for any real project — `kotlinc` directly is fine for single-file lessons like this course's, but Gradle handles dependency management, multi-file compilation, and packaging far more practically for real applications.

## Real-World Usage

Kotlin is Google's officially preferred language for Android development, and is increasingly adopted for backend services (Ktor is a Kotlin-native web framework; Spring Boot has first-class Kotlin support) specifically because of its JVM interoperability — an organization with an existing Java codebase can adopt Kotlin incrementally, file by file, since both languages compile to the same bytecode and can call each other directly.

## Summary

- Kotlin compiles to JVM bytecode, runs alongside Java, and interoperates with it directly.
- `kotlinc file.kt -include-runtime -d file.jar` followed by `java -jar file.jar` compiles and runs a Kotlin program.
- Compiler/JDK version compatibility is a real, practical concern — verified directly in this lesson.

## Key Terms

- **JVM interoperability** — Kotlin's ability to call Java code directly and be called from Java code, since both compile to the same bytecode format.
- **`kotlinc`** — the standalone Kotlin compiler command-line tool.

## Interview Questions

1. **Why might an organization choose to adopt Kotlin incrementally in an existing Java codebase, rather than rewriting everything at once?**
   Because Kotlin compiles to the same JVM bytecode as Java and is fully interoperable with it in both directions — a Kotlin file can call existing Java classes directly, and Java code can call Kotlin classes just as easily, since Kotlin's compiled output looks like ordinary JVM bytecode from the outside. This allows a team to introduce Kotlin file-by-file or module-by-module (new features written in Kotlin, existing Java left as-is) without a disruptive, all-at-once rewrite — a genuinely practical migration path unavailable to languages without this level of interoperability.

2. **What does `-include-runtime` do when compiling a Kotlin file with `kotlinc`, and why does it matter?**
   It bundles the Kotlin standard library (containing core runtime classes Kotlin-compiled code depends on) directly into the output JAR file, making that JAR runnable standalone with a plain `java -jar file.jar` command. Without this flag, the resulting JAR would be missing those runtime classes, and running it would fail with a `NoClassDefFoundError`, since the Kotlin standard library JAR would need to be added separately to the Java classpath instead.

## Recommended Next Lesson

[02 — Syntax](../02-Syntax/README.md)
