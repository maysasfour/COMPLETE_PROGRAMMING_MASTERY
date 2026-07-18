# Exercises — Functions (Methods, Blocks, Procs, Lambdas)

Attempt these yourself before checking [../Solutions](../Solutions/README.md).

## Exercise 1 — A `measure` Method Taking a Block

Write a method `measure(label)` that `yield`s to its block, times how long the block takes (using `Time.now`), and prints `"#{label}: #{elapsed}s"` after the block finishes, returning the block's own return value unchanged. Call it wrapping a block that sums `1..1_000_000`, and print both the timing message and the returned sum.

## Exercise 2 — Counter Factory Proving Proc vs. Lambda `return`

Write a method `make_incrementer` that returns a **lambda** (not a Proc) closing over a local counter variable starting at 0, incrementing and returning it each call. Then write a second method `broken_incrementer` that does the same thing but with a **Proc** whose body uses an explicit `return` — call it once and show (in a comment or printed message) that the `return` inside the Proc terminates `broken_incrementer` itself, not just the Proc, so a second call to the returned Proc is never actually going to happen; contrast this with the lambda version, which can be called repeatedly and increments correctly every time.
