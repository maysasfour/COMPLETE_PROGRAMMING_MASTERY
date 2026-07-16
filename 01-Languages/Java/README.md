# Java

[Back to Languages overview](../README.md) | [Back to repo root](../../README.md)

## What Java Is

Java is a statically-typed, class-based, garbage-collected language running on the JVM (Java Virtual Machine) — "write once, run anywhere," since compiled Java bytecode runs identically on any platform with a compatible JVM. It's one of the most widely deployed languages in enterprise backends, Android development (via Kotlin's predecessor role and continued interop), and big-data tooling (Hadoop, Kafka, Spark are all JVM-based).

## Why / Where It's Used

- **Enterprise backends** — Spring Boot is one of the most widely used backend frameworks in the world, especially at large, established companies.
- **Android** — Java was Android's original primary language (Kotlin is now preferred for new code, but Java remains fully supported and present in most large Android codebases).
- **Big data** — Hadoop, Kafka, Spark, and Elasticsearch are all JVM-based, with Java as a first-class client language.
- **Long-lived, large-scale systems** — Java's strong backward compatibility guarantees and mature tooling make it a common choice for systems expected to run and be maintained for decades.

## Advantages

- Mature, extremely stable platform with strong backward compatibility across two decades of releases.
- The JVM's JIT compiler and garbage collector are best-in-class, tuned over 25+ years.
- Enormous ecosystem (Maven Central) and enterprise tooling (Spring, Hibernate) with deep institutional adoption.
- Real generics with type erasure (Lesson 13) still catch most misuse at compile time, if with some documented limitations.

## Disadvantages

- More verbose than most languages in this repository — no top-level functions (everything lives in a class), historically mandatory checked exceptions, and (until relatively recently) no local type inference.
- Slower iteration for small scripts compared to a dynamically-typed language, though JDK 11+'s single-file source-code execution (`java File.java`) has narrowed this gap significantly, used throughout this course.
- Generics are erased at compile time (Lesson 13) — unlike C#, `List<Integer>` and `List<String>` are indistinguishable at runtime, which has real practical limitations (no `new T()`, no `instanceof List<String>`).

## How to Install

```bash
# Download a JDK (Java Development Kit) from https://adoptium.net/ or your OS package manager
java --version
javac --version
```

This course was written and verified against **JDK 25**, but everything in it works on JDK 17+ (the current long-term-support baseline) unless a lesson says otherwise.

## How to Run the Examples

Every lesson folder has a `README.md` and a runnable `Example.java` (capitalized, matching Java's requirement that a public class's name matches its file name). Since JDK 11, a single `.java` file can be run directly with no separate compile step:

```bash
cd 01-Languages/Java/03-Variables-and-Data-Types
java Example.java
```

For lessons needing a real multi-file/build-tool project (16-Database-Access needs a JDBC driver JAR; 18-Testing needs JUnit), see those lessons' specific instructions.

## Common Beginner Mistakes

- **Forgetting Java has no free-standing functions** — every method lives inside a class, even a `static` "utility" method (Lesson 06).
- **Confusing `==` with `.equals()`** for objects — `==` compares references for any reference type (including `String` and boxed types like `Integer`), while `.equals()` compares logical content; this trips up nearly everyone coming from a language where `==` compares values (Lesson 04).
- **Boxing/unboxing surprises** — `Integer a = 200; Integer b = 200; a == b` is `false` (different objects outside the cached `-128..127` range), while `a.equals(b)` is `true` — a direct consequence of the `==`-vs-`.equals()` distinction applied to a commonly-autoboxed type.
- **Assuming generics are reified at runtime** like C#'s — Java generics are fully erased; `list instanceof List<String>` doesn't compile, and there's no way to recover the type argument via reflection (Lesson 13).

## Best Practices

- Always use `.equals()` (or `Objects.equals()` for null-safety) for object content comparison; reserve `==` for reference identity checks (rarely needed) and primitives.
- Use `var` (Java 10+) for obvious local-variable types to reduce verbosity, matching this course's convention in later lessons.
- Prefer immutable objects and `final` fields where practical; use `record` (Java 16+) for data-carrying types.
- Use the Stream API (Lesson 12) for collection transformations instead of manual loops, mirroring the `map`/`filter`/`reduce` idiom from every other language course in this repository.

