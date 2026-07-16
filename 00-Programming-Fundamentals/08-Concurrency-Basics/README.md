# 08 — Concurrency Basics

[Back to module overview](../README.md) | [Previous: Modules and Packages](../07-Modules-and-Packages/README.md)

## Beginner: Concurrency vs. Parallelism

These two words get used interchangeably, but they describe different things:

- **Concurrency** is about *structure*: dealing with multiple tasks that are all in progress at once, by interleaving their execution — not necessarily running at the exact same instant. A single CPU core can be concurrent by rapidly switching between tasks.
- **Parallelism** is about *execution*: multiple tasks are *literally* running at the same instant, which requires multiple CPU cores (or multiple machines).

A helpful analogy: one chef juggling three dishes, working on whichever one needs attention next, is being **concurrent**. Three chefs each cooking their own dish simultaneously is **parallel**. You can have concurrency without parallelism (one core, interleaved), and you can (rarely) have parallelism without deliberate concurrency, but in practice they usually combine — a program can be structured concurrently *and* run parts of that structure in true parallel across cores.

## Beginner: Threads vs. Processes (Conceptually)

- **A process** is an independent running program with its own private memory space. Two processes can't accidentally see or corrupt each other's variables — the operating system isolates them. Starting a process and communicating between processes has more overhead.
- **A thread** is a unit of execution *within* a process. Multiple threads in the same process **share the same memory space** — this makes communication between them cheap (no serialization needed), but also means two threads can race to modify the same variable at the same time, corrupting shared state if not carefully coordinated (a **race condition**).

| | Processes | Threads |
|---|---|---|
| Memory | Isolated per process | Shared within the same process |
| Communication cost | Higher (must serialize data) | Lower (direct shared access) |
| Crash isolation | One process crashing doesn't affect others | One thread crashing can take down the whole process |
| Coordination risk | Lower (no shared memory to race over) | Higher (race conditions possible) |

**Python specifics**: CPython has a **Global Interpreter Lock (GIL)** — only one thread executes Python bytecode at a time, even on a multi-core machine. This means Python threads give you *concurrency* for I/O-bound work (waiting on network/disk, where the GIL is released during the wait) but not true *parallelism* for CPU-bound work. For CPU-bound parallel work in Python, the `multiprocessing` module (separate processes, each with its own interpreter and GIL) is the standard approach instead.

## Intermediate: Why Concurrency Exists At All

Most programs spend significant time **waiting** — for a network response, a disk read, a database query. During that wait, a CPU core is otherwise idle. Concurrency lets a program start other work during that wait instead of blocking everything until the slow operation finishes. This is why concurrency matters enormously for I/O-bound programs (web servers, network clients) even on a single core.

## Advanced: A Simple Async Example

Python's `asyncio` provides **cooperative concurrency**: a single thread runs multiple tasks, and each task voluntarily yields control (at an `await` point) whenever it would otherwise have to wait — letting another task run during that wait instead of blocking the entire program.

```python
import asyncio

async def fetch_data(name, delay):
    print(f"{name}: starting")
    await asyncio.sleep(delay)   # simulates waiting on I/O (e.g., a network call) - yields control
    print(f"{name}: done")
    return f"{name} result"

async def main():
    # Running these concurrently means they overlap their waiting time,
    # instead of waiting for one to fully finish before starting the next.
    results = await asyncio.gather(
        fetch_data("A", 2),
        fetch_data("B", 1),
    )
    print(results)

asyncio.run(main())
```

Key vocabulary:
- **`async def`** declares a **coroutine function** — calling it doesn't run the body immediately, it returns a coroutine object that must be awaited or scheduled.
- **`await`** pauses the current coroutine at that point, yielding control back to the event loop, which can run other ready tasks in the meantime — and resumes this coroutine once the awaited operation completes.
- **The event loop** is the scheduler that decides which ready coroutine runs next, driving the whole cooperative-concurrency system.

This is *concurrency without parallelism*: everything above runs on a single thread. The benefit comes entirely from not blocking on I/O waits — `asyncio` is not the right tool for CPU-heavy work, since there's no second core doing anything; use `multiprocessing` for that instead.

## Real-World Usage

