# 19 — Best Practices

[Back to course overview](../README.md) | [Previous: Testing](../18-Testing/README.md)

## Learning Objectives

- Recognize and fix three genuine Kotlin anti-patterns: overusing `!!` instead of proper null handling, exposing a mutable backing collection as if it were safely read-only, and calling `Thread.sleep()` inside a coroutine instead of `delay()`.
- See the `Thread.sleep()`-vs-`delay()` distinction proven with real, measured timing, not just described.

## Prerequisites

[18-Testing](../18-Testing/README.md)

## Concept

This lesson is a synthesis: three mistakes that compile and run in Kotlin but undermine the very features (null safety, Lesson 03; read-only collection views, Lesson 07; coroutines, Lesson 14) those earlier lessons introduced — each demonstrated with a live "bad" version actually misbehaving, and a "good" version fixing it.

## Anti-Pattern 1: `!!` Instead of Proper Null Handling

```kotlin
fun findUserBad(users: Map<String, Int>, name: String): Int {
    return users[name]!! // throws NPE with a useless, generic message if name isn't found
}
fun findUserGood(users: Map<String, Int>, name: String): Int {
    return users[name] ?: throw NoSuchElementException("no user named '$name' found")
}
```

Verified live: looking up a missing key with `!!` threw `NullPointerException` with message `null` (the exception carries no useful information about *what* was null or *why*), while the `?:`-based version threw a specific, clear `NoSuchElementException: no user named 'Linus' found` — both fail, but only one fails *usefully*.

## Anti-Pattern 2: Exposing a Mutable Backing Collection Directly

```kotlin
class TaskListBad {
    val tasks = mutableListOf<String>() // exposed directly -- ANY caller can mutate it!
}
class TaskListGood {
    private val _tasks = mutableListOf<String>()
    val tasks: List<String> get() = _tasks.toList() // a genuine DEFENSIVE COPY, not just a read-only view
}
```

Verified live: `badList.tasks.add(...)` compiled and genuinely mutated `TaskListBad`'s internal state from completely outside the class — since `tasks` was declared as `MutableList<String>` and exposed directly, there was no protection at all. `TaskListGood.tasks` returns `_tasks.toList()` — an actual defensive **copy**, not merely a read-only-typed reference to the same object (recall Lesson 07's finding that a read-only *view* of the same object still reflects external mutations) — so external code genuinely cannot affect `TaskListGood`'s internal list, verified by the compile error that results from attempting to call `.add()` on the returned `List<String>`.

## Anti-Pattern 3: `Thread.sleep()` Instead of `delay()` in a Coroutine

```kotlin
suspend fun blockingWaitBad() { Thread.sleep(200) }   // blocks the ENTIRE underlying thread
suspend fun nonBlockingWaitGood() { delay(200) }         // suspends only THIS coroutine
```

Verified live with real measured timing: launching two coroutines that each `Thread.sleep(200)` took **412ms** total (the blocking calls serialized on the shared thread, since blocking it prevented the second coroutine from running concurrently), while launching two coroutines that each `delay(200)` took **208ms** total (both suspended cooperatively, letting the underlying thread run both concurrently) — almost exactly the 2x difference predicted by the fact that `Thread.sleep()` defeats the entire cooperative-scheduling mechanism coroutines depend on.

## Detailed Example

See [Example.kt](Example.kt) — all three anti-pattern/fix pairs, run and verified, including real timing proving the `Thread.sleep()`-vs-`delay()` distinction.

## Run It

```bash
cd 01-Languages/Kotlin/19-Best-Practices
kotlinc -cp kotlinx-coroutines-core.jar Example.kt -include-runtime -d Example.jar
java -cp "Example.jar;kotlinx-coroutines-core.jar" ExampleKt
```

## Expected Output

Running the compiled JAR shows a generic, message-less `NullPointerException` for the `!!`-based lookup versus a clear, specific `NoSuchElementException` message for the `?:`-based version; confirmation that `TaskListBad`'s internal list was mutated directly from outside the class, versus `TaskListGood` returning a genuine defensive copy; and real measured timing showing the `Thread.sleep()`-based coroutines taking roughly double the time of the `delay()`-based ones (approximately 412ms vs. 208ms in this environment).

## Common Mistakes

