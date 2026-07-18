# Scala Course

A complete, hands-on Scala 3 course. Every code example in this course was actually compiled and run with a Coursier-bootstrapped Scala 3.4.2 toolchain (`scalac`/`scala`) — no example is hypothetical.

## What is Scala?

Scala ("**Sca**lable **La**nguage") is a statically typed language that runs on the JVM (and can target JS/Native), fusing object-oriented and functional programming into one coherent language. Everything is an object, functions are first-class values, and the type system supports both OOP idioms (classes, traits, inheritance) and FP idioms (immutability, pattern matching, higher-order functions) natively.

## Why Learn Scala?

- **JVM interoperability** — call any Java library directly; reuse the entire Java ecosystem (JDBC drivers, HTTP clients, etc.).
- **Expression-oriented** — almost everything (`if`, `match`, blocks, `try`) produces a value, reducing boilerplate mutable state.
- **Strong, inferred type system** — catches whole classes of bugs at compile time while rarely requiring explicit type annotations.
- **Immutability by default** — collections and `val` bindings default to immutable, unlike Java's mutable-by-default collections.
- **Powers major distributed systems tools** — Apache Spark, Kafka Streams, Akka are all written in Scala.

## Where It's Used

Big data (Spark), backend services (Akka, Play, http4s, ZIO), and anywhere JVM interoperability plus functional rigor are valued (finance, ad-tech, distributed systems).

## Advantages

- Concise, expressive syntax compared to Java for equivalent logic.
- Powerful pattern matching (`match`) beats a chain of `if`/`else` or Java's `switch`.
- Case classes give free `equals`/`hashCode`/`toString`/`copy` for immutable data modeling.
- Full access to the mature Java ecosystem (JDBC, HTTP clients, testing libraries).
- Traits allow safe multiple inheritance of behavior, unlike Java's single-inheritance model.

## Disadvantages

- Steeper learning curve than Java/Kotlin — the type system (variance, implicits/givens, path-dependent types) is genuinely more complex.
- Slower compile times than many peer languages.
- No official build-tool-free dependency management story as smooth as `npm`/`pip` — sbt/Coursier have a learning curve of their own.
- Smaller hiring pool than Java/Kotlin/Python.

## Install

Two supported paths:
1. **Coursier** (`cs`) — the JVM/Scala package manager used to bootstrap this entire course's toolchain: `cs setup` installs `scalac`, `scala`, `sbt`.
2. **Scala CLI** (`scala-cli`) — a modern single-binary tool for running/compiling `.scala` files without a build tool, similar in spirit to what this course's example commands do manually with raw `scalac`/`scala`.

This course's examples were run against a Coursier-fetched Scala **3.4.2** toolchain (JDK 25 host). No project-wide build tool (sbt) is required to follow any lesson.

## How to Run Examples

Every lesson folder contains one or more standalone `.scala` files with `@main def someMain(): Unit = ...` entry points (Scala 3's top-level main-method annotation). From inside a lesson folder:

```bash
scalac SomeFile.scala
scala run . --main-class someMain
```

(`someMain` is the lowerCamelCase name of the `@main def`.) Lessons needing an external JAR (16-Database-Access, 22-Mini-Projects) document the exact classpath invocation used, since a downloaded dependency JAR is required and is *not* committed to this repository (see each lesson's README).

## Common Beginner Mistakes

- Assuming Scala collections are mutable by default, like Java's — they are **immutable by default** (Lesson 07 proves this live).
- Forgetting `match` must be exhaustive-checked by the compiler for sealed hierarchies, but is *not* automatically exhaustive for open types like `Int` — always include a wildcard `case _` unless matching a closed/sealed set.
- Confusing `==` with reference equality — Scala's `==` calls `equals` (structural equality) by default, unlike Java's `==` on objects.
- Treating `object` (a Scala singleton) as equivalent to a Java `static` block — it's a full first-class value.

## Best Practices

- Prefer `val` over `var`; prefer immutable collections over mutable ones.
- Model domain data with `case class`; model behavior contracts with `trait`.
- Prefer `Option`/`Either`/`Try` over `null` and unchecked exceptions for representing absence/failure.
- Keep pattern matches exhaustive; let the compiler catch missing cases on sealed hierarchies.

## Interview Questions

1. **What makes Scala's `match` more powerful than Java's `switch`?** — `match` supports pattern matching on types, deconstruction (case class extraction, tuples, lists via `::`), guards (`case x if x > 0 =>`), and exhaustiveness checking on sealed hierarchies, not just equality checks on primitive/enum values.
2. **Why does Scala favor `Option` over `null`?** — `Option[T]` makes absence part of the type system (`Some(x)`/`None`), forcing callers to explicitly handle the "no value" case at compile time, whereas `null` is a silent runtime landmine with no type-level signal.
3. **How do traits differ from Java interfaces?** — Traits can carry both abstract *and* concrete method/field implementations and be safely mixed into multiple inheritance chains (`class Foo extends Bar with Baz`), resolved via linearization — richer than Java's interfaces (default methods exist in Java 8+ but Java still lacks constructor parameters/state in interfaces).

## Table of Contents

| # | Topic |
|---|---|
| 01 | [Setup](01-Setup/README.md) |
| 02 | [Syntax](02-Syntax/README.md) |
| 03 | [Variables and Data Types](03-Variables-and-Data-Types/README.md) |
| 04 | [Operators](04-Operators/README.md) |
| 05 | [Control Flow](05-Control-Flow/README.md) |
| 06 | [Functions](06-Functions/README.md) |
| 07 | [Collections](07-Collections/README.md) |
| 08 | [Strings](08-Strings/README.md) |
| 09 | [Error Handling](09-Error-Handling/README.md) |
| 10 | [File Handling](10-File-Handling/README.md) |
| 11 | [OOP and Traits](11-OOP-and-Traits/README.md) |
| 12 | [Functional Concepts](12-Functional-Concepts/README.md) |
| 13 | [Generics and Type System](13-Generics-and-Type-System/README.md) |
| 14 | [Concurrency](14-Concurrency/README.md) |
| 15 | [Modules and Packages](15-Modules-and-Packages/README.md) |
| 16 | [Database Access](16-Database-Access/README.md) |
| 17 | [API Integration](17-API-Integration/README.md) |
| 18 | [Testing](18-Testing/README.md) |
| 19 | [Best Practices](19-Best-Practices/README.md) |
| 20 | [Exercises](20-Exercises/README.md) |
| 21 | [Solutions](21-Solutions/README.md) |
| 22 | [Mini-Projects](22-Mini-Projects/README.md) |

See also: [CHEAT-SHEET.md](CHEAT-SHEET.md)
