# Kotlin

[Back to Languages overview](../README.md) | [Back to repo root](../../README.md)

## What Kotlin Is

Kotlin is a statically-typed language developed by JetBrains, compiling primarily to JVM bytecode (also supporting Kotlin/Native and Kotlin/JS, not covered here). It is officially Google's preferred language for Android development and is increasingly used for backend services. Kotlin is fully interoperable with Java — since this repository already has a full Java course, Kotlin is presented throughout as a direct, concrete point of contrast: same runtime, genuinely different language design choices.

## Why / Where It's Used

- **Android development** — Google's officially preferred language for Android apps since 2019.
- **Backend services** — Ktor (a Kotlin-native web framework) and Spring Boot (with first-class Kotlin support) are both common choices for JVM-based backends.
- **Incremental Java migration** — full JVM interoperability lets teams introduce Kotlin file-by-file in an existing Java codebase.

## Advantages

- Null safety enforced by the type system itself (`String` vs. `String?`), eliminating a large class of `NullPointerException`s at compile time rather than runtime — verified live in Lesson 03.
- More concise syntax than Java: top-level functions, data classes, string templates, `when` expressions, extension functions.
- Coroutines (`suspend`/`kotlinx.coroutines`) provide lightweight, structured concurrency — verified live in Lesson 14 with a genuine ~2x measured speedup for concurrent vs. sequential operations, and a proven structured-concurrency guarantee.
- Declaration-site generic variance (`out`/`in`) is more ergonomic than Java's use-site wildcards, verified live in Lesson 13.

## Disadvantages

- Compile times can be noticeably slower than Java's for large projects, a known, real trade-off of Kotlin's more advanced type inference and analysis.
- The coroutine dispatcher/scheduler is a separate library (`kotlinx.coroutines`), not part of the language itself, mirroring Rust's `async`/`tokio` situation covered elsewhere in this repository — this adds a dependency-management step non-JVM developers might not expect.
- No built-in JSON support, the same gap as Java (verified in Lesson 10), requiring Gson, Jackson, or `kotlinx.serialization`.

## How to Install

```bash
# Download the standalone compiler from https://github.com/JetBrains/kotlin/releases
# (requires a JDK -- this course used JDK 25, already present for the Java course)
kotlinc -version
```

This course was written and verified against **Kotlin 2.4.10**, running on **JDK 25 (Eclipse Temurin)**. A genuine compiler/JDK compatibility issue was found and fixed while setting up this course: Kotlin 2.1.0 (an earlier stable release) failed outright on JDK 25 with `IllegalArgumentException: 25.0.3` from its bundled JDK-version-string parser — resolved simply by using the newer 2.4.10 release instead (documented in Lesson 01).

## How to Run the Examples

Every lesson folder has a `README.md` and a runnable `Example.kt`. From the repository root:

```bash
cd 01-Languages/Kotlin/03-Variables-and-Data-Types
kotlinc Example.kt -include-runtime -d Example.jar
java -jar Example.jar
```

Lessons needing external libraries (10 and 17 use Gson; 14 and 19 use `kotlinx-coroutines-core`; 16 uses the SQLite JDBC driver; 18 uses `kotlin-test`/JUnit 5) document their specific classpath requirements in their own READMEs.

## Common Beginner Mistakes

- **Assuming `==` behaves like Java's `==`** — it's the opposite: Kotlin's `==` is structural (calls `.equals()`) by default, and `===` is referential, verified live in Lesson 04 (including a genuine JVM string-interning surprise where `===` returned `true` for two separately-written string expressions).
- **Overusing `!!`** to silence a nullability compile error without actually confirming the value can't be null — reintroduces the exact `NullPointerException` risk Kotlin's type system is designed to prevent (Lessons 03 and 19).
- **Forgetting `open`/`override` are mandatory** for subclassing/overriding — Kotlin classes and methods are final by default, the opposite of Java's default, verified live in Lesson 11.
- **Calling `Thread.sleep()` inside a `suspend` function** instead of `delay()` — measurably defeats coroutines' cooperative scheduling, verified live with real timing in Lesson 19 (roughly 2x slower).

## Best Practices

- Prefer non-nullable types by default; mark a type nullable (`String?`) only when `null` is a genuinely meaningful value, and use `?:`/`?.` over `!!` wherever a reasonable fallback exists.
- Leave classes final (the default) unless subclassing is a deliberate, designed-for part of the class's contract.
- Return genuine defensive copies (`.toList()`) from a class's collection-returning properties, not just read-only-*typed* references to the same mutable backing object (Lesson 07's and Lesson 19's key finding).
- Use `delay()`, not `Thread.sleep()`, inside any `suspend` function.

## Interview Questions

1. **How does Kotlin's null safety actually prevent `NullPointerException`s, compared to Java?**
   Kotlin's type system distinguishes nullable (`String?`) from non-nullable (`String`) types at compile time — a non-nullable type can never hold `null`, verified directly in this course (attempting it produces a real compile error). Any genuinely nullable value must be explicitly typed as such and handled via `?.`, `?:`, or the escape-hatch `!!` before being used as non-null — contrasted with Java, where any reference type can hold `null` with no type-level distinction, making an NPE a purely runtime discovery.

