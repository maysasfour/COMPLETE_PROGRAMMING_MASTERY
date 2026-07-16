# 14 — Async and Concurrency

[Back to course overview](../README.md) | [Previous: Generics](../13-Generics/README.md)

## Learning Objectives

- Use `suspend` functions, `runBlocking`, `async`/`await`, and `launch` from `kotlinx.coroutines`.
- Verify the concurrency speedup of `async`/`await` with real measured timing, not just asserted.
- Understand structured concurrency: a `coroutineScope` doesn't return until all its child coroutines complete.

## Prerequisites

[13-Generics](../13-Generics/README.md)

## Concept

Kotlin's `suspend` keyword is a genuine language feature (the compiler transforms a `suspend fun` into a state machine capable of pausing and resuming), but the actual coroutine dispatcher/scheduler that runs and resumes these suspended functions is provided by a separate library, `kotlinx.coroutines` — not bundled in the Kotlin standard library itself, similar to how Rust's `async`/`await` syntax exists in the language but needs an external runtime crate (`tokio`), covered in this repository's Rust course. This is a genuinely different model from Go's goroutines/channels (a full built-in runtime) and from raw Java threads (OS-level, no cooperative scheduling).

## `suspend` Functions and `runBlocking`

```kotlin
suspend fun fetchValue(id: Int, delayMs: Long): Int {
    delay(delayMs) // suspends the COROUTINE without blocking the underlying OS thread
    return id * 10
}

fun main() = runBlocking { // bridges ordinary blocking code (main) into the coroutine world
    val a = fetchValue(1, 200)
    val b = fetchValue(2, 200)
}
```

`delay()` (coroutine-aware) suspends only the coroutine, freeing its underlying thread to do other work — genuinely different from `Thread.sleep()`, which blocks the entire OS thread. `runBlocking` is the bridge between ordinary, non-coroutine code (like `main`) and the coroutine world — it blocks the calling thread until the coroutine block inside it completes.

## `async`/`await`: Real, Measured Concurrency

```kotlin
val deferredA = async { fetchValue(1, 200) } // starts immediately, doesn't block
val deferredB = async { fetchValue(2, 200) } // runs alongside deferredA
val a = deferredA.await()                      // suspends until deferredA finishes
val b = deferredB.await()
```

Verified live with real timing: two sequential 200ms-delayed `suspend` calls took **413ms** total, while the same two calls issued concurrently via `async`/`await` took **212ms** — confirming the two coroutines genuinely ran concurrently (overlapping their delays) rather than one after another, measured directly with `measureTimeMillis`, not just asserted.

## Structured Concurrency: `coroutineScope` Waits for Its Children

```kotlin
coroutineScope {
    launch { // fire-and-forget WITHIN this scope
        delay(100)
        println("child coroutine finished")
    }
    println("parent coroutine continues immediately")
}
println("this only runs after the coroutineScope's child has completed")
```

