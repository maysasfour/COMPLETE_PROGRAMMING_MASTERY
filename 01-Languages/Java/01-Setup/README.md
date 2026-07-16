# 01 — Setup

[Back to course overview](../README.md)

## Learning Objectives

- Install a JDK and verify it.
- Run a single `.java` file directly with the JDK 11+ single-file source launcher.
- Understand the compile-then-run model (`javac` then `java`) that underlies it.

## Prerequisites

None — entry point of the Java course.

## Concept

Java compiles source (`.java`) to **bytecode** (`.class`), which the JVM (Java Virtual Machine) then interprets/JIT-compiles to native code at runtime — this is what "write once, run anywhere" means: the same `.class` bytecode runs on any platform with a compatible JVM. Traditionally this was a two-step process (`javac Example.java` then `java Example`); since JDK 11, `java Example.java` compiles and runs in one step for single-file programs, without producing a persistent `.class` file — this course uses that single-file mode throughout for the same "just run the file" ergonomics the other language courses have.

## Syntax

```java
// Example.java -- the public class name MUST match the file name exactly.
public class Example {
    public static void main(String[] args) {
        System.out.println("Hello, Java");
    }
}
```

```bash
java Example.java
```

Every Java program's entry point is a `public static void main(String[] args)` method — `static` because it's called before any object exists, `void` because it returns nothing to the OS directly (use `System.exit(code)` for a specific exit code), and `String[] args` for command-line arguments.

## Detailed Example

See [Example.java](Example.java).

## Expected Output

Running `java Example.java` prints a greeting and the running JVM version.

## Common Mistakes

- Naming the file differently from its `public class` — Java requires an exact match (including case) between a public class and its containing file's name.
- Forgetting `java Example.java` (single-file mode) doesn't work if the file has more than one *public* top-level class — only one public type per file is allowed regardless of execution mode.

## Best Practices

- Use single-file execution (`java File.java`) for scripts/lessons/prototypes; use a real build (Maven/Gradle, Lesson 15) once a project grows past a handful of files or needs dependencies.

## Real-World Usage

Production Java projects always use a build tool (Maven/Gradle, Lesson 15) producing a packaged JAR; single-file execution is primarily for scripts, quick prototypes, and — as in this course — self-contained lessons.

## Summary

- Java compiles to JVM bytecode; the JVM provides "write once, run anywhere."
- JDK 11+ supports running a single `.java` file directly with `java File.java`, no separate `javac` step.
- The public class name must exactly match its containing file's name.

## Key Terms

- **JVM (Java Virtual Machine)** — the runtime that executes compiled Java bytecode.
- **Bytecode** — the compiled, platform-independent intermediate form the JVM executes.

## Interview Questions

1. **What does "write once, run anywhere" mean for Java?**
   Java source compiles to platform-independent bytecode (`.class` files), which any JVM — regardless of the underlying OS/CPU — can execute identically, as long as a compatible JVM is installed. The JVM itself is platform-specific, but the compiled bytecode is not.

2. **What's the difference between `javac` and `java`?**
   `javac` is the compiler, translating `.java` source into `.class` bytecode. `java` is the launcher that runs compiled bytecode (or, since JDK 11, compiles and runs a single `.java` source file directly in one step without leaving a persistent `.class` file behind).

## Recommended Next Lesson

[02 — Syntax](../02-Syntax/README.md)
