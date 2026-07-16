# 09 — Error Handling

[Back to course overview](../README.md) | [Previous: Strings](../08-Strings/README.md)

## Learning Objectives

- Use `try`/`catch`/`finally` and multi-catch.
- Distinguish **checked** exceptions (must be declared/caught) from **unchecked** exceptions (`RuntimeException` and subclasses).
- Use try-with-resources for automatic cleanup.
- Write custom exceptions.

## Prerequisites

[08-Strings](../08-Strings/README.md)

## Concept

Java is the only language in this repository with **checked exceptions**: exception types (extending `Exception` but not `RuntimeException`) that the compiler *forces* calling code to either catch or declare (`throws`) — a distinctive, sometimes controversial Java design choice not present in C#, JavaScript/TypeScript, Python, or most other mainstream languages. **Unchecked** exceptions (extending `RuntimeException`) behave like exceptions in every other language course — no compiler enforcement to catch or declare them.

## Checked vs. Unchecked

```java
import java.io.IOException;

// Checked: the compiler REQUIRES this method to either catch IOException or declare `throws IOException`
static void readFile() throws IOException {
    throw new IOException("simulated failure");
}

// Unchecked: RuntimeException subclasses need no such declaration
static int divide(int a, int b) {
    if (b == 0) throw new ArithmeticException("Cannot divide by zero"); // unchecked
    return a / b;
}
```

```java
try {
    readFile();
} catch (IOException e) {
    System.out.println("Caught: " + e.getMessage());
}
```

## Custom Exceptions

```java
class ValidationException extends RuntimeException { // unchecked, by convention for most custom exceptions
    private final String field;
    public ValidationException(String message, String field) {
        super(message);
        this.field = field;
    }
    public String getField() { return field; }
}
```

## Try-With-Resources

```java
try (var reader = new java.io.BufferedReader(new java.io.FileReader("file.txt"))) {
    System.out.println(reader.readLine());
} catch (IOException e) {
    System.out.println("Error: " + e.getMessage());
} // reader.close() is called automatically, even if an exception occurred
```

Try-with-resources (any resource implementing `AutoCloseable`) guarantees `.close()` is called when the block exits — successfully or via exception — directly analogous to C#'s `using` statement and Python's `with`.

## Detailed Example

See [Example.java](Example.java).

## Expected Output

Running `java Example.java` prints a caught checked exception, a caught unchecked exception, a custom exception with its extra field used, and try-with-resources closing a resource automatically.

## Common Mistakes

- Catching `Exception` broadly to "handle" a checked exception without actually addressing the failure, hiding genuine problems.
- Making every custom exception `extends Exception` (checked) by default — modern Java style generally favors unchecked (`extends RuntimeException`) exceptions except where callers genuinely need to be compiler-forced to handle a specific, expected, recoverable failure.
- Forgetting try-with-resources requires the resource type to implement `AutoCloseable`/`Closeable`.

## Best Practices

- Prefer unchecked exceptions for most custom exception types; reserve checked exceptions for cases where forcing callers to explicitly handle a failure is genuinely valuable (this is a debated point even within the Java community).
- Always use try-with-resources for `AutoCloseable` resources (files, database connections, network sockets) instead of manual `finally`-block cleanup.

## Real-World Usage

Checked exceptions are one of Java's most debated design decisions — many modern frameworks (Spring) deliberately wrap checked exceptions from underlying libraries (JDBC, Lesson 16) into unchecked ones at their API boundary, since forcing every caller up the stack to declare/catch checked exceptions from deep infrastructure code was found to add more ceremony than safety in practice.

## Summary

- Checked exceptions (extending `Exception`, not `RuntimeException`) are compiler-enforced — must be caught or declared.
- Unchecked exceptions (extending `RuntimeException`) need no such declaration, like exceptions in every other language course.
- Try-with-resources guarantees `.close()` on any `AutoCloseable`, even when an exception occurs.

## Key Terms

- **Checked exception** — an exception type the compiler forces calling code to catch or declare via `throws`.
- **Unchecked exception** — a `RuntimeException` subclass requiring no compiler-enforced handling.
- **Try-with-resources** — a `try` form that automatically closes any `AutoCloseable` resource when the block exits.

## Interview Questions

1. **What's the difference between a checked and an unchecked exception in Java?**
   A checked exception (any `Exception` subclass that isn't itself a `RuntimeException`) must be either caught or declared with `throws` in the method signature — the compiler enforces this. An unchecked exception (`RuntimeException` and its subclasses) requires no such declaration, behaving like exceptions in virtually every other mainstream language.

2. **What does try-with-resources guarantee, and what must a resource type support to use it?**
   It guarantees `.close()` is called on the resource when the `try` block exits, whether normally or via an exception — eliminating the need for a manual `finally` block calling `.close()`. The resource type must implement `AutoCloseable` (or its subinterface `Closeable`).

## Recommended Next Lesson

[10 — File Handling](../10-File-Handling/README.md)
