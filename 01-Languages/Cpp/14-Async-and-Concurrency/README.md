# 14 — Async and Concurrency

[Back to course overview](../README.md) | [Previous: Generics](../13-Generics/README.md)

## Learning Objectives

- Use `std::thread` for genuine OS-level threads.
- Use `std::async`/`std::future` for a higher-level, Promise/Task-like async computation model.
- Use `std::mutex` for protecting shared state, and understand C++ has no built-in event loop.

## Prerequisites

[13-Generics](../13-Generics/README.md)

## Concept

C++ has no built-in event loop (unlike JavaScript) and no async/await syntax (unlike C#/JavaScript/TypeScript) — concurrency is built from lower-level primitives: `std::thread` (a genuine OS thread), `std::async`/`std::future` (a higher-level, `Promise`/`Task`-like abstraction over a thread or thread pool), and `std::mutex` (mutual exclusion for shared state).

## `std::thread`

```cpp
#include <thread>

void printMessage(const std::string& msg) {
    std::cout << msg << std::endl;
}

std::thread t(printMessage, "Hello from a thread");
t.join(); // wait for the thread to finish -- REQUIRED, or std::terminate is called
```

Every `std::thread` must be either `.join()`-ed (waited for) or `.detach()`-ed (allowed to run independently) before it's destroyed — forgetting both calls `std::terminate()` and crashes the program, a distinctly C++ footgun with no equivalent in garbage-collected languages' thread APIs.

## `std::async`/`std::future`

```cpp
#include <future>

std::future<int> future = std::async(std::launch::async, []() {
    return 42;
});
int result = future.get(); // blocks until the value is ready, like Task<T>.Result or Promise .then()
```

`std::async` is C++'s closest analog to `Promise`/`Task` from the JavaScript/TypeScript/C# courses — it returns a `std::future<T>` representing a value that will be ready later, and `.get()` blocks until it is (analogous to `.join()`/`.Result`, with the same "avoid blocking unnecessarily" caution).

## Running Concurrently

```cpp
auto f1 = std::async(std::launch::async, []() { return computeSlow(1); });
auto f2 = std::async(std::launch::async, []() { return computeSlow(2); });
auto f3 = std::async(std::launch::async, []() { return computeSlow(3); });

int total = f1.get() + f2.get() + f3.get(); // all three ran concurrently; total waits for all
```

Launching all three `std::async` calls **before** calling `.get()` on any of them runs them concurrently; the total wall-clock time is roughly the duration of the *longest* individual task — the same underlying principle as `Promise.all`/`Task.WhenAll`/`CompletableFuture.allOf` from every other language course, expressed through C++'s lower-level future API.

## `std::mutex` for Shared State

```cpp
#include <mutex>

std::mutex mtx;
int sharedCounter = 0;

void incrementSafely() {
    std::lock_guard<std::mutex> lock(mtx); // RAII: unlocks automatically when lock goes out of scope
    sharedCounter++;
}
```

`std::lock_guard` is RAII (Lesson 09) applied to locking — the mutex is released automatically when `lock` goes out of scope, even if an exception is thrown, with no manual unlock call needed.

## Detailed Example

See [example.cpp](example.cpp) — includes real elapsed-time measurement contrasting sequential `.get()` calls with concurrent `std::async` launches.

## Expected Output

Compiling and running `example.cpp` prints a basic thread's output, a basic `std::async`/`future` result, real timing showing concurrent futures completing faster than sequential ones, and a mutex-protected counter incremented safely from multiple threads.

## Common Mistakes

- Forgetting to `.join()` or `.detach()` a `std::thread` before it's destroyed — calls `std::terminate()`, crashing the program.
- Calling `.get()` on each `std::async` future immediately after launching it, one at a time, instead of launching all futures first — needlessly serializes work that could run concurrently.
- Accessing shared mutable state from multiple threads without a `std::mutex` (or another synchronization primitive) — a data race, undefined behavior with no automatic detection at runtime by default.

## Best Practices

- Always `.join()` or explicitly `.detach()` every `std::thread`.
- Launch all independent `std::async` tasks before calling `.get()` on any of them, to run them concurrently.
- Use `std::lock_guard`/`std::unique_lock` (RAII) for mutex locking, never manual `.lock()`/`.unlock()` calls that could be skipped by an exception.

## Real-World Usage

`std::async`/`std::future` are used for CPU-bound parallel work (splitting a computation across cores); `std::mutex`/`std::lock_guard` are the standard building blocks for any shared mutable state accessed from multiple threads, appearing throughout real-time and server-side C++ systems.

## Summary

- C++ has no built-in event loop or `async`/`await` syntax — concurrency is built from `std::thread`, `std::async`/`std::future`, and `std::mutex`.
- Every `std::thread` must be `.join()`-ed or `.detach()`-ed, or the program terminates.
- `std::async` launched concurrently (all launches before any `.get()`) mirrors `Promise.all`/`Task.WhenAll`/`CompletableFuture.allOf` — verified with real timing, not just asserted.
- `std::lock_guard` applies RAII to mutex locking, guaranteeing release even during exception unwinding.

## Key Terms

- **`std::thread`** — a genuine OS-level thread.
- **`std::future`/`std::async`** — a higher-level async-computation abstraction, C++'s closest analog to `Promise`/`Task`.
- **`std::mutex`** — a mutual-exclusion lock protecting shared state from concurrent access.

## Interview Questions

1. **What happens if a `std::thread` is destroyed without being `.join()`-ed or `.detach()`-ed?**
   The program calls `std::terminate()` and crashes immediately — C++ requires every thread's fate (waited-for via `.join()`, or allowed to run independently via `.detach()`) to be explicitly decided before the `std::thread` object's destructor runs, with no automatic default behavior the way garbage-collected languages' thread/task abstractions provide.

2. **How does `std::async` compare to `Promise`/`Task` from the JavaScript/C#/Java courses?**
   `std::async` launches a computation (potentially on a separate thread) and returns a `std::future<T>` representing its eventual result, conceptually similar to a `Promise<T>`/`Task<T>`/`CompletableFuture<T>`. `.get()` blocks until the result is ready, similar to `await`/`.Result`/`.join()`. The key difference is C++ has no `async`/`await` syntax sugar — composing multiple futures or chaining continuations is more manual than the other languages' syntax-supported equivalents.

## Recommended Next Lesson

[15 — Modules and Packages](../15-Modules-and-Packages/README.md)
