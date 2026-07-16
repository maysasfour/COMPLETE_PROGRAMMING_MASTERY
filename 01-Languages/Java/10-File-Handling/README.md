# 10 — File Handling

[Back to course overview](../README.md) | [Previous: Error Handling](../09-Error-Handling/README.md)

## Learning Objectives

- Read and write text files with `java.nio.file.Files`.
- Understand that the JDK has no built-in JSON library (unlike Python/Node/C#), and know the standard third-party solution.
- Handle a missing file with a specific checked exception.

## Prerequisites

[09-Error-Handling](../09-Error-Handling/README.md)

## Concept

`java.nio.file` (NIO.2, since Java 7) is the modern file I/O API, providing simple static methods (`Files.readString`, `Files.writeString`) for whole-file text operations — Java's equivalent of Node's `fs/promises` or Python's `pathlib`. Unlike Python (`json`), Node (`JSON`), or C# (`System.Text.Json`), **the JDK has no built-in JSON library at all** — real Java projects universally reach for a third-party library (Jackson or Gson) for JSON, a genuine and notable gap this course flags rather than works around with a fragile hand-rolled parser.

## Reading and Writing Text Files

```java
import java.nio.file.*;

Path path = Path.of("notes.txt");
Files.writeString(path, "Hello, file system!\n");
String contents = Files.readString(path);
```

## No Built-In JSON: What Real Projects Use

```java
// This does NOT compile with just the JDK -- shown for contrast, not runnable in this lesson:
// import com.fasterxml.jackson.databind.ObjectMapper;
// ObjectMapper mapper = new ObjectMapper();
// Config config = mapper.readValue(jsonString, Config.class);
```

Jackson (`com.fasterxml.jackson.core:jackson-databind`) is the de facto standard JSON library in the Java ecosystem — used throughout Spring Boot and most production services — added via Maven/Gradle (Lesson 15), analogous to how the JavaScript course needed no install for JSON (built-in) but Java genuinely does need one. This lesson's example sticks to text-file I/O (which the JDK does support natively) rather than introducing a dependency just for this one lesson.

## Handling a Missing File

```java
try {
    String contents = Files.readString(Path.of("does-not-exist.txt"));
} catch (java.nio.file.NoSuchFileException e) {
    System.out.println("File doesn't exist -- using defaults");
}
```

`NoSuchFileException` is a checked exception (Lesson 09) — it must be caught or the calling method must declare `throws NoSuchFileException` (or a broader `IOException`, which it extends).

## Detailed Example

See [Example.java](Example.java) — writes and reads a text file, and handles a genuinely missing file.

## Expected Output

Running `java Example.java` prints round-tripped text content and confirms reading a missing file throws `NoSuchFileException`, caught and handled gracefully.

## Common Mistakes

- Assuming the JDK has a built-in JSON parser the way Python/Node/C# do — it doesn't; Jackson or Gson (a Maven/Gradle dependency) is required for real JSON work.
- Catching the broad `IOException` instead of the specific `NoSuchFileException` when only "file missing" should be handled specially, masking other I/O failures (permissions, disk errors) under the same handling.

## Best Practices

- Use `java.nio.file.Files`'s simple static methods for whole-file text operations rather than the older, more verbose `java.io.FileReader`/`BufferedReader` streaming APIs, unless streaming (not loading the whole file into memory) is specifically needed.
- Catch the most specific exception type for the failure you're actually prepared to handle.

## Real-World Usage

Every real Java backend service reads configuration and serializes API responses via Jackson (bundled by default in Spring Boot), not hand-rolled parsing — understanding that the JDK itself has no JSON support explains why literally every Java project pulls in this one dependency almost universally.

## Summary

- `java.nio.file.Files` provides simple static methods for whole-file text I/O, built into the JDK.
- The JDK has **no built-in JSON library** — Jackson/Gson (a dependency) is the near-universal real-world solution.
- `NoSuchFileException` (a checked exception) is the specific type to catch for a missing file.

## Key Terms

- **NIO.2 (`java.nio.file`)** — the modern (Java 7+) file I/O API, providing `Path`/`Files`.
- **Jackson** — the de facto standard third-party JSON library for Java, not part of the JDK.

## Interview Questions

1. **Does the JDK have a built-in JSON parsing library?**
   No — unlike Python's `json`, Node's global `JSON`, or C#'s `System.Text.Json`, the JDK ships with no JSON support at all. Real Java projects universally add Jackson or Gson as a Maven/Gradle dependency; this is one of the most consistent "first thing every Java project needs" additions in the ecosystem.

2. **Why catch `NoSuchFileException` specifically instead of the broader `IOException` when reading a possibly-missing file?**
   Catching the specific subtype ensures only the exact failure you intended to handle ("the file isn't there") is caught, while other I/O failures (permission denied, disk error) still propagate and aren't silently treated identically.

## Recommended Next Lesson

[11 — OOP](../11-OOP/README.md)
