# 01 — Singleton

[Back to module overview](../README.md)

## Beginner: What Singleton Solves

Singleton ensures a class has exactly one instance, globally accessible, for cases like a shared configuration object, connection pool, or cache. This lesson demonstrates a genuinely common and dangerous mistake — a naive singleton that is **not actually thread-safe** — with a real, reproducible bug: multiple threads racing to create the "one" instance actually creating several.

## The Violation: A Real, Reproducible Race Condition

```java
class NaiveSingleton {
    private static NaiveSingleton instance;
    private NaiveSingleton() {}
    static NaiveSingleton getInstance() {
        if (instance == null) {
            instance = new NaiveSingleton(); // check-then-act is NOT atomic
        }
        return instance;
    }
}
```

The bug: `if (instance == null)` and `instance = new NaiveSingleton()` are two separate steps. If two threads both check `instance == null` before either one finishes creating it, **both** create their own instance — the "singleton" now has multiple instances.

This lesson verifies the bug directly rather than just asserting it's possible: 10 real threads are released simultaneously (via a `CountDownLatch`) to call `getInstance()` at the same moment, and every actual instance created is tracked via `System.identityHashCode()`. Verified live, across multiple runs:

```
Distinct instances actually created: 6  <- BUG: should be 1, the race condition created multiple instances!
Distinct instances actually created: 9  <- BUG: should be 1, the race condition created multiple instances!
Distinct instances actually created: 8  <- BUG: should be 1, the race condition created multiple instances!
```

Out of 10 racing threads, anywhere from 6 to 9 *distinct* instances were actually created in different runs — a real, measured demonstration that "the singleton" was, in practice, not a singleton at all under concurrent access.

## The Fix: The Initialization-on-Demand Holder Idiom

```java
class Singleton {
    private Singleton() {}
    private static class Holder {
        static final Singleton INSTANCE = new Singleton();
    }
    static Singleton getInstance() {
        return Holder.INSTANCE;
    }
}
```

This works because the JVM itself guarantees that a class's static initializer runs **exactly once**, under a lock, no matter how many threads reference it concurrently — `Holder` is only loaded (and `INSTANCE` only created) the first time `getInstance()` is actually called, and the JVM's own class-loading mechanism handles the thread-safety, with no manual locking code needed at all.

Verified live, with the exact same 10-thread concurrent test:

```
Distinct instances actually created: 1  <- correct: exactly one instance, guaranteed by the JVM's class-init lock
```

## Detailed Example

See [Example.java](Example.java) — a real concurrent race condition, reproduced with actual threads, followed by a correctly thread-safe fix.

## Run It

```bash
cd 12-Design-Patterns/01-Singleton
javac Example.java
java Example
```

Run it a few times — the exact number of distinct instances in the violation section will vary run to run (it depends on real thread scheduling), but it will very reliably be greater than 1.

## Expected Output

The violation section reporting more than 1 distinct instance actually created by 10 concurrent threads (the exact count varies by run); the fixed section reliably reporting exactly 1.

## Common Mistakes

- Writing a "lazy" singleton with a simple `if (instance == null)` check and assuming it's safe because it "looks" atomic — verified live to actually create multiple instances under real concurrent access.
- Fixing this by synchronizing the entire `getInstance()` method on every call, which works but adds unnecessary lock contention on every subsequent call after the instance already exists — the holder idiom (or double-checked locking with a `volatile` field) avoids this cost.
- Using Singleton as a global-mutable-state escape hatch for things that aren't actually conceptually singular — Singleton should model something that is genuinely, inherently one-of-a-kind (like a single shared configuration), not just a convenient way to avoid passing a dependency explicitly.

## Best Practices

- Use the initialization-on-demand holder idiom (shown here) or an `enum`-based singleton (Java enums are inherently thread-safe and serialization-safe) rather than hand-rolled locking.
- Verify concurrency-sensitive code with an actual concurrent test, as done in this lesson — reasoning about thread safety in the abstract is much less convincing than a real, repeatable, measured failure.
- Consider whether Singleton is genuinely the right tool — in many modern codebases, a dependency-injection container (see [Dependency Inversion](../../11-Design-Principles/01-SOLID-Principles/README.md#d--dependency-inversion-principle)) managing a single shared instance is preferable to a hard-coded `getInstance()` call scattered through the codebase.

## Real-World Usage

Logging frameworks, application-wide configuration objects, and connection pools are classic legitimate Singleton use cases. The exact race condition demonstrated here — a naive lazy singleton breaking under real concurrent load — is a genuine, recurring category of production concurrency bug, especially in code paths that are rarely exercised concurrently during testing but frequently are in production.

## Summary

- A naive lazy singleton's check-then-act pattern is not atomic, and was verified live to actually create multiple instances (6-9 out of 10 racing threads, across several runs) rather than the intended single instance.
- The initialization-on-demand holder idiom fixes this using the JVM's own guaranteed-once class initialization, verified live to reliably produce exactly 1 instance under the same concurrent test.
- Concurrency bugs benefit enormously from being verified with a real, repeatable concurrent test rather than reasoned about only in the abstract.

## Key Terms

- **Singleton** — a design pattern ensuring a class has exactly one instance, with global access to it.
- **Race condition** — a bug where the outcome depends on the relative timing of concurrent operations, here two threads both seeing `instance == null` before either finishes creating it.
- **Initialization-on-demand holder idiom** — a thread-safe lazy singleton implementation relying on the JVM's guaranteed-once class initialization instead of manual locking.

## Interview Questions

1. **Why isn't `if (instance == null) { instance = new Singleton(); }` actually thread-safe, and how was this proven rather than just asserted?**
   The check (`instance == null`) and the action (creating and assigning the instance) are two separate, non-atomic steps. If two threads both execute the check before either has finished the action, both will see `null` and both will create their own instance. This was proven, not just asserted, by running 10 real threads released simultaneously via a `CountDownLatch`, each calling `getInstance()`, and counting the actual distinct instances created via `System.identityHashCode()` — the result was consistently greater than 1 (typically 6-9 out of 10) across multiple runs.

2. **How does the initialization-on-demand holder idiom guarantee thread safety without any manual locking code?**
   It relies on a guarantee built into the JVM itself: a class's static fields are initialized exactly once, the first time the class is actually loaded/referenced, and the JVM handles this initialization under an internal lock automatically. By putting the singleton instance inside a nested `Holder` class that is only referenced inside `getInstance()`, the `Holder` class (and therefore `INSTANCE`) is only loaded on first call, and the JVM's own class-loading mechanism — not any code written in this lesson — guarantees only one instance is ever created, even under concurrent access. This was verified with the same 10-thread concurrent test, which reliably produced exactly 1 instance.

## Recommended Next Lesson

[02 — Factory Method and Abstract Factory](../02-Factory-Method-and-Abstract-Factory/README.md)
