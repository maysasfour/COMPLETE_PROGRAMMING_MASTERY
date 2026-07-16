# 14 — Async and Concurrency

[Back to course overview](../README.md) | [Previous: Generics](../13-Generics/README.md)

## Beginner: `async def` and `await`

`async def` defines a **coroutine function** — calling it doesn't run the body immediately, it returns a coroutine object that needs to be driven by an event loop:

```python
import asyncio

async def say_hello():
    print("Hello...")
    await asyncio.sleep(1)   # pauses THIS coroutine, lets others run meanwhile
    print("...world!")

asyncio.run(say_hello())
```

`asyncio.run(coro)` is the standard entry point: it creates an event loop, runs the coroutine to completion, and cleans up the loop afterward. `await` can only appear inside an `async def` function, and it means "pause here until this awaitable finishes, and let the event loop go run something else in the meantime" — it's cooperative, not preemptive: control only switches at `await` points.

## Intermediate: Running Coroutines Concurrently with `asyncio.gather()`

Calling several coroutines with `await` one after another runs them **sequentially** — each one finishes before the next starts. `asyncio.gather()` runs them **concurrently**, interleaving their waiting time:

```python
import asyncio

async def fetch_data(name, delay):
    print(f"{name}: starting")
    await asyncio.sleep(delay)   # simulates an I/O wait (e.g. a network call)
    print(f"{name}: done")
    return f"{name} result"

async def main():
    results = await asyncio.gather(
        fetch_data("Task A", 2),
        fetch_data("Task B", 1),
        fetch_data("Task C", 1.5),
    )
    print(results)

asyncio.run(main())
```

Because all three tasks are I/O-bound waits, `asyncio.gather` runs them concurrently and the whole thing finishes in about 2 seconds (the longest single delay) rather than 4.5 seconds (the sum of all three) — this is the entire point of asyncio.

## Advanced: Threading vs. Multiprocessing vs. Asyncio

Python has three different concurrency tools, and picking the wrong one is a common source of "why isn't this faster?" confusion:

| Model | Unit of concurrency | Good for | Limitation |
|---|---|---|---|
| **Threading** (`threading`) | OS threads within one process | I/O-bound work (waiting on network/disk) | The GIL means only one thread runs Python bytecode at a time — no CPU parallelism |
| **Multiprocessing** (`multiprocessing`) | Separate OS processes | CPU-bound work (heavy computation) | Each process has its own memory and GIL, so real parallelism — but higher overhead, no shared memory by default |
| **Asyncio** (`asyncio`) | Cooperative coroutines in one thread | I/O-bound work, especially with *many* concurrent waits | Still single-threaded — one slow, blocking, non-async call stalls everything |

**The GIL (Global Interpreter Lock)** is a CPython implementation detail: it ensures only one thread executes Python bytecode at any instant, even on a multi-core machine. This means `threading` in CPython does **not** give you CPU-bound parallelism — spinning up four threads to crunch numbers doesn't use four cores, because they still take turns holding the GIL. Threading *does* still help for I/O-bound work, because a thread waiting on a network call releases the GIL while it waits, letting another thread run.

**Multiprocessing sidesteps the GIL entirely** by using separate OS processes, each with its own Python interpreter and memory space and therefore its own GIL. This is how you actually get CPU-bound parallelism in Python — at the cost of more memory, slower process startup, and needing to explicitly serialize (pickle) data passed between processes.

**Asyncio** is single-threaded, cooperative concurrency: one thread runs many coroutines, switching between them only at `await` points. It doesn't add CPU parallelism either, but for I/O-bound workloads with many concurrent waits (hundreds of network requests, for example), it scales far better than one-thread-per-task because coroutines are far cheaper than OS threads.

**Rule of thumb:**
- I/O-bound, need to scale to many concurrent operations → **asyncio**.
- I/O-bound, smaller scale, or working with libraries that aren't async-aware → **threading**.
- CPU-bound (heavy computation) → **multiprocessing** (or a C-extension library that releases the GIL, like NumPy).

## Real-World Usage

- Web servers and API clients that juggle many concurrent network requests (FastAPI, `aiohttp`, `httpx.AsyncClient`) are built on asyncio because it scales to thousands of concurrent connections far more cheaply than one thread per connection.
- Data pipelines doing heavy numeric computation (image processing, simulations) reach for `multiprocessing` (or a `ProcessPoolExecutor`) specifically to get real multi-core speedup, since the GIL rules out threads for this.
- GUI applications commonly use a background `threading.Thread` to keep the UI responsive while waiting on a slow, non-async I/O operation.
- `concurrent.futures.ThreadPoolExecutor`/`ProcessPoolExecutor` give a higher-level, futures-based API over `threading`/`multiprocessing` for simple "run this pool of tasks" needs.

## Summary

