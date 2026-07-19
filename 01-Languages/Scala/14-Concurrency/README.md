# 14 — Concurrency

[Back to course overview](../README.md) | [Previous: Generics and Type System](../13-Generics-and-Type-System/README.md)

## Learning Objectives

- Run asynchronous work with `scala.concurrent.Future`, backed by an `ExecutionContext` (a thread pool).
- Prove, with real measured wall-clock timing, that concurrently-started `Future`s genuinely overlap rather than running one after another.
- Compose `Future`s with `map`/`flatMap`/for-comprehensions, and handle failure via `Success`/`Failure`.

## Prerequisites

[13-Generics-and-Type-System](../13-Generics-and-Type-System/README.md)

## Concept

A `Future[T]` represents a value of type `T` that may not exist yet — a computation running asynchronously on a thread pool (an `ExecutionContext`), which the rest of the program can react to via callbacks (`map`, `flatMap`) or block on via `Await`. Crucially, a `Future` **starts running the moment it's created**, not when something later asks for its result — this is why launching three `Future`s back to back (rather than awaiting each one before starting the next) makes them run concurrently rather than sequentially, verified with real timing below.

## Sequential vs. Concurrent — Proven with Real Timing

```scala
// SEQUENTIAL: each Await blocks before the next Future is even created
Await.result(slowTask("A", 300), 5.seconds)
Await.result(slowTask("B", 300), 5.seconds)
Await.result(slowTask("C", 300), 5.seconds)
// total: ~900ms

// CONCURRENT: all three Futures are created (and start running) before any Await
val fa = slowTask("A", 300)
val fb = slowTask("B", 300)
val fc = slowTask("C", 300)
val combined = for { a <- fa; b <- fb; c <- fc } yield (a, b, c)
Await.result(combined, 5.seconds)
// total: ~300ms -- NOT ~900ms, proving all three actually ran at once
```

## Handling Success/Failure

```scala
val failFuture: Future[Int] = Future { 10 / 0 }
Await.ready(failFuture, 2.seconds).value.get match
  case Success(v) => println(s"succeeded: $v")
  case Failure(e) => println(s"failed: ${e.getMessage}")
```

A `Future` never throws to the calling thread directly — a failure is captured as a `Failure(exception)`, consistent with the `Try` philosophy from Lesson 09.

## Detailed Example

See [Concurrency.scala](Concurrency.scala) — a real measured sequential baseline (three 300ms tasks, ~900ms total), the same three tasks run concurrently (~300ms total, proving genuine overlap), success/failure handling via `Success`/`Failure`, and `Future` chaining with `map`/`flatMap`.

## Run It

```bash
cd 01-Languages/Scala/14-Concurrency
scalac Concurrency.scala
scala run . --main-class concurrencyDemo
```

## Expected Output

Timing numbers vary slightly run to run (thread scheduling), but the actually-observed run produced:

```
--- sequential baseline: three 300ms tasks run ONE AFTER ANOTHER ---
sequential total: 977ms (expect ~900ms)

--- concurrent: three 300ms tasks started AT THE SAME TIME ---
conc-A done after 300ms
conc-B done after 300ms
conc-C done after 300ms
concurrent total: 305ms (expect ~300ms, NOT ~900ms -- proves real overlap)

--- Future composition and failure handling ---
okFuture succeeded: 5
failFuture failed: ArithmeticException: / by zero

--- chaining with map/flatMap ---
chained result: 11
```

## Common Mistakes

- Calling `Await.result` immediately after creating each `Future` (one at a time) — this accidentally serializes work that could have run concurrently, exactly the "sequential" mistake this lesson measures and shows costs ~3x longer.
- Forgetting to import/define an `ExecutionContext` — `Future { ... }` won't compile without one in scope (provided here via `given ExecutionContext = ExecutionContext.global`).
- Using `Await.result` pervasively in production code — it blocks a thread, defeating much of the purpose of asynchronous `Future`s; real async code chains `map`/`flatMap`/callbacks and only blocks at the outermost edge (e.g. a `main` method or test).

## Best Practices

- Create all independent `Future`s first, then combine/await them together (as shown), rather than awaiting each one before starting the next.
- Use a for-comprehension over `Future`s (as with `combined` above) to combine multiple independent results readably.
- Reserve `Await` for the outermost boundary of a program (like this demo's `main` method) — internal code should chain, not block.

## Real-World Usage

Web services fetching data from multiple independent sources (a database call, an external API call, a cache lookup) launch all three as separate `Future`s immediately, then combine their results — exactly the pattern this lesson's concurrent timing demonstrates — rather than fetching them one at a time and needlessly adding their latencies together.

## Summary

- `Future[T]` starts running immediately on creation, on a thread pool provided by an implicit/given `ExecutionContext`.
- Launching multiple `Future`s before awaiting any of them lets them run concurrently — measured directly here as ~3x faster than the sequential equivalent.
- Failures are captured as `Failure(exception)` rather than thrown to the calling thread, consistent with this course's `Try` type from Lesson 09.

## Key Terms

- **`Future[T]`** — a value of type `T` computed asynchronously; may succeed (`Success`) or fail (`Failure`).
- **`ExecutionContext`** — the thread pool a `Future`'s work actually runs on.
- **`Await.result`** — blocks the calling thread until a `Future` completes (or a timeout elapses), returning its value or rethrowing its exception.

## Interview Questions

1. **Why does creating three `Future`s back-to-back run them concurrently, while awaiting each one individually runs them sequentially — and how was this proven, not just claimed?** — A `Future`'s body starts executing on the `ExecutionContext`'s thread pool the moment `Future { ... }` is evaluated, independent of when (or whether) anything later calls `Await` on it. Creating `fa`, `fb`, `fc` one after another (with no `Await` between them) lets all three start running near-simultaneously on the pool's threads; `Await`-ing each one before creating the next forces the second and third to not even *start* until the previous one finished. This lesson measured both directly: the sequential version of three 300ms tasks took ~977ms (close to 3×300ms), while the concurrent version of the same three tasks took ~305ms (close to 1×300ms) — real timing, not a theoretical claim.
2. **How does `Future` represent failure, and how does that connect to Lesson 09's `Try` type?** — A `Future` never throws an exception directly to the thread that created it; instead, a failed computation is captured as a `Failure(exception)` value (mirroring `scala.util.Try`'s `Success`/`Failure`, since `Future` is built on the same idea applied asynchronously). This was verified live: `Future { 10 / 0 }`, when awaited via `Await.ready(...).value.get`, produced `Failure(ArithmeticException: / by zero)` rather than crashing the program, letting the failure be pattern-matched and handled as an ordinary value.

## Recommended Next Lesson

[15 — Modules and Packages](../15-Modules-and-Packages/README.md)
