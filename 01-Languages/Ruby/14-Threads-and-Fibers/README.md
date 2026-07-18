# 14 — Threads and Fibers

[Back to course overview](../README.md) | [Previous: Duck Typing](../13-Duck-Typing/README.md)

## Learning Objectives

- Understand Ruby's GVL (Global VM Lock, Ruby's name for what Python calls the GIL) and measure directly that it prevents true CPU-bound parallelism across `Thread`s.
- Measure directly that `Thread` still speeds up I/O-bound work, since the GVL is released during blocking I/O.
- Use `Fiber` — Ruby's cooperative-concurrency primitive with explicit `Fiber.yield`/`resume` — and see it stop resumably at each yield point.

## Prerequisites

[13-Duck-Typing](../13-Duck-Typing/README.md)

## Concept

MRI/CRuby (this course's `RUBY_ENGINE`, confirmed in Lesson 01) has a **GVL** (Global VM Lock): only one thread executes Ruby bytecode at any instant, regardless of how many `Thread` objects exist or how many CPU cores the machine has — the same fundamental limitation as Python's GIL, covered elsewhere in this repository. This lesson doesn't just assert that; it **measures** it directly on real hardware (12 cores in this environment): four CPU-bound `Thread`s take essentially the *same* wall-clock time as running the identical work four times sequentially, a ~1x "speedup" instead of the ~4x a true 4-core parallel win would show.

The GVL **is** released during blocking I/O (file/network waits, `sleep`), so `Thread` genuinely helps for I/O-bound work — also measured directly, showing a real ~3x speedup for four concurrent sleeps.

**`Fiber`** is Ruby's separate, cooperative-concurrency primitive: a fiber runs until it explicitly calls `Fiber.yield`, at which point control returns to whoever called `.resume`, which can later `.resume` it again to continue exactly where it left off. Unlike `Thread`, nothing runs "in the background" between yields — a fiber only ever executes while actively resumed.

## Detailed Example

See [example.rb](example.rb) — a genuinely CPU-bound loop (40 million iterations of arithmetic, no I/O at all) run once, then four times sequentially, then four times across four real `Thread`s, with wall-clock time measured for all three and the speedup ratio computed directly; the same three-way comparison repeated with `sleep`-based I/O-bound work instead, showing the opposite result; and a `Fiber` demonstrating two `Fiber.yield` pause points plus a genuine `FiberError` caught from resuming an already-finished fiber.

## Run It

```bash
cd 01-Languages/Ruby/14-Threads-and-Fibers
ruby example.rb
```

Note: the CPU-bound benchmark portion takes roughly 3 minutes to run on this environment's hardware (40 million arithmetic iterations, repeated 9 times across the various comparisons) — this is a genuinely CPU-heavy example by design, not a bug.

## Expected Output (real, captured)

```
CPU cores: 12
one sequential run:  19.334s
four sequential runs: 88.596s
four CONCURRENT threads: 91.789s
speedup from threading: 0.97x (a true 4-core parallel win would be ~4x; the GVL means it isn't)
four sequential sleeps: 1.566s
four concurrent sleep-threads: 0.487s
I/O speedup: 3.21x (near 4x -- the GVL IS released during blocking I/O)
fiber: step 1
paused after step 1
fiber: step 2
paused after step 2
fiber finished
caught: FiberError: attempt to resume a terminated fiber
```

This is a real, measured result on a 12-core machine, not an assumed one: four CPU-bound threads produced a 0.97x "speedup" (statistically indistinguishable from running sequentially, and the *opposite* of the 12x a true 12-core parallel win could theoretically approach) — a direct, live confirmation of the GVL's effect. The same four-way comparison against `sleep`-based I/O work produced a real 3.21x speedup, confirming the GVL genuinely is released during blocking I/O.

## Common Mistakes

- Assuming `Thread.new` gives real CPU parallelism in MRI/CRuby — it doesn't, for pure computation; verified directly above.
- Using threads for CPU-bound work expecting a multi-core speedup, then being confused when performance doesn't improve (or gets slightly worse from thread-switching overhead) — use process-based parallelism (multiple OS processes, e.g. via `fork` or a background job queue) for genuine CPU parallelism in Ruby instead.
- Forgetting a `Fiber` raises `FiberError` if resumed after it has already run to completion — verified live above.

## Best Practices

- Use `Thread` for I/O-bound concurrency (overlapping network/file waits) — genuinely effective, as measured.
- Use separate OS processes (not threads) for genuine CPU-bound parallelism in Ruby, or consider JRuby/TruffleRuby (alternate Ruby implementations without MRI's GVL) if thread-based CPU parallelism is a hard requirement.
- Reach for `Fiber` (or higher-level abstractions built on it, like `Enumerator`) for cooperative, explicitly-controlled step-by-step execution, not for performance.

## Real-World Usage

Web servers like Puma use a hybrid of processes and threads specifically because of this GVL behavior — multiple worker *processes* for real CPU parallelism, multiple *threads* per process for I/O-bound request concurrency; Ruby's own `Enumerator` (used throughout Lesson 07/12) is implemented internally using `Fiber`.

## Summary

- MRI/CRuby's GVL means only one thread executes Ruby bytecode at a time — measured directly to show CPU-bound threads gain no real speedup (0.97x).
- The GVL is released during blocking I/O, so threads genuinely help I/O-bound work — measured directly at 3.21x for four concurrent sleeps.
- `Fiber` provides cooperative concurrency via explicit `Fiber.yield`/`resume`, with a genuine `FiberError` on resuming a finished fiber.

## Key Terms

- **GVL (Global VM Lock)** — MRI/CRuby's lock ensuring only one thread executes Ruby bytecode at a time; Ruby's name for the same concept Python calls the GIL.
- **`Fiber`** — a cooperative concurrency primitive resumed and paused explicitly via `.resume`/`Fiber.yield`.

## Interview Questions

1. **Does creating multiple Ruby `Thread`s give real parallel speedup for CPU-bound work?**
   No, not on MRI/CRuby — the GVL ensures only one thread executes Ruby bytecode at a time regardless of core count, measured directly in this lesson: four CPU-bound threads took 91.8s, essentially the same as 88.6s for four sequential runs (a 0.97x "speedup"), on a real 12-core machine. Threads only help when work is I/O-bound, since the GVL is released during blocking I/O waits — also measured directly, at a real 3.21x speedup for four concurrent `sleep`s.

2. **What's the difference between a `Thread` and a `Fiber` in Ruby?**
   A `Thread` is scheduled preemptively by the VM (and, subject to the GVL, may interleave with other threads at almost any point); a `Fiber` is cooperative — it only ever runs while explicitly `.resume`d, and only pauses at an explicit `Fiber.yield` call, with nothing implicitly happening in the background between those points. This lesson demonstrates a fiber pausing at two separate yield points and resuming exactly where it left off, plus a real `FiberError` when a caller tries to resume it a fourth time after it has already finished.

## Recommended Next Lesson

[15 — Modules and Gems](../15-Modules-and-Gems/README.md)