- `async def` defines a coroutine function; `await` pauses the current coroutine at an I/O point and lets the event loop run something else meanwhile.
- `asyncio.run()` is the standard way to start the event loop and run a top-level coroutine to completion.
- `asyncio.gather()` runs multiple coroutines concurrently, so total time is closer to the longest single wait rather than the sum of all waits.
- The GIL means CPython threads never run Python bytecode in true parallel, so `threading` doesn't speed up CPU-bound work — it only helps I/O-bound work.
- `multiprocessing` uses separate processes (each with its own GIL) to get genuine CPU-bound parallelism, at the cost of more memory and explicit data serialization.
- Asyncio is single-threaded cooperative concurrency, best suited to I/O-bound work that needs to scale to many concurrent operations cheaply.

## Key Terms

- **Coroutine** — a function defined with `async def`; calling it returns a coroutine object that must be awaited or scheduled to actually run.
- **Event loop** — the scheduler that drives coroutines, switching between them at `await` points; `asyncio.run()` creates and manages one for you.
- **`asyncio.gather()`** — runs multiple awaitables concurrently and returns their results together once all have completed.
- **GIL (Global Interpreter Lock)** — a CPython lock ensuring only one thread executes Python bytecode at a time, which is why threading alone doesn't parallelize CPU-bound work.
- **I/O-bound vs. CPU-bound** — I/O-bound work spends most of its time waiting (network, disk); CPU-bound work spends most of its time actively computing. The right concurrency tool depends on which one you have.

## Common Mistakes

- Calling several coroutines with sequential `await`s and expecting them to run concurrently — plain sequential `await` runs one at a time; use `asyncio.gather()` (or `asyncio.create_task()`) for concurrency.
- Using `threading` for CPU-bound work and being confused that it isn't faster — the GIL prevents true parallel bytecode execution across threads.
- Calling a blocking, non-async function (e.g., `time.sleep()` or a synchronous HTTP call) inside an `async def` — it blocks the entire event loop, stalling every other coroutine, not just the current one.
- Forgetting `asyncio.run()` (or an existing event loop) and trying to just call a coroutine function directly, which only produces an unused coroutine object with no output.
- Assuming asyncio gives CPU parallelism — it doesn't; it's still one thread, just efficient at juggling many waiting operations.

## Best Practices

- Use `await asyncio.sleep(...)` only for simulating delays in examples/tests; use real async I/O libraries (`aiohttp`, `asyncpg`, etc.) for actual network/database calls in async code.
- Use `asyncio.gather()` when you have several independent awaitables and want them running concurrently, then need all of their results together.
- Never call a blocking function directly inside a coroutine; if you must call blocking code, run it in a thread pool via `asyncio.to_thread()` (or `loop.run_in_executor()`).
- Reach for `multiprocessing` (or `concurrent.futures.ProcessPoolExecutor`) specifically when the bottleneck is CPU computation, not I/O waiting.
- Pick the concurrency model based on the actual bottleneck (I/O vs. CPU) rather than defaulting to whichever one is most familiar.

## Interview Questions

1. **What does `await` actually do inside a coroutine?**
   It pauses the current coroutine until the awaited operation completes, and hands control back to the event loop so it can run other ready coroutines in the meantime. This is cooperative multitasking — control only switches at `await` points, never in the middle of a line of code.

2. **Why doesn't `asyncio.gather()` running three tasks that each sleep for different durations take the sum of all three durations?**
   Because `gather()` starts all the coroutines and lets the event loop interleave their waiting periods concurrently, rather than running each one fully before starting the next. The total time is roughly the duration of the *longest* individual task, since the shorter ones finish their waits "in the background" while the longest one is still pending.

3. **Why doesn't Python's `threading` module give CPU-bound parallelism, and what does give it?**
   CPython's Global Interpreter Lock (GIL) ensures only one thread executes Python bytecode at any given instant, so multiple threads doing pure computation still take turns rather than running simultaneously on multiple cores. `multiprocessing` gives real parallelism instead, because each process has its own separate Python interpreter and its own GIL.

4. **When would you choose asyncio over threading for I/O-bound work?**
   When you need to scale to a large number of concurrent I/O operations — asyncio's coroutines are much cheaper to create and switch between than OS threads, so it scales to hundreds or thousands of concurrent waits far more efficiently than one-thread-per-task. For a small number of I/O-bound operations, or when working with libraries that aren't async-aware, threading is often simpler and sufficient.

5. **What happens if you call a blocking, synchronous function (like `time.sleep()`) inside an `async def` coroutine?**
   It blocks the single thread the entire event loop runs on, which freezes every other coroutine, not just the one that called it — defeating the purpose of using asyncio at all. The fix is to use an async-native equivalent (`await asyncio.sleep(...)`) or offload the blocking call to a thread pool with `asyncio.to_thread()`.

## Suggested Next Lesson

[15 — Modules and Packages](../15-Modules-and-Packages/README.md)