2. **What's the practical difference between Kotlin's `==` and Java's `==`, and why does this matter for developers switching between the two?**
   In Kotlin, `==` performs structural (content-based) equality by calling `.equals()` automatically; `===` is the referential (same-object) check. In Java, it's the reverse: `==` is referential, and `.equals()` must be called explicitly for content comparison. This was verified directly in this course (Lesson 04): two separately-constructed data class instances with identical content compared `true` under Kotlin's `==` but `false` under `===` — exactly backwards from what a Java-trained instinct would predict.

3. **How does Kotlin's declaration-site variance (`out`/`in`) differ from Java's use-site wildcards, and why is it considered an improvement?**
   Java requires a wildcard (`? extends T`/`? super T`) at every individual call site needing covariance/contravariance — easy to forget at some call sites and not others. Kotlin lets a generic class's author declare variance once, at the class definition itself (`class Box<out T>`), and every subsequent use of that class automatically respects it with no repeated annotation needed — verified directly in this course (Lesson 13), where a `CovariantBox<Dog>` was accepted wherever a `CovariantBox<Animal>` was expected, with zero call-site wildcard syntax.

## Table of Contents

| # | Lesson | Covers |
|---|--------|--------|
| 01 | [Setup](01-Setup/README.md) | JVM interoperability, `kotlinc`, a real compiler/JDK compatibility fix |
| 02 | [Syntax](02-Syntax/README.md) | Top-level functions (no class wrapper), `val`/`var`, string templates |
| 03 | [Variables and Data Types](03-Variables-and-Data-Types/README.md) | Null safety (`String` vs `String?`), `?.`/`?:`/`!!` |
| 04 | [Operators](04-Operators/README.md) | `==` (structural) vs `===` (referential) — opposite of Java; ranges |
| 05 | [Control Flow](05-Control-Flow/README.md) | `when` (no fall-through), sealed classes + exhaustive `when` |
| 06 | [Functions](06-Functions/README.md) | Named/default params, extension functions, trailing lambdas, `it` |
| 07 | [Collections](07-Collections/README.md) | Read-only vs. mutable collection interfaces; read-only ≠ immutable |
| 08 | [Strings](08-Strings/README.md) | Triple-quoted raw strings; String IS java.lang.String |
| 09 | [Error Handling](09-Error-Handling/README.md) | `try` as an expression; NO checked exceptions at all |
| 10 | [File Handling](10-File-Handling/README.md) | `File` extension functions; no built-in JSON (same gap as Java) |
| 11 | [OOP](11-OOP/README.md) | Classes final by default; data classes; `object`; companion objects |
| 12 | [Functional Concepts](12-Functional-Concepts/README.md) | Closures CAN mutate captured vars (unlike Java); `let`/`apply` |
| 13 | [Generics](13-Generics/README.md) | Declaration-site variance (`out`/`in`); `reified` type parameters |
| 14 | [Async and Concurrency](14-Async-and-Concurrency/README.md) | Coroutines, `suspend`/`async`/`await`, structured concurrency |
| 15 | [Modules and Packages](15-Modules-and-Packages/README.md) | Packages independent of directory structure (unlike Java) |
| 16 | [Database Access](16-Database-Access/README.md) | JDBC (same as Java); `.use { }` (try-with-resources equivalent) |
| 17 | [API Integration](17-API-Integration/README.md) | `java.net.http.HttpClient`; no exception on 404 |
| 18 | [Testing](18-Testing/README.md) | `kotlin.test` + JUnit 5 binding |
| 19 | [Best Practices](19-Best-Practices/README.md) | `!!`, exposed mutable collections, `Thread.sleep()` in coroutines — reproduced live |
| 20 | [Exercises](20-Exercises/README.md) | 7 standalone problems: null safety, data classes, sealed classes, extension functions, declaration-site variance, coroutines |
| 21 | [Solutions](21-Solutions/README.md) | Matching, verified solutions for all 7 exercises, real compiled/run output |
| 22 | [Mini-Projects](22-Mini-Projects/README.md) | CLI Task Tracker — JDBC/SQLite persistence, `kotlin.test`/JUnit 5 suite (10 tests) |

Also see: [CHEAT-SHEET.md](CHEAT-SHEET.md).

## Suggested Path

Work through 01 → 19 in order. Lessons 05, 06, and 07 have `Exercises`/`Solutions` pairs. Given this repository's existing Java course, Kotlin is best read with Java open alongside it — nearly every lesson draws a direct, verified contrast (null safety, `==`/`===`, final-by-default classes, declaration-site variance) that's most useful when the Java baseline is fresh in mind. After finishing 01 → 19, [20-Exercises](20-Exercises/README.md) → [21-Solutions](21-Solutions/README.md) → [22-Mini-Projects](22-Mini-Projects/README.md) provide a standalone practice bank and a complete capstone CLI application tying the whole course together.

**Previous language:** [PHP](../PHP/README.md) | **Next:** [Swift](../Swift/README.md)
