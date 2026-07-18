# 01 — Setup

[Back to course overview](../README.md)

## Learning Objectives

- Understand the two ways to run Scala: compiled (`scalac` + `scala`) and via the `scala` command's script-runner mode.
- Understand Scala's JVM foundation and interop with Java.
- Compile and run a real `.scala` file end-to-end.

## Concept

Scala source compiles to JVM bytecode (`.class` files), exactly like Java — this is why Scala can call any Java library directly with zero wrapper code. Two toolchain pieces matter: `scalac` (the compiler, producing `.class`/`.tasty` files) and `scala` (the runner, which can both execute already-compiled classes and, in "script mode", compile-and-run a single file in one step without leaving `.class` files behind in the way a manual `scalac` invocation does).

This course used a Coursier-bootstrapped Scala **3.4.2** toolchain, invoked as `scalac.bat`/`scala.bat` from two-step compile-then-run commands (shown below), rather than a project-wide build tool like sbt — appropriate for standalone lesson files.

## Compiled vs. Script Execution

```bash
# Two-step: compile to .class/.tasty, then run the class
scalac Hello.scala
scala run . --main-class hello

# One-step script mode (scala-cli or `scala Hello.scala` in newer distributions)
# compiles in memory and runs immediately, no .class files left behind
```

This course uses the two-step form throughout, matching how a real Scala project's build tool (sbt) separates compilation from execution.

## Detailed Example

See [Hello.scala](Hello.scala) — a minimal `@main` entry point.

## Run It

```bash
cd 01-Languages/Scala/01-Setup
scalac Hello.scala
scala run . --main-class hello
```

## Expected Output

```
Hello Scala, sum=6
JVM interop: Java's System.getProperty("java.version") works with zero wrapper code
```

(Actually compiled and run against Scala 3.4.2 on a JDK 25 host during this course's construction. Harmless `WARNING: A restricted method in java.lang.System has been called` lines about native access appear on stderr — they are not compiler errors and can be ignored.)

## Common Mistakes

- Expecting a bare `scalac Hello.scala && Hello` to run the program — the compiled class must be launched with `scala run . --main-class <name>` (or `java -cp . HelloClassName` once you know the JVM main-class name Scala 3's `@main` macro generates).
- Confusing the annotation-based `@main def foo(): Unit = ...` (Scala 3, used throughout this course) with the older `object Foo extends App` or explicit `def main(args: Array[String])` styles from Scala 2 — all three still work in Scala 3, but `@main` is the modern idiom used here.

## Best Practices

- Use `@main def someName(): Unit = ...` for standalone runnable examples — the concise, modern Scala 3 idiom.
- Keep one `@main` per file for lesson clarity, matching this course's one-file-per-concept layout.

## Real-World Usage

Real Scala projects almost always use sbt (or Mill) for multi-file, multi-module builds with dependency management — this course intentionally uses raw `scalac`/`scala` per-lesson to keep each concept self-contained and runnable without a build-tool learning curve up front.

## Summary

- Scala compiles to JVM bytecode via `scalac`; `scala run . --main-class <name>` executes it.
- `@main def name(): Unit = ...` is the Scala 3 idiom for a runnable entry point.
- Real projects use sbt/Mill; this course uses raw toolchain commands for lesson isolation.

## Key Terms

- **`scalac`** — the Scala compiler, producing JVM `.class`/`.tasty` files.
- **`@main`** — a Scala 3 annotation turning a top-level `def` into a runnable program entry point.

## Interview Questions

1. **Why can Scala call Java libraries directly with no wrapper code?** — Because Scala compiles to the same JVM bytecode format as Java, and both languages' compiled classes are interchangeable on the classpath; there's no marshalling layer, unlike calling C from Python.
2. **What does `@main` do in Scala 3?** — It's a compiler annotation that turns an ordinary top-level function into a runnable program entry point, generating a class with a standard `public static void main(String[])` JVM method under the hood, without needing `object ... extends App` or an explicit `main(args: Array[String])` signature.

## Recommended Next Lesson

[02 — Syntax](../02-Syntax/README.md)
