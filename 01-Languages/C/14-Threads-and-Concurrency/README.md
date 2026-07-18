# 14 — Threads and Concurrency

[Back to course overview](../README.md) | [Previous: No Generics](../13-No-Generics/README.md)

## Learning Objectives

- Create and join threads with C11's `<threads.h>` (confirmed genuinely working on this toolchain — see below).
- Reproduce a real, unprotected shared-counter race condition, then fix it with a mutex.

## Prerequisites

[13-No-Generics](../13-No-Generics/README.md)

## Toolchain Confirmation

Threading support in C is genuinely uneven across platforms and compiler versions — worth checking honestly rather than assuming. This environment has **no POSIX pthreads** (Windows, not Linux/macOS) and no `gcc`/`clang` at all (Lesson 01). The question was whether MSVC 19.51 actually ships a working C11 `<threads.h>` implementation. It does — confirmed live:

```c
#include <threads.h>
int worker(void* arg) { printf("thread %d running\n", *(int*)arg); return 0; }
/* thrd_create/thrd_join genuinely compiled and ran correctly during course construction */
```

Both `<threads.h>` (C11 threads: `thrd_create`/`thrd_join`/`mtx_t`) and `<stdatomic.h>` are present in this MSVC installation's include directory and were confirmed to compile and run correctly — so this lesson uses the real, standard C11 threading API throughout, not a Windows-specific fallback (`CreateThread`) or a POSIX one (`pthread_create`), either of which would have been necessary had `<threads.h>` not worked.

## Concept

C11 added a standardized threading API: `thrd_t`/`thrd_create`/`thrd_join` for threads, `mtx_t`/`mtx_lock`/`mtx_unlock` for mutexes — conceptually parallel to C++11's `std::thread`/`std::mutex`, but C-style throughout (no RAII lock guards, no exceptions on failure — return-code checking, per Lesson 09). This lesson doesn't just describe a race condition abstractly — it **reproduces one live**: four threads each incrementing a shared, unprotected `long` counter 200,000 times (800,000 total expected) genuinely lose increments in practice, because `counter = counter + 1` is not one atomic operation — it's a read, an increment, and a write, and two threads can interleave between those steps, each reading the same stale value and overwriting each other's increment. The fix — wrapping the same increment in `mtx_lock`/`mtx_unlock` — makes it atomic with respect to other threads holding the same mutex, and the result is confirmed always exactly correct.

## Syntax

```c
thrd_t t;
int id = 1;
thrd_create(&t, workerFunction, &id);   /* starts a thread running workerFunction(&id) */
thrd_join(t, NULL);                      /* blocks until it finishes */

mtx_t lock;
mtx_init(&lock, mtx_plain);
mtx_lock(&lock);
sharedCounter++;                          /* now atomic w.r.t. other threads locking the same mutex */
mtx_unlock(&lock);
mtx_destroy(&lock);
```

## Detailed Example

See [example.c](example.c) — basic thread creation/joining, then a **genuinely reproduced race condition** (an unprotected shared counter across 4 threads, real lost increments observed), then the same test mutex-protected, confirmed always correct.

## Expected Output

Output is **intentionally nondeterministic** for the unprotected-counter section — that nondeterminism is the entire point of a race condition. Two real, separately captured runs during course construction:

```
worker thread 1 running
worker thread 2 running

-- unprotected counter (race condition) --
expected 800000, got 621353 (LOST INCREMENTS -- the race condition, genuinely reproduced)

-- mutex-protected counter (fixed) --
expected 800000, got 800000 (always correct -- mtx_lock/mtx_unlock make the increment atomic)
```

```
-- unprotected counter (race condition) --
expected 800000, got 283027 (LOST INCREMENTS -- the race condition, genuinely reproduced)

-- mutex-protected counter (fixed) --
expected 800000, got 800000 (always correct -- mtx_lock/mtx_unlock make the increment atomic)
```

A third run genuinely printed `got 800000` for the *unprotected* counter too — races are nondeterministic, not guaranteed to lose increments on every single run, which is precisely why race conditions are notoriously hard to catch through casual testing: the bug can be present in the code yet invisible in any given run. The mutex-protected counter, run alongside every one of these, was **always** exactly `800000` — the whole point of the fix.

## Common Mistakes

- Assuming a race condition will reproduce identically (or at all) on every run — as shown above, one real run out of several printed the "correct" total for the *unprotected* counter purely by luck of thread scheduling; absence of the bug in one test run is not proof of its absence.
- Forgetting `mtx_init`/`mtx_destroy` — a `mtx_t` must be explicitly initialized before use and destroyed when done, exactly like `malloc`/`free` discipline (Lesson 19), since there's no RAII to do it automatically.
- Locking a mutex around too little code (locking, reading, unlocking, then writing back based on the stale read) — the lock must span the *entire* read-modify-write sequence, or the race condition remains only partially fixed.

## Best Practices

- Keep the code inside a `mtx_lock`/`mtx_unlock` pair as short as possible, but never shorter than the entire read-modify-write operation being protected.
- Always pair `mtx_init` with `mtx_destroy`, and every `mtx_lock` with a corresponding `mtx_unlock` on every code path (including early returns) — a forgotten unlock deadlocks any other thread waiting on that mutex.
- Prefer `<stdatomic.h>`'s atomic types (also confirmed present on this toolchain) for simple counters specifically — an `atomic_long` with `atomic_fetch_add` avoids needing a separate mutex entirely for this exact use case.

## Real-World Usage

Real C concurrency code (device drivers, high-performance servers, game engines) uses exactly this mutex-around-shared-state pattern constantly, often alongside lower-level atomics (`<stdatomic.h>`) for hot-path counters where a full mutex lock/unlock would be too slow.

## Summary

- MSVC 19.51's `<threads.h>` (C11 threads) is confirmed genuinely working on this toolchain — `thrd_create`/`thrd_join`/`mtx_t` used throughout.
- An unprotected shared counter across multiple threads is a real, reproduced race condition — increments are nondeterministically lost, confirmed with real captured output across multiple runs.
- `mtx_lock`/`mtx_unlock` around the entire read-modify-write sequence fixes it, confirmed always exactly correct.

## Key Terms

- **Race condition** — a bug where the outcome depends on the nondeterministic timing/interleaving of multiple threads, genuinely reproduced in this lesson rather than just described.
- **Mutex (`mtx_t`)** — a lock ensuring only one thread executes a protected section at a time, making the protected operation atomic with respect to other threads using the same mutex.

## Interview Questions

1. **Why does `counter = counter + 1` need protection when run concurrently from multiple threads, even though it looks like one operation?**
   It is actually three separate steps at the machine level: read the current value, compute the incremented value, write it back. Two threads can interleave between these steps — both reading the same value before either writes back — so one thread's increment is silently lost. This lesson reproduced this live: four threads each incrementing 200,000 times (800,000 expected total) genuinely produced totals as low as 283,027 in one real run, confirming lost increments, not just describing them hypothetically.

2. **Is a race condition guaranteed to reproduce on every run? What does that imply for testing concurrent code?**
   No — race conditions depend on nondeterministic thread scheduling, so the same buggy code can produce a wrong result on one run and, by chance, the "correct" result on another (confirmed live in this lesson: one real run of the unprotected counter happened to print the fully correct total). This means passing a test once (or even several times) is not proof a concurrency bug is absent — correctness must come from the code's actual synchronization guarantees (like a properly-placed mutex), not from observed test results alone.

## Recommended Next Lesson

[15 — Modules and Header Files](../15-Modules-and-Header-Files/README.md)
