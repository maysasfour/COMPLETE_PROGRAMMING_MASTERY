# 10 — File Handling

[Back to course overview](../README.md) | [Previous: Error Handling](../09-Error-Handling/README.md)

## Learning Objectives

- Use `File.writeText`/`readText`/`appendText`/`forEachLine` — Kotlin's concise extension functions layered over `java.io.File`.
- Understand Kotlin's file I/O is exception-based (like Java), unlike PHP's `false`-returning convention covered earlier in this repository.
- Confirm Kotlin has **no built-in JSON support** — the same gap as Java, since Kotlin adds no JSON capability of its own beyond what the JVM/Java standard library already lacks — requiring a library (Gson, used here, or `kotlinx.serialization`).

## Prerequisites

[09-Error-Handling](../09-Error-Handling/README.md)

## Concept

Kotlin's file I/O is built directly on `java.io.File`, with a set of concise extension functions (`writeText`, `readText`, `appendText`, `forEachLine`, and more) layered on top for a noticeably terser API than raw Java's `FileWriter`/`BufferedReader` boilerplate. Kotlin's error convention here matches Java's — a missing/unreadable file throws an exception — a genuinely different convention from PHP's `false`-returning file I/O covered in this repository's PHP course.

## `File.writeText`/`readText`/`appendText`/`forEachLine`

```kotlin
val file = File(dir, "notes.txt")
file.writeText("line one\nline two\n")
println(file.readText())
file.appendText("line three\n")
file.forEachLine { line -> println(line) } // Kotlin extension, not present in plain Java
```

## Missing Files: Exceptions, Not `false`

```kotlin
try {
    File("does-not-exist.txt").readText()
} catch (e: java.io.FileNotFoundException) {
    println("caught: ${e.message}")
}
```

Verified live: reading a nonexistent file throws `java.io.FileNotFoundException`, matching Java's exception-based convention exactly (since `File.readText()` is a thin wrapper calling into `java.io.File`/`FileInputStream` underneath) — a genuinely different convention from PHP's file I/O (Lesson 10 of that course), which returns `false` with a warning instead of throwing.

## JSON: No Built-In Support, Same Gap as Java

```kotlin
import com.google.gson.Gson

data class Person(val name: String, val age: Int, val active: Boolean)

val gson = Gson()
val json = gson.toJson(Person("Ada", 30, true))         // {"name":"Ada","age":30,"active":true}
val decoded = gson.fromJson(json, Person::class.java)      // Person::class.java -- Kotlin's reflection syntax
```

Kotlin's standard library adds no JSON capability of its own — since it runs on the JVM and Java's standard library has no built-in JSON support either (verified in this repository's Java course), Kotlin inherits exactly the same gap. This lesson uses Gson (downloaded as a JAR, the same pattern as this repository's Java course's JDBC/JUnit dependencies), though `kotlinx.serialization` (a JetBrains-maintained library, requiring a Kotlin compiler plugin) is the more idiomatic modern choice in a real Gradle-managed project.

## Detailed Example

See [Example.kt](Example.kt) — `writeText`/`readText`/`appendText`/`forEachLine`, the live-verified missing-file exception, and Gson-based JSON encode/decode round-tripping a `Person` data class.

## Run It

```bash
cd 01-Languages/Kotlin/10-File-Handling
# Requires gson.jar on the classpath (downloaded separately, not committed to the repo):
kotlinc -cp gson.jar Example.kt -include-runtime -d Example.jar
java -cp "Example.jar;gson.jar" ExampleKt
```

## Expected Output

Running the compiled JAR prints the written/appended file contents, each line read individually via `forEachLine`, a caught `FileNotFoundException` message for the missing file, the Gson-encoded JSON string for a `Person`, and the decoded `name` field read back correctly.

## Common Mistakes

- Assuming Kotlin's file I/O returns `false`/`null` on failure the way PHP's does — it doesn't; Kotlin (via `java.io.File`) throws exceptions, verified live with `FileNotFoundException`.
- Assuming Kotlin has built-in JSON support because it's a "modern" language — it doesn't, for the same underlying reason Java doesn't: neither the JVM nor Kotlin's standard library includes a JSON parser/serializer, requiring a library dependency (Gson, Jackson, or `kotlinx.serialization`).
- Forgetting the JAR containing a required library (Gson here) must be on the classpath both when compiling *and* when running — a `NoClassDefFoundError` at runtime (even after a successful compile) usually means the library JAR is missing from the run-time classpath specifically.

## Best Practices

- Use `kotlinx.serialization` in real, Gradle-managed Kotlin projects (it integrates with Kotlin's compiler via a plugin, generating serialization code at compile time) rather than Gson/Jackson, unless direct interop with existing Java JSON libraries is specifically needed.
- Always wrap file operations that might fail (missing file, permission errors) in `try`/`catch`, since Kotlin's file I/O is exception-based, not `false`-returning.
- Prefer Kotlin's `File` extension functions (`writeText`, `readText`, `forEachLine`) over manually managing `java.io.FileReader`/`BufferedReader` boilerplate, for more concise, idiomatic code.

## Real-World Usage

Gson and Jackson remain common in Kotlin/Java-interop-heavy codebases (especially those migrating from existing Java code), while `kotlinx.serialization` has become the more idiomatic choice for greenfield Kotlin projects specifically because of its compile-time code generation and first-class support for Kotlin-specific features like data classes and nullability.

## Summary

- Kotlin's file I/O extension functions (`writeText`/`readText`/`appendText`/`forEachLine`) sit on top of `java.io.File` and are exception-based, matching Java's convention — genuinely different from PHP's `false`-returning approach.
- Kotlin has no built-in JSON support, the same gap as Java, requiring Gson, Jackson, or `kotlinx.serialization`.

## Key Terms

- **`File.writeText`/`readText`** — Kotlin extension functions providing concise whole-file I/O over `java.io.File`.
- **Gson** — a popular Java/Kotlin JSON library, used here via a directly downloaded JAR.

## Interview Questions

1. **Does Kotlin's file I/O behave like PHP's (returning `false` on failure) or like Java's (throwing exceptions)?**
   Like Java's — verified directly in this lesson: reading a nonexistent file with `File.readText()` throws `java.io.FileNotFoundException`, not a `false`/`null` return value. This makes sense given Kotlin's file I/O extension functions are thin wrappers directly over `java.io.File` and Java's I/O classes, inheriting their exception-based error convention entirely, in contrast to PHP's file functions (covered in this repository's PHP course), which return `false` with a warning by default instead of throwing.

2. **Why does a Kotlin project need an external library like Gson for JSON, when Kotlin is a more "modern" language than Java?**
   Because Kotlin compiles to and runs on the JVM, inheriting Java's standard library — and Java's standard library has never included built-in JSON support (verified in this repository's Java course). Kotlin's own standard library adds no JSON capability of its own either, so the same gap carries over directly. Real Kotlin projects address this with a library — Gson or Jackson (both usable directly via JVM interop, as shown in this lesson) or `kotlinx.serialization` (a more idiomatic, Kotlin-native option using a compiler plugin for code generation) — rather than any built-in language feature.

## Recommended Next Lesson

[11 — OOP](../11-OOP/README.md)