Verified live: `"parent coroutine continues immediately"` printed before `"child coroutine finished"` (confirming `launch` doesn't block the parent), but the final `println` after the `coroutineScope { }` block only ran *after* the child coroutine's delayed print — confirming `coroutineScope` genuinely waits for every coroutine launched inside it to complete before returning, even though `launch` itself doesn't block. This is Kotlin's **structured concurrency** guarantee: coroutines can't "leak" past the scope that launched them, unlike raw threads (which can easily outlive the function that started them with no automatic tracking).

## Detailed Example

See [Example.kt](Example.kt) — sequential vs. concurrent `suspend` calls with real, measured timing, and a structured-concurrency demonstration confirming a `coroutineScope`'s wait-for-children guarantee.

## Run It

```bash
cd 01-Languages/Kotlin/14-Async-and-Concurrency
# Requires kotlinx-coroutines-core.jar on the classpath (downloaded separately, not committed):
kotlinc -cp kotlinx-coroutines-core.jar Example.kt -include-runtime -d Example.jar
java -cp "Example.jar;kotlinx-coroutines-core.jar" ExampleKt
```

## Expected Output

Running the compiled JAR prints `a=10, b=20` twice (once for the sequential calls, once for the concurrent ones), with the sequential run taking roughly double the concurrent run's time (measured directly: approximately 413ms vs. 212ms in this environment), a confirmation the concurrent version was faster, and the structured-concurrency demonstration confirming the parent continued immediately but the overall block only completed after the child coroutine finished.

## Common Mistakes

- Confusing `delay()` (coroutine-aware, non-blocking) with `Thread.sleep()` (blocks the entire underlying OS thread) — using `Thread.sleep()` inside a coroutine defeats the purpose of using coroutines at all, since it blocks the thread other coroutines might need.
- Calling `.await()` immediately after each `async { }` call instead of starting both `async` calls first — `async { A }.await(); async { B }.await()` runs sequentially in effect, since each `await()` blocks before the next `async` even starts; both `async` calls must be issued *before* either is awaited to get genuine concurrency.
- Assuming `launch` is "fire and forget" in the sense of being entirely detached — it's still tracked by its enclosing `coroutineScope`/`runBlocking`, which will wait for it, verified live in this lesson.

## Best Practices

- Start all independent `async` calls before awaiting any of them, to get genuine concurrent execution (as demonstrated and measured in this lesson).
- Use `coroutineScope`/structured concurrency (rather than unstructured, "global" coroutine launches) so that coroutines can't outlive the logical operation that started them — this is one of Kotlin coroutines' most significant safety advantages over unmanaged threads.
- Reserve `runBlocking` for bridging into coroutines from non-suspending code (like a program's `main` function or a test); avoid it inside otherwise-suspending code, where it can unnecessarily block a thread.

## Real-World Usage

Kotlin coroutines are the standard approach for asynchronous programming in modern Kotlin codebases — especially Android development (replacing older callback-based or RxJava-based asynchronous patterns) and Ktor-based backend services — specifically because of the combination of lightweight scheduling (thousands of coroutines can run on a small thread pool, unlike OS threads) and the structured-concurrency safety guarantee demonstrated in this lesson.

## Summary

- `suspend` is a genuine Kotlin language feature; the actual coroutine dispatcher/scheduler comes from the separate `kotlinx.coroutines` library, mirroring Rust's `async`/`await`-needs-`tokio` situation.
- `async`/`await` provide real, measurable concurrency — confirmed directly (413ms sequential vs. 212ms concurrent for two 200ms-delayed operations).
- `coroutineScope` provides structured concurrency: it doesn't return until every coroutine launched inside it completes, verified live via output ordering — coroutines can't outlive their enclosing scope.

## Key Terms

- **`suspend` function** — a function that can pause its execution without blocking the underlying thread, resumable later.
- **Structured concurrency** — the guarantee that a coroutine scope doesn't complete until all coroutines launched within it have finished, preventing "leaked" background work.

## Interview Questions

1. **How did this lesson prove that `async`/`await` actually run concurrently, rather than just looking concurrent in the code's structure?**
   By measuring real wall-clock time with `measureTimeMillis` around both a sequential and a concurrent version of the same two 200ms-delayed operations: the sequential version took approximately 413ms (roughly the sum of both delays), while the `async`/`await` version took approximately 212ms (roughly the duration of a *single* delay, since both ran overlapping) — a direct, measured confirmation that the two `async` blocks executed concurrently rather than one after another, not merely an assumption based on the syntax used.

2. **What does "structured concurrency" mean in the context of Kotlin's `coroutineScope`, and why does it matter?**
   It means a `coroutineScope` block does not complete/return until every coroutine launched inside it (via `launch` or `async`) has finished, even though those coroutines don't block the scope's own execution while running. This was verified live: a `launch`-started child coroutine's delayed output appeared, followed by the statement immediately after the `coroutineScope` block — proving the scope waited for the child before returning, despite `launch` itself not blocking. This matters because it prevents coroutines from "leaking" past the logical operation that started them (a common source of bugs with unmanaged threads, which can easily continue running after the function that spawned them has already returned), making resource cleanup and error propagation far more predictable.

## Recommended Next Lesson

[15 — Modules and Packages](../15-Modules-and-Packages/README.md)
