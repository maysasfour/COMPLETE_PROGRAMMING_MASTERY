"""
Lesson 14 - Async and Concurrency
Demonstrates: a basic async def/await coroutine, sequential vs. concurrent
awaiting (plain await vs. asyncio.gather()), and a brief timed comparison
showing why threading (I/O-bound) and multiprocessing (CPU-bound) are
different tools from asyncio - see the README's table for the full
threading vs. multiprocessing vs. asyncio breakdown; this file focuses on
asyncio itself since it's the only one of the three needing new syntax.

Run with:
    python example.py

Expected output (timings are approximate and will vary slightly by machine
load - the important part is which number is roughly double the other):
    --- async def and await ---
    Hello...
    ...world!

    --- sequential await (one after another) ---
    Task A: starting
    Task A: done
    Task B: starting
    Task B: done
    sequential total time -> about 1.0s (0.5 + 0.5 summed)

    --- asyncio.gather() (concurrent) ---
    Task A: starting
    Task B: starting
    Task B: done
    Task A: done
    concurrent total time -> about 0.5s (the longest single wait, not the sum)

    --- threading vs. multiprocessing (see README for the full table) ---
    threading: good for I/O-bound waits, but the GIL blocks true CPU parallelism
    multiprocessing: separate processes, separate GILs -> real CPU-bound parallelism
    asyncio: single thread, cooperative - scales to many concurrent I/O waits cheaply
"""

import asyncio
import time


async def say_hello():
    print("Hello...")
    await asyncio.sleep(0.3)  # pauses THIS coroutine; the event loop is free to run others meanwhile
    print("...world!")


async def fetch_data(name, delay):
    print(f"{name}: starting")
    await asyncio.sleep(delay)  # simulates an I/O wait, e.g. a network call
    print(f"{name}: done")
    return f"{name} result"


async def main():
    print("--- async def and await ---")
    await say_hello()

    print("\n--- sequential await (one after another) ---")
    start = time.perf_counter()
    # Each await fully completes before the next call even starts - this
    # is sequential, NOT concurrent, despite both being async functions.
    await fetch_data("Task A", 0.5)
    await fetch_data("Task B", 0.5)
    elapsed = time.perf_counter() - start
    print(f"sequential total time -> about {elapsed:.1f}s (0.5 + 0.5 summed)")

    print("\n--- asyncio.gather() (concurrent) ---")
    start = time.perf_counter()
    # gather() starts both coroutines up front and interleaves their waits,
    # so total time tracks the LONGEST individual wait, not the sum of both.
    await asyncio.gather(
        fetch_data("Task A", 0.5),
        fetch_data("Task B", 0.3),
    )
    elapsed = time.perf_counter() - start
    print(f"concurrent total time -> about {elapsed:.1f}s (the longest single wait, not the sum)")

    print("\n--- threading vs. multiprocessing (see README for the full table) ---")
    print("threading: good for I/O-bound waits, but the GIL blocks true CPU parallelism")
    print("multiprocessing: separate processes, separate GILs -> real CPU-bound parallelism")
    print("asyncio: single thread, cooperative - scales to many concurrent I/O waits cheaply")


asyncio.run(main())
