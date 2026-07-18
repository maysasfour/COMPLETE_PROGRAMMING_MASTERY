# 10 — File Handling

[Back to course overview](../README.md) | [Previous: Error Handling](../09-Error-Handling/README.md)

## Learning Objectives

- Read a text file's contents using `scala.io.Source`.
- Write a file using plain Java I/O (`java.nio.file.Files`), since Scala has no dedicated file-writing API of its own.
- Understand Scala's honest JSON situation: there is no built-in JSON parser in the standard library.

## Concept

Scala's standard library provides `scala.io.Source` for *reading* text (files, URLs, stdin) conveniently, but has **no built-in file-writing API** and **no built-in JSON parser** — for both, idiomatic Scala reaches directly into `java.nio.file`/`java.io` (writing) or a third-party library (JSON: circe, play-json, upickle — none included here to keep this course dependency-free per its brief). This lesson is honest about that gap rather than pretending otherwise.

## Reading a File

```scala
import scala.io.Source
val source = Source.fromFile("data.txt")
try source.getLines().foreach(println) finally source.close()
```

## Writing a File (via Java's `java.nio.file`)

```scala
import java.nio.file.{Files, Paths}
Files.writeString(Paths.get("out.txt"), "hello\n")
```

## The Honest JSON Situation

Scala has **no JSON parser in its standard library** — real projects add circe, play-json, or upickle as a build-tool dependency. Since this course is dependency-minimal (matching this repository's approach for other languages lacking a built-in JSON parser), this lesson hand-rolls a **minimal, deliberately narrow** parser for one specific flat `{"key": "value", ...}` shape, purely to demonstrate the parsing *concept* — it is explicitly not a general-purpose JSON parser and should not be used as one.

## Detailed Example

See [FileHandling.scala](FileHandling.scala) — writes a temp file, reads it back line by line, and hand-parses one flat JSON object string into a `Map[String, String]`.

## Run It

```bash
cd 01-Languages/Scala/10-File-Handling
scalac FileHandling.scala
scala run . --main-class fileHandlingDemo
```

## Expected Output

```
wrote temp file, read back lines:
  line 1
  line 2
hand-rolled JSON parse of {"name": "Ada", "lang": "Scala"}: Map(name -> Ada, lang -> Scala)
```

## Common Mistakes

- Forgetting to `.close()` a `Source` after reading — it holds an open file handle; always wrap in `try/finally` or use `.getLines().mkString` inside a `Using.resource` block (from `scala.util.Using`) for automatic closing.
- Assuming Scala has a built-in JSON parser because so many other modern languages do — it deliberately doesn't; every real project pulls in a third-party library (circe, play-json, upickle) via a build tool.
- Using the narrow hand-rolled parser in this lesson for anything beyond its documented flat-object demonstration purpose — it does not handle nesting, arrays, escaping edge cases, or numbers correctly, and is explicitly not production-ready.

## Best Practices

- Use `scala.util.Using` (Scala's resource-management combinator, conceptually similar to Java's try-with-resources) to guarantee `Source`/file handles are closed.
- Add a real JSON library (circe is the most idiomatic functional-Scala choice) via sbt/Coursier for any real project needing JSON — never hand-roll a parser outside of a teaching context like this one.

## Real-World Usage

Real Scala services parsing JSON almost universally depend on circe (functional, type-class-based) or play-json (imperative-style, common in Play Framework apps) — this lesson's hand-rolled parser exists purely to make the "no batteries included" gap concrete, exactly as this course's brief requires being honest about.

## Summary

- `scala.io.Source` reads text; file *writing* uses plain Java I/O (`java.nio.file.Files`) since Scala has no writing API of its own.
- Scala's standard library has no JSON parser at all — real projects depend on circe/play-json/upickle.

## Key Terms

- **`scala.io.Source`** — Scala's standard-library text-reading utility, wrapping various input sources (files, URLs) as iterators of lines/characters.
- **`scala.util.Using`** — Scala's resource-management combinator, guaranteeing a `Closeable` resource is closed after use.

## Interview Questions

1. **Does Scala have a built-in JSON parser?** — No. This is a genuine, honest gap in the standard library — real Scala projects add a third-party library (circe, play-json, or upickle are the most common) as a build dependency; there is no "batteries included" JSON support the way, say, Python's `json` module provides.
2. **How does Scala handle file writing, given `scala.io.Source` is read-only?** — By using plain Java I/O directly (`java.nio.file.Files.writeString`, or `java.io.PrintWriter`), since Scala runs on the JVM and has full access to Java's file APIs; Scala doesn't reinvent file writing, it just doesn't need to.

## Recommended Next Lesson

[11 — OOP and Traits](../11-OOP-and-Traits/README.md)