## Interview Questions

1. **What's the difference between `==` and `.equals()` for objects in Java?**
   `==` always compares references for any reference type — two `String`/`Integer`/custom-object variables are `==` only if they point to the exact same object in memory. `.equals()` (when properly overridden, as `String` and boxed types do) compares logical/content equality. Using `==` where `.equals()` was intended is one of the most common Java bugs, especially with `String` literals vs. `new String(...)` and boxed `Integer` values outside the cached range.

2. **Why does Java have no free-standing functions?**
   Java is a purely class-based OOP language by design — every piece of executable code, including a program's entry point (`main`) and any "utility" function, must be a method belonging to some class, typically `static` for utility methods that don't need an instance. This differs from Python, JavaScript, C#, and Go, all of which support standalone functions outside any class.

3. **How does Java's generics implementation differ from C#'s?**
   Java generics are fully erased at compile time — `List<Integer>` and `List<String>` are literally the same class at runtime (`List`), and there's no way to recover the type argument via reflection. C#/.NET generates specialized code per value-type argument and preserves the type argument at runtime. This is why Java has restrictions C# doesn't: you can't write `new T()`, can't do `instanceof List<String>`, and need workarounds (like passing a `Class<T>` token) for patterns C# handles natively.

## Table of Contents

| # | Lesson | Covers |
|---|--------|--------|
| 01 | [Setup](01-Setup/README.md) | JDK install, `java`/`javac`, single-file source launcher |
| 02 | [Syntax](02-Syntax/README.md) | Classes as the only top-level construct, statements, comments |
| 03 | [Variables and Data Types](03-Variables-and-Data-Types/README.md) | Primitives vs. objects, boxing, `var`, `final` |
| 04 | [Operators](04-Operators/README.md) | Arithmetic/comparison/logical, `==` vs `.equals()`, `instanceof` pattern matching |
| 05 | [Control Flow](05-Control-Flow/README.md) | if/switch expressions (Java 14+), enhanced for, pattern matching |
| 06 | [Functions](06-Functions/README.md) | Methods, overloading, varargs, no free functions |
| 07 | [Collections](07-Collections/README.md) | `List`/`Map`/`Set`, the Collections Framework, Streams intro |
| 08 | [Strings](08-Strings/README.md) | Immutability, `StringBuilder`, text blocks |
| 09 | [Error Handling](09-Error-Handling/README.md) | try/catch/finally, checked vs. unchecked exceptions, try-with-resources |
| 10 | [File Handling](10-File-Handling/README.md) | `java.nio.file`, Jackson-free JSON via manual parsing or a note on libraries |
| 11 | [OOP](11-OOP/README.md) | Classes, interfaces, abstract classes, records, access modifiers |
| 12 | [Functional Concepts](12-Functional-Concepts/README.md) | Lambdas, functional interfaces, the Stream API |
| 13 | [Generics](13-Generics/README.md) | Generic methods/classes, bounded types, type erasure |
| 14 | [Async and Concurrency](14-Async-and-Concurrency/README.md) | Threads, `CompletableFuture`, virtual threads |
| 15 | [Modules and Packages](15-Modules-and-Packages/README.md) | Packages, JARs, Maven/Gradle |
| 16 | [Database Access](16-Database-Access/README.md) | JDBC CRUD with SQLite, parameterized queries |
| 17 | [API Integration](17-API-Integration/README.md) | `java.net.http.HttpClient`, JSON |
| 18 | [Testing](18-Testing/README.md) | JUnit 5 basics |
| 19 | [Best Practices](19-Best-Practices/README.md) | Synthesis checklist across lessons 01–18 |
| 20-22 | Exercises / Solutions / Mini-Projects | *not yet built as standalone folders — see per-lesson Exercises/Solutions on 05-07* |

Also see: [CHEAT-SHEET.md](CHEAT-SHEET.md).

## Suggested Path

Work through 01 → 19 in order. Lessons 05, 06, and 07 have `Exercises/`/`Solutions/` pairs.

**Previous language:** [C#](../CSharp/README.md) | **Next:** [C++](../Cpp/README.md)
