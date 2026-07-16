# Exercise 01 — Concurrent Downloads (Simulated)

[Back to lesson](../README.md)

## Task

Write an `asyncio`-based program that simulates downloading three files with different (simulated) network delays:

```python
files = {
    "small.txt": 0.5,
    "medium.txt": 1.0,
    "large.txt": 1.5,
}
```

1. Write an `async def download(name, delay)` coroutine that prints `"Downloading {name}..."`, awaits `asyncio.sleep(delay)` to simulate the network wait, then prints `"Finished {name}"` and returns a string like `"{name}: 200 OK"`.
2. Write an `async def main()` that runs all three downloads **concurrently** using `asyncio.gather`, times the whole operation with `time.perf_counter()`, and prints the total elapsed time plus all three results.
3. In a comment, predict (before running) roughly how long the *concurrent* version should take compared to running all three sequentially (summing the delays), and why.

## Reflection Question

If `small.txt` failed with an exception partway through its download, what would happen to `medium.txt` and `large.txt`'s downloads with `asyncio.gather`'s default behavior? (You don't need to implement this — research or reason about `asyncio.gather`'s `return_exceptions` parameter and write a short answer.)

## Deliverable

A runnable `.py` file with `download()`, `main()`, and printed timing/results. Attempt this before checking `Solutions/solution-01.py`.
