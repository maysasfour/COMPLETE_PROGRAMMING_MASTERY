# 14 — Concurrency (No Built-in Concurrency in Base MATLAB/Octave)

[Back to course overview](../README.md) | [Previous: Generics](../13-Generics/README.md)

## Honest Note

Base MATLAB (the language and interpreter you get without any paid add-on toolbox) is **single-threaded for user code**. There is no `async`/`await`, no green threads/goroutines, no built-in thread-pool, and no language-level primitive for spawning concurrent user code, comparable to Python's `asyncio`/`threading`, JavaScript's event loop, Go's goroutines, or Java's `Thread`/`ExecutorService`. GNU Octave (used for every verified example in this course) has the same limitation — it is, if anything, even less concurrent than MATLAB by default.

This is a genuine, documented gap being disclosed here explicitly rather than glossed over, per this repository's own convention of calling out missing language features (see [Lesson 13 — Generics](../13-Generics/README.md) for the same treatment of MATLAB's other major gap).

## What Real MATLAB Offers (Requires a Paid Toolbox — Not Verifiable in This Course)

- **Parallel Computing Toolbox** — adds `parfor` (a parallel `for` loop across worker processes), `parfeval`/`parpool` (explicit async task submission to a worker pool), and `spmd` blocks (single-program-multiple-data across workers). This is a **separate, commercially licensed add-on** on top of MATLAB itself — exactly the kind of proprietary dependency this repository's [BUILD_STATUS.md](../../../BUILD_STATUS.md) already disclosed for base MATLAB itself. It is not available to verify in this environment, and Octave does not implement it.
- Internally, many of MATLAB's own built-in numeric functions (large matrix multiplication, FFTs, linear solves) are multi-threaded under the hood via optimized BLAS/LAPACK libraries — but that parallelism is invisible to and not controllable by ordinary user code; it's an implementation detail of functions like `*` and `\`, not a concurrency feature you can build with.

## What Base MATLAB/Octave Actually Gives You

- **`tic`/`toc`** for timing code (used throughout this course's own examples where relevant), but no scheduling primitive.
- Calling external processes via `system(...)` runs another OS process, which does execute concurrently with MATLAB from the OS's point of view — but that's OS-level process spawning, not a language concurrency model, and MATLAB has no built-in way to `await` or message-pass with that process beyond capturing its final stdout/exit code when it finishes.
- **Vectorization** (Lesson 07) is the idiomatic MATLAB substitute for "process many things at once" — instead of parallelizing a loop across threads, you restructure the loop into one whole-array operation (`A .* B` instead of a `for` loop element by element), which both runs faster (single optimized C/BLAS call instead of interpreted loop overhead) and sidesteps the entire concurrency question for the extremely common case of "apply the same operation to every element."

## Real-World Implication

For genuinely parallel/concurrent numerical workloads (Monte Carlo simulations across independent trials, batch processing many independent files), real-world MATLAB users buy Parallel Computing Toolbox and use `parfor`. Without it — and always in Octave — the practical, honest answer for "how do I make this MATLAB code use more than one core" is: vectorize it (Lesson 07), or shell out to a genuinely concurrent external tool via `system(...)` and orchestrate at the OS level.

## Suggested Next Lesson

[15 — Modules and Packages](../15-Modules-and-Packages/README.md)
