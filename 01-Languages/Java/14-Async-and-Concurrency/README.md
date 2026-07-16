# 14 — Async and Concurrency

[Back to course overview](../README.md) | [Previous: Generics](../13-Generics/README.md)

## Learning Objectives

- Use `CompletableFuture` for asynchronous computation.
- Run independent tasks concurrently with `CompletableFuture.allOf`.
- Understand Java's traditional platform threads vs. Java 21+ virtual threads.

## Prerequisites

[13-Generics](../13-Generics/README.md)

## Concept

Java's concurrency model predates `async`/`await`-style syntax — the traditional building block is `Thread`, and the modern high-level API for composable asynchronous computation is `CompletableFuture<T>` (Java 8+), roughly analogous to `Promise<T>`/`Task<T>` from the JavaScript/TypeScript/C# courses, though with a more verbose, callback-chaining API rather than `await` syntax. Java 21 introduced **virtual threads** — extremely lightweight, JVM-managed threads that make blocking-style I/O code scale similarly to `async`/`await`, without rewriting it in a callback/future style.

## `CompletableFuture`

```java
import java.util.concurrent.CompletableFuture;

CompletableFuture<String> future = CompletableFuture.supplyAsync(() -> {
    sleep(100);
    return "Hello, Ada";
});

String result = future.join(); // blocks until the future completes, returning its value
System.out.println(result);

CompletableFuture<String> chained = CompletableFuture
    .supplyAsync(() -> "Hello")
    .thenApply(s -> s + ", Ada"); // like .then() on a Promise
```

## Running Concurrently: `CompletableFuture.allOf`

```java
CompletableFuture<String> f1 = CompletableFuture.supplyAsync(() -> delayedGreet(80, "Ada"));
CompletableFuture<String> f2 = CompletableFuture.supplyAsync(() -> delayedGreet(80, "Lin"));
CompletableFuture<String> f3 = CompletableFuture.supplyAsync(() -> delayedGreet(80, "Kai"));

CompletableFuture.allOf(f1, f2, f3).join(); // waits for all three concurrently
System.out.println(f1.join() + " | " + f2.join() + " | " + f3.join());
```

Starting all three futures **before** joining any of them runs them concurrently on the common thread pool; `allOf(...).join()` then waits for all to complete together, taking roughly the duration of the *longest* individual task — the same principle as `Promise.all`/`Task.WhenAll` from every other language course, expressed through Java's more verbose future-composition API.

## Virtual Threads (Java 21+)

```java
try (var executor = java.util.concurrent.Executors.newVirtualThreadPerTaskExecutor()) {
    executor.submit(() -> {
        sleep(100);
        System.out.println("Running on a virtual thread: " + Thread.currentThread());
    });
}
```

Virtual threads are extremely cheap (millions can exist simultaneously, unlike platform threads which are OS-level and expensive) — they let ordinary blocking code (a blocking database call, a blocking HTTP request) scale to huge numbers of concurrent operations without needing to rewrite it in `CompletableFuture`'s callback style, a genuinely major recent addition to the platform.

## Detailed Example

See [Example.java](Example.java) — includes real elapsed-time measurement contrasting sequential futures with `CompletableFuture.allOf`.

## Expected Output

Running `java Example.java` prints a basic `CompletableFuture` result, a chained `.thenApply`, real timing showing `allOf` completing in roughly the duration of the longest task rather than the sum of all three, and a task run on a virtual thread.

## Common Mistakes

- Calling `.join()`/`.get()` immediately after starting a single future, one at a time, for independent tasks — needlessly serializes work that `allOf` could run concurrently.
- Confusing platform threads (expensive, OS-level, limited in number) with virtual threads (cheap, JVM-managed, can number in the millions) — using a platform-thread-per-request model at high concurrency was a real historical scalability bottleneck virtual threads specifically address.

## Best Practices

- Use `CompletableFuture.allOf` (or `.thenCombine` for exactly two) for independent concurrent operations rather than sequential `.join()` calls.
- Prefer virtual threads (Java 21+) for I/O-bound, high-concurrency workloads over manually managing a fixed platform-thread pool.

## Real-World Usage

Modern Spring Boot applications increasingly adopt virtual threads for request-handling threads specifically to support far higher concurrent connection counts than a traditional platform-thread-per-request model allowed, without needing to rewrite blocking JDBC/HTTP client code in a reactive/future-chaining style.

## Summary

- `CompletableFuture<T>` is Java's composable async-computation type, roughly analogous to `Promise`/`Task`.
- `CompletableFuture.allOf(...)` runs independent futures concurrently, finishing in roughly the longest single duration — verified with real timing, not just asserted.
- Virtual threads (Java 21+) let ordinary blocking code scale to massive concurrency without a callback/future rewrite.

## Key Terms

- **`CompletableFuture<T>`** — Java's composable type representing an asynchronous computation that will produce a value of type `T`.
- **Virtual thread** — an extremely lightweight, JVM-managed thread (Java 21+) enabling blocking-style code to scale to huge concurrency.

## Interview Questions

1. **What's the difference between a platform thread and a virtual thread?**
   A platform thread maps directly to an OS-level thread — expensive to create, limited in practical number (typically thousands), and a common historical scalability bottleneck for thread-per-request server models. A virtual thread (Java 21+) is a lightweight, JVM-managed thread that can number in the millions, letting ordinary blocking code scale to very high concurrency without a callback/future-based rewrite.

2. **How does `CompletableFuture.allOf` compare to `Promise.all`/`Task.WhenAll`?**
   All three run a set of already-started, independent asynchronous operations concurrently and let you wait for all of them together, completing in roughly the duration of the longest single operation rather than their sum. `CompletableFuture.allOf` is Java's version of the same underlying pattern, though its API (returning `CompletableFuture<Void>`, requiring you to call `.join()` on each individual future afterward to get its result) is more verbose than `Promise.all`'s direct array-of-results or `Task.WhenAll`'s typed result array.

## Recommended Next Lesson

[15 — Modules and Packages](../15-Modules-and-Packages/README.md)
