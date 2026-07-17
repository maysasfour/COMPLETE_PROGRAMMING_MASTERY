# 03 — OS Fundamentals (Processes, Threads, Scheduling)

[Back to module overview](../README.md) | [Previous: Networking](../02-Networking/README.md)

## Beginner: The OS Scheduler Is Real, and Its Interleaving Causes Real Bugs

The operating system's scheduler decides, moment to moment, which thread actually runs on which CPU core — and a program has no control over the exact interleaving. This lesson demonstrates that reality with a real, measured bug: multiple threads incrementing a shared counter lose real updates because of how the scheduler interleaves their execution, verified live across multiple runs, then fixed properly.

## How Many Cores Does This Machine Actually Have?

```java
int cores = Runtime.getRuntime().availableProcessors();
```

Verified live:

```
Runtime.getRuntime().availableProcessors() = 12
```

With 12 real cores, the 4 threads used in this lesson's demo are genuinely capable of running truly simultaneously, not just time-sliced on a single core — making the race condition below even more directly observable as genuine concurrent execution, not just rapid switching.

## The Violation: A Real, Measured Race Condition

```java
static int sharedCounterViolation = 0;
static void incrementManyTimesViolation() {
    for (int i = 0; i < 100_000; i++) {
        sharedCounterViolation++; // read-modify-write: NOT atomic
    }
}
```

Four threads, each incrementing the shared counter 100,000 times, should produce a final count of exactly 400,000. Verified live, across multiple separate runs:

```
Expected final count: 400000
ACTUAL final count:   145187  <- BUG: lost updates from unsynchronized concurrent access!
```
```
Expected final count: 400000
ACTUAL final count:   166597  <- BUG: lost updates from unsynchronized concurrent access!
```
```
Expected final count: 400000
ACTUAL final count:   119379  <- BUG: lost updates from unsynchronized concurrent access!
```

Every run lost a large fraction of the intended increments — `counter++` is really three separate machine steps (read the current value, add 1, write the new value back), and the OS scheduler can switch to a different thread in between any of those steps. When two threads both read the same value before either writes back, one thread's increment is silently lost.

## The Fix: `AtomicInteger`

```java
static AtomicInteger sharedCounterFixed = new AtomicInteger(0);
static void incrementManyTimesFixed() {
    for (int i = 0; i < 100_000; i++) {
        sharedCounterFixed.incrementAndGet(); // atomic -- cannot be interleaved
    }
}
```

Verified live, across the same multiple runs, always exactly correct:

```
Expected final count: 400000
ACTUAL final count:   400000  <- correct: no lost updates
```

`AtomicInteger` performs the read-modify-write as one indivisible hardware-level operation (via a CPU compare-and-swap instruction) — the scheduler can still interleave threads at any point, but there is no longer a multi-step operation for it to interrupt in the middle of.

## Detailed Example

See [Example.java](Example.java) — the real, measured race condition and its fix.

## Run It

```bash
cd 20-Computer-Science-Fundamentals/03-OS-Fundamentals
javac Example.java
java Example
```

Run it a few times — the exact lost-update count in the violation section will vary (it depends on real thread scheduling), but it will very reliably be far less than 400,000.

## Expected Output

The real core count reported by the JVM; the violation section reporting a final count well below 400,000 (varying by run); the fixed section reliably reporting exactly 400,000.

## Common Mistakes

- Assuming `counter++` is a single, indivisible operation — verified live, across multiple runs, to lose a large fraction of increments under real concurrent access.
- Assuming a race condition is rare or theoretical — verified live to occur reliably, every single run, losing tens of thousands of increments each time.
- Using `synchronized` or atomic types only "when it seems necessary" rather than whenever shared mutable state is genuinely accessed by multiple threads — this lesson's bug occurs 100% of the time under real concurrent load, not occasionally.

## Best Practices

- Use `java.util.concurrent.atomic` classes (`AtomicInteger`, `AtomicLong`, etc.) for simple shared counters accessed by multiple threads.
- Use `synchronized` blocks/methods, or higher-level concurrency utilities, for more complex shared state that atomic classes alone can't cover.
- Verify concurrency-sensitive code with a real, repeatable concurrent test (as this lesson does), rather than reasoning about thread safety only in the abstract.

## Real-World Usage

Race conditions on shared counters/state are a genuine, common category of real production bug — anything from analytics counters undercounting events to more serious data-integrity failures in shared caches or connection pools. Understanding that the OS scheduler's interleaving is real and unpredictable (not just a theoretical concern) is foundational to writing correct concurrent code, directly relevant to [12-Design-Patterns Lesson 01](../../12-Design-Patterns/01-Singleton/README.md)'s similarly-verified singleton race condition.

## Summary

- Multiple threads incrementing a shared, unsynchronized counter were shown, live and repeatably across multiple runs, to lose a large fraction of their intended increments — a real, measured consequence of OS thread scheduling interleaving a non-atomic read-modify-write operation.
- `AtomicInteger` was shown, live, to reliably produce the exact correct count every time, by making the increment operation genuinely indivisible.

## Key Terms

- **Process** — an independent, isolated running program with its own memory space.
- **Thread** — a unit of execution within a process; threads within the same process share memory, which is what makes race conditions possible.
- **Race condition** — a bug where the outcome depends on the unpredictable relative timing/interleaving of concurrent operations.
- **Atomic operation** — an operation that completes as a single, indivisible step from the perspective of other threads, immune to scheduler interleaving.

## Interview Questions

1. **Why isn't `counter++` atomic, and how was a real bug from this demonstrated?**
   `counter++` actually involves three separate steps: reading the current value, adding 1, and writing the new value back. These are not a single CPU instruction, and the OS scheduler can switch to a different thread at any point between them. This was demonstrated concretely: four threads each incremented a shared counter 100,000 times (expecting a final total of 400,000), but verified live across multiple separate runs, the actual final count was consistently and substantially lower (e.g., `145187`, `166597`, `119379`) — proof that many increments were genuinely lost because two threads sometimes read the same value before either had written its update back.

2. **How does `AtomicInteger` prevent the race condition, and how was the fix verified?**
   `AtomicInteger.incrementAndGet()` performs the read-modify-write as a single, indivisible hardware operation (typically implemented via a CPU compare-and-swap instruction), so there is no multi-step window for the scheduler to interleave another thread's conflicting update into. This was verified live: running the identical four-thread, 100,000-increments-each scenario using `AtomicInteger` instead of a plain `int` reliably produced the exact correct total of `400000` across multiple separate runs, with zero lost updates, in direct contrast to the plain `int` version's consistent and substantial undercounting.

## Recommended Next Lesson

[04 — CAP Theorem and Distributed Systems Basics](../04-CAP-Theorem-and-Distributed-Systems/README.md)
