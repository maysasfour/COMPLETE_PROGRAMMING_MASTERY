# 14 — Async and Concurrency

[Back to course overview](../README.md) | [Previous: Generics](../13-Generics/README.md)

## Learning Objectives

- Use `async`/`await` and `Task<T>`.
- Run independent async operations concurrently with `Task.WhenAll`.
- Understand C#'s thread-pool-backed concurrency model, contrasted with JavaScript's single-threaded event loop.

## Prerequisites

[13-Generics](../13-Generics/README.md)

## Concept

C#'s `async`/`await` syntax looks almost identical to JavaScript/TypeScript's, but the underlying model differs: .NET is **multi-threaded** — `async` methods can genuinely run on different thread-pool threads, and `await` frees the current thread to do other work while waiting, rather than JavaScript's single-thread-with-an-event-loop model. Despite the different underlying mechanism, the *code you write* looks and behaves very similarly.

## `Task<T>` and `async`/`await`

```csharp
async Task<string> DelayAndGreetAsync(int ms, string name) {
    await Task.Delay(ms);
    return $"Hello, {name}";
}

string greeting = await DelayAndGreetAsync(100, "Ada");
Console.WriteLine(greeting);
```

An `async` method's return type is always `Task` (no value) or `Task<T>` (a value of type `T`) — directly analogous to TypeScript's `Promise<T>` requirement for `async` functions.

## `Task.WhenAll`: Concurrent Execution

```csharp
async Task RunConcurrentlyAsync() {
    var task1 = DelayAndGreetAsync(100, "Ada");
    var task2 = DelayAndGreetAsync(100, "Lin");
    var task3 = DelayAndGreetAsync(100, "Kai");

    string[] results = await Task.WhenAll(task1, task2, task3); // runs concurrently
    Console.WriteLine(string.Join(" | ", results));
}
```

Calling all three methods **before** awaiting any of them starts them all immediately; `Task.WhenAll` then waits for all three together, taking roughly the duration of the *longest* one — directly analogous to JavaScript's `Promise.all`, and for the same underlying reason (concurrent rather than sequential waiting).

## Detailed Example

See [example.cs](example.cs) — includes real elapsed-time measurement contrasting sequential `await` with `Task.WhenAll`, exactly like the JavaScript/TypeScript courses' equivalent lessons.

## Expected Output

Running `dotnet run example.cs` prints a basic `async`/`await` greeting, then real timing measurements showing `Task.WhenAll` completing in roughly the duration of the longest individual task rather than the sum of all three sequential awaits.

## Common Mistakes

- Calling `.Result`/`.Wait()` on a `Task` instead of `await`ing it — can cause a deadlock in contexts with a synchronization context (classic ASP.NET, some UI frameworks), and always blocks a thread unnecessarily even where it doesn't deadlock.
- Awaiting independent tasks sequentially instead of starting them all first and using `Task.WhenAll`, needlessly serializing work that could run concurrently.

## Best Practices

- Always use `await`, never `.Result`/`.Wait()`, for asynchronous code.
- Use `Task.WhenAll` for independent operations that can run concurrently.
- Suffix async method names with `Async` (`DelayAndGreetAsync`) — a strong, widely-followed .NET naming convention that makes async call sites self-documenting.

## Real-World Usage

ASP.NET Core is asynchronous by default throughout its request pipeline — every controller action, database call (Lesson 16), and outgoing HTTP call (Lesson 17) is typically `async Task<T>`, since blocking a thread-pool thread for I/O directly limits how many concurrent requests a server can handle.

## Summary

- C#'s `async`/`await` looks like JavaScript/TypeScript's, but runs on a real, multi-threaded thread pool rather than a single-threaded event loop.
- `async` methods return `Task`/`Task<T>`, analogous to `Promise`/`Promise<T>`.
- `Task.WhenAll` runs independent tasks concurrently, analogous to `Promise.all`.

## Key Terms

- **`Task<T>`** — represents an asynchronous operation that will produce a value of type `T`.
- **Thread pool** — the pool of worker threads .NET uses to run asynchronous continuations, contrasted with JavaScript's single-threaded event loop.

## Interview Questions

1. **How does C#'s async model differ from JavaScript's, despite similar-looking syntax?**
   JavaScript is single-threaded with an event loop — `await` never runs code on a different thread, it just yields control back to that one thread's event loop. C#/.NET is multi-threaded — `async`/`await` can genuinely run continuations on different thread-pool threads, providing real parallelism for CPU-adjacent work in addition to the I/O-concurrency benefit both languages share.

2. **Why should you avoid calling `.Result` or `.Wait()` on a `Task`?**
   Both block the calling thread until the task completes, defeating the purpose of async code, and in contexts with a synchronization context (some older ASP.NET and UI frameworks) can cause a deadlock if the awaited task itself needs to resume on that same blocked thread. `await` avoids both problems by properly yielding control instead of blocking.

## Recommended Next Lesson

[15 — Modules and Packages](../15-Modules-and-Packages/README.md)