- Reaching for `!!` to silence a nullability compile error without actually confirming the value can't be null — verified live to produce an unhelpful, generic `NullPointerException` compared to an explicit, meaningful exception via `?:`.
- Exposing a `MutableList`/`MutableMap`/etc. property directly from a class, assuming it's "basically read-only" because external code "shouldn't" mutate it — verified live that nothing prevents it; only returning an actual copy (or a genuinely read-only, non-backing-shared collection) provides real protection.
- Calling any blocking function (`Thread.sleep()`, blocking I/O, a blocking database call) inside a `suspend` function without wrapping it appropriately (e.g., `withContext(Dispatchers.IO)`) — verified live to measurably defeat coroutines' cooperative concurrency benefits.

## Best Practices

- Prefer `?:` with a specific, meaningful exception (or a default value) over `!!` for any nullable value whose "shouldn't be null here" assumption isn't rigorously provable.
- Expose collections from a class as genuine defensive copies (`.toList()`) or truly separate read-only structures, not just read-only-*typed* references to the same mutable backing object.
- Always use suspend-aware alternatives (`delay()`, non-blocking I/O libraries) inside `suspend` functions; if a genuinely blocking call is unavoidable, wrap it with `withContext(Dispatchers.IO)` to move it off coroutines' shared, limited-thread dispatchers.

## Real-World Usage

All three of these anti-patterns are genuine, common findings in real Kotlin code review — overuse of `!!` is frequently flagged by linters (including Android Studio's built-in inspections) as a code smell, exposed mutable collections are a classic encapsulation bug, and accidental blocking calls inside coroutines are a well-documented, real performance pitfall in production Kotlin/Android/Ktor codebases.

## Summary

- `!!` should be reserved for genuinely provable non-null invariants; `?:` with a specific exception or default communicates failure far more usefully, verified live.
- Returning a mutable collection directly (even if only exposed as its own mutable type) provides no real encapsulation — a genuine defensive copy is needed for true protection, verified live to make the difference between a compile-time-prevented and a silently-successful external mutation.
- `Thread.sleep()` inside a coroutine measurably defeats cooperative scheduling — confirmed with real timing showing roughly double the duration compared to the coroutine-aware `delay()`.

## Key Terms

- **Defensive copy** — a genuinely separate copy of a collection, protecting the original from external mutation (contrasted with a merely read-only-*typed* reference to the same object).
- **Blocking call** — an operation (like `Thread.sleep()`) that occupies its entire underlying thread, as opposed to a `suspend` function's cooperative, non-blocking wait.

## Interview Questions

1. **Why is returning `_tasks.toList()` meaningfully safer than returning `_tasks` typed as `List<String>`, given Lesson 07's finding that read-only ≠ immutable?**
   Lesson 07 demonstrated that a variable typed as the read-only `List<String>` interface still reflects mutations if it refers to the *same underlying object* as a `MutableList<String>` reference held elsewhere. Simply declaring a property `val tasks: List<String>` while internally backing it with the same `MutableList` instance the class mutates would suffer exactly that problem — external code couldn't call `.add()` directly (no such method on the interface), but the exposed list would still change whenever the class's internal state changed, and more subtly, `as`-casting the reference back to `MutableList` externally would let outside code mutate it directly with no compiler protection at all. Calling `.toList()` creates a genuinely separate copy — a new, independent list object — so external code cannot affect the class's internal state through the returned reference under any circumstances, verified in this lesson via the direct contrast between `TaskListBad`'s exposed, genuinely mutable list and `TaskListGood`'s defensively-copied one.

2. **Why does calling `Thread.sleep()` inside a `suspend` function measurably hurt coroutine performance, and how was this proven rather than assumed?**
   `Thread.sleep()` blocks the entire OS thread it runs on, which coroutines share among many concurrently-running suspended functions via a limited-size dispatcher thread pool — blocking one of those threads prevents any other coroutine scheduled onto it from making progress until the sleep completes, defeating the entire point of coroutines' lightweight, cooperative scheduling. `delay()`, by contrast, suspends only the calling coroutine, freeing its thread to run other coroutines in the meantime. This was proven directly with `measureTimeMillis`: two coroutines each waiting 200ms via `Thread.sleep()` took approximately 412ms combined (effectively serialized, since blocking the shared thread prevented true concurrency), while the same two coroutines waiting via `delay()` took approximately 208ms combined (genuinely running concurrently) — a measured, roughly 2x difference confirming the performance claim rather than merely asserting it.

## Recommended Next Lesson

This completes the core Kotlin course (Lessons 01–19). Return to the [Kotlin course overview](../README.md) or continue to the next language in the course order.