- Web servers handling thousands of simultaneous connections typically use async I/O (or a thread pool) rather than one OS thread per connection, because OS threads are relatively expensive to create and switch between at that scale.
- `multiprocessing` (true parallelism, separate processes) is used for CPU-bound work like image processing, scientific computation, or data pipeline transformations that need multiple cores.
- Race conditions from unsynchronized threads are among the hardest real-world bugs to reproduce and fix, because they often depend on precise timing that varies run to run — this is a strong argument for preferring immutable data (Lesson 05) and message-passing over shared mutable state whenever concurrency is involved.

## Summary

- Concurrency is about structuring interleaved progress on multiple tasks; parallelism is about literally executing multiple tasks at the same instant, requiring multiple cores.
- Processes are isolated (safer, costlier to communicate between); threads share memory within a process (cheaper communication, race-condition risk).
- CPython's GIL means Python threads give concurrency for I/O-bound work but not parallelism for CPU-bound work; `multiprocessing` is used for true CPU parallelism instead.
- `asyncio` provides single-threaded cooperative concurrency via `async`/`await`, ideal for I/O-bound waiting, not CPU-heavy computation.

## Key Terms

- **Concurrency** — structuring a program to make interleaved progress on multiple tasks.
- **Parallelism** — literally executing multiple tasks at the same instant, requiring multiple cores.
- **Process** — an independent running program with isolated memory.
- **Thread** — a unit of execution within a process, sharing memory with other threads in that process.
- **Race condition** — a bug where the outcome depends on the unpredictable timing/order of concurrent operations on shared state.
- **GIL (Global Interpreter Lock)** — CPython's lock ensuring only one thread executes Python bytecode at a time.
- **Coroutine** — a function (declared with `async def`) that can pause and resume its execution at `await` points.
- **Event loop** — the scheduler that runs ready coroutines/tasks and resumes paused ones.

## Common Mistakes

- Using `asyncio` (or threads) for CPU-bound work expecting a speedup — without true parallelism (multiple cores/processes), CPU-bound work sees no benefit and async code adds needless complexity.
- Assuming Python threads give real parallelism for pure Python code — the GIL prevents that for CPU-bound work; threads help I/O-bound work instead.
- Forgetting to `await` a coroutine call — this just creates a coroutine object without running its body, a very common `asyncio` beginner mistake (Python will usually warn "coroutine was never awaited").
- Sharing mutable state across threads without synchronization, causing race conditions that are hard to reproduce and debug because their occurrence depends on timing.

## Interview Questions

1. **What's the difference between concurrency and parallelism?**
   Concurrency is about structuring a program to make interleaved progress on multiple tasks — it doesn't require literal simultaneity. Parallelism is about tasks literally executing at the same instant, which requires multiple CPU cores. Concurrency can exist on a single core (via interleaving); parallelism cannot.

2. **What's the difference between a thread and a process?**
   A process is an independent, memory-isolated running program. A thread is a unit of execution within a process, sharing that process's memory with other threads. Processes are safer to run concurrently (no shared memory to race over) but costlier to communicate between; threads are cheap to communicate between but risk race conditions on shared state.

3. **What is Python's GIL, and what does it mean for threaded code?**
   The Global Interpreter Lock ensures only one thread executes Python bytecode at any instant in a CPython process. This means Python threads can provide concurrency for I/O-bound work (the GIL is released while waiting on I/O) but cannot provide true parallelism for CPU-bound work — for that, use separate processes via `multiprocessing`.

4. **What does `await` actually do in an `async def` function?**
   It pauses execution of the current coroutine at that point (typically because it's waiting on something, like I/O), returning control to the event loop so other ready coroutines can run. Once the awaited operation completes, the event loop resumes this coroutine from exactly where it paused.

5. **Why is `asyncio` not a good fit for CPU-bound work?**
   `asyncio` provides concurrency through a single thread cooperatively switching between coroutines at `await` points — there is no second core doing anything, so CPU-bound work (which never actually waits/yields) blocks the entire event loop instead of overlapping with anything. True parallelism for CPU-bound work requires multiple processes (via `multiprocessing`), not `asyncio`.

## Suggested Next Lesson

This is the final lesson of the Programming Fundamentals module. Continue to [01-Languages/Python](../../01-Languages/Python/README.md) to apply these concepts in a full language course.
